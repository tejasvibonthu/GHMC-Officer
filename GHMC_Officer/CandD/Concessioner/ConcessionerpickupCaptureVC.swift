//
//  ConcessionerpickupCaptureVC.swift
//  GHMC_Officer
//
//  Created by Haritej on 27/06/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//

import UIKit
import SearchTextField
class ConcessionerpickupCaptureVC: UIViewController {

  @IBOutlet weak var afterPickupImgView: CustomImagePicker!

  @IBOutlet weak var beforePickupImgView: CustomImagePicker!
 
  @IBOutlet weak var ticketIdLb: UILabel!
  @IBOutlet weak var locationLb: UILabel!
  
  @IBOutlet weak var dateLb: UILabel!
  @IBOutlet weak var vehicleNoTxt: SearchTextField!
  
  @IBOutlet weak var afterPickupContainerView: UIView!
  {
    didSet
    {
      afterPickupContainerView.isHidden = true
    }
  }
  var ticketData : PickupcaptureListStruct.TicketList?
  var vehicleId : String!
  var isLastTrip : Bool?
  override func viewDidLoad() {
        super.viewDidLoad()
    afterPickupImgView.parentViewController = self
    beforePickupImgView.parentViewController = self
        configureUI()
        configureSearchTextField()
    }
  
  //MARK:- Helper methods
  func configureUI()
  {
    ticketIdLb.text = ticketData?.ticketID
    locationLb.text = ticketData?.location
    dateLb.text = ticketData?.createdDate
    afterPickupImgView.parentViewController = self
    beforePickupImgView.parentViewController = self
    
  }
  func configureSearchTextField()
  {
    let filterStrings = ticketData?.listVehicles?.compactMap({$0.vehicleNo})
    if let filte = filterStrings{
    print(filte)
      vehicleNoTxt.filterStrings(filte)
    }

    vehicleNoTxt.theme.bgColor = UIColor.white
    vehicleNoTxt.theme.font = UIFont.systemFont(ofSize: 13.0)
    vehicleNoTxt.itemSelectionHandler = { filteredResults, itemPosition in
      // Just in case you need the item position
      let item = filteredResults[itemPosition]
      print("Item at position \(itemPosition): \(item.title)")
      self.vehicleId = String((self.ticketData?.listVehicles?.firstIndex(where: {$0.vehicleNo == item.title}))!)
      // Do whatever you want with the picked item
      self.vehicleNoTxt.text = item.title
  }
  }
  //MARK:- IBAction
  @IBAction func backBtnClicked(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func submitBtnClicked(_ sender: UIButton) {
    
    var isPending : String = "Y"
    guard vehicleNoTxt.text != "" else {self.showAlert(message: "Please Enter Vehicle No");return}
    guard beforePickupImgView.isImagePicked == true  else {self.showAlert(message: "Please Capture Before pickup Imape");return}
    if isLastTrip == nil
    {
        self.showAlertWithYesNoCompletions(message: "Is this your last trip") {
         //NO Completion
            isPending = "Y"
            self.isLastTrip = false
            // self.concessionerPickupCaptureSubmitService(parameters: parameters)
        } Yescompletion: {
            self.afterPickupContainerView.isHidden = false
            isPending = "N"
            self.isLastTrip = true
            
        }
        return
    }
    if isLastTrip == true
    {
        if afterPickupImgView.isImagePicked == false
        {
            self.showAlert(message: "Please Capture After pickup Imape")
            return
        }
    }
    
   
    let parameters : [String : Any] = [
      "CNDW_GRIEVANCE_ID":ticketData?.ticketID ?? "",
      "EMPLOYEE_ID": UserDefaultVars.empId,
      "DEVICEID": deviceId,
      "TOKEN_ID": UserDefaultVars.token!,
      "IS_PENDING": isPending,
      "VEHICLE_DETAILS": [
        [
          "VEHICLE_ID": self.vehicleId,
          "VEHICLE_NUMBER": vehicleNoTxt.text ?? "",
          "BEFORE_TRIP_IMAGE":beforePickupImgView.image?.convertImageToBase64String(),
          "AFTER_TRIP_IMAGE":afterPickupImgView.image?.convertImageToBase64String()
        ]
      ]
    ]
    concessionerPickupCaptureSubmitService(parameters: parameters)
    
    
//    if afterPickupContainerView.isHidden == false && afterPickupImgView.isImagePicked == true
//    {
//      //servicecall
//      concessionerPickupCaptureSubmitService(parameters: parameters)
//
//    }
//    else if afterPickupContainerView.isHidden == false && afterPickupImgView.isImagePicked == false
//    {
//      self.showAlert(message: "Please Capture After pickup Imape")
//    }
//    else {
//           self.showAlertWithYesNoCompletions(message: "Is this your last trip") {
//        //servicecall
//        self.isLastTrip = false
//       // self.concessionerPickupCaptureSubmitService(parameters: parameters)
//      } Yescompletion: {
//        self.afterPickupContainerView.isHidden = false
//        isPending = "N"
//        self.isLastTrip = true
//
//      }
//    }
  }
  
  //MARK:- ServiceCall
  func concessionerPickupCaptureSubmitService(parameters : [String : Any])
  {
        let params = parameters as [String : Any]
        print(params)
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message:noInternet);return}
        NetworkRequest.makeRequest(type: SUbmitStruct.self, urlRequest: Router.pickupcaptureSubmit(Parameters: params)) { [weak self](result) in
                switch result {
                case .success(let resp):
                    print(resp)
                    if resp.statusCode == "600"{
                        self?.showCustomAlert(message: resp.statusMessage ?? ""){
                            let vc = storyboards.Main.instance.instantiateViewController(withIdentifier: "LoginViewControllerViewController") as! LoginViewControllerViewController
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    if resp.statusCode == "200"
                    {
                        self?.showAlert(message: resp.statusMessage ?? ""){
                            let vc = storyboards.Concessioner.instance.instantiateViewController(withIdentifier:"ConcessionerDasboardVC") as! ConcessionerDasboardVC
                             self?.navigationController?.pushViewController(vc, animated:true)
                        }
                    }
                    else
                    {
                        self?.showAlert(message: resp.statusMessage ?? "" )
                    }
                case .failure(let err):
                    print(err)
                    self?.showAlert(message: err.localizedDescription)
                }
            }
        }
}
