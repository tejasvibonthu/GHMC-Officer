//
//  ConcessionerRequest.swift
//  GHMC_Officer
//
//  Created by Haritej on 27/05/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//

import UIKit
import DropDown
import GrowingTextView
class ConcessionerRequest: UIViewController,UITextFieldDelegate {
    var date:String?
    var zone:String?
    var ward:String?
    var circle:String?
    var location:String?
    var grievanceId:String?
    var latitude:String?
    var longitude:String?
    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var dtaeLB: UILabel!
    @IBOutlet weak var zoneLB: UILabel!
    @IBOutlet weak var circleLB: UILabel!
    @IBOutlet weak var wardLB: UILabel!
    @IBOutlet weak var locationLB: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var radioBtn1: UIButton!
    @IBOutlet weak var radioBtn2: UIButton!
    @IBOutlet weak var reasonTV: GrowingTextView!
    @IBOutlet weak var proceedBtn: UIButton!
    
    @IBOutlet weak var vehicletypeBtn: UIButton!
    @IBOutlet weak var estimationWasteTf: UITextField!
    @IBOutlet weak var nofVehiclesTf: UITextField!
    @IBOutlet weak var vehicleNoTf: UITextField!
    @IBOutlet weak var driverNameTF: UITextField!
    @IBOutlet weak var mobileNoTF: UITextField!
    @IBOutlet weak var noofTripsTf: UITextField!
    @IBOutlet weak var cameraBtn: CustomImagePicker!
    {
        didSet
        {
            cameraBtn.parentViewController = self
        }
    }
    @IBOutlet weak var amountTF: UITextField!
    var vehicledatamodel:GetVehicledataStruct?
    var dropdown = DropDown()
    var vehicledatasourceArry:[String] = []
    var vehicleId:String?
    var noofTons:Int?
    var weight:String?
    var vehiclesCount:String?
    var IsAccept:String?
    var imgIs:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        dtaeLB.text = date
        zoneLB.text = zone
        circleLB.text = circle
        wardLB.text = ward
        locationLB.text = location
        imgView.sd_setImage(with: URL(string:imgIs ?? ""), placeholderImage: UIImage(named: "noi"))
        self.reasonTV.isHidden = true
        
//        nofVehiclesTf.delegate = self
//        estimationWasteTf.isHidden = true
//        amountTF.isHidden = true
//        self.getVehiclesDataWS()
    }
    
    @IBAction func acceptClick(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            radioBtn2.isSelected = false
                } else {
                    sender.isSelected = true
                    radioBtn2.isSelected = false
                    self.reasonTV.isHidden = true
                    proceedBtn.setTitle("Proceed", for: .normal)
                    self.IsAccept = "Y"
                }
    }
    @IBAction func rejectClick(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            radioBtn1.isSelected = false
                } else {
                    sender.isSelected = true
                    radioBtn1.isSelected = false
                    self.reasonTV.isHidden = false
                    proceedBtn.setTitle("Submit", for: .normal)
                    self.IsAccept = "N"
                }
    }

    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btn_ViewdirectionsClick(_ sender: Any) {
        openGoogleMap(destLat: latitude ?? "", destLon: longitude ?? "")
    }
    func openGoogleMap(destLat : String , destLon : String) {
        let lat = destLat
        let latDouble =  Double(lat)
        let long = destLon
        let longDouble =  Double(long)
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app
            if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(String(describing: latDouble!)),\(String(describing: longDouble!))&directionsmode=driving") {
                UIApplication.shared.open(url, options: [:])
            }}
        else {
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(String(describing: latDouble!)),\(String(describing: longDouble!))&directionsmode=driving") {
                UIApplication.shared.open(urlDestination)
            }
        }
    }
    func validation() -> Bool{
        if  radioBtn1.isSelected == false && radioBtn2.isSelected == false{
            showAlert(message: "Please select accept or reject")
            return false
        } else if reasonTV.isHidden == false && reasonTV.text == "" {
            showAlert(message: "Please enter reason for rejection")
            return false
        }

        return true
    }
    func rejectionWS(){
        let params = [
            "CNDW_GRIEVANCE_ID": grievanceId ?? "",
            "EMPLOYEE_ID": UserDefaultVars.empId,
            "DEVICEID": deviceId,
            "TOKEN_ID": UserDefaultVars.token,
            "IMAGE1_PATH": "",
            "NO_OF_VEHICLES": "",
            "EST_WT": "",
            "AMOUNT":"",
            "ISACCEPT":"N",
            "REASON_FOR_REJECT":reasonTV.text ?? "",
            "VEHICLE_DETAILS": [
                [
                    "VEHICLE_NO": "",
                    "DRIVER_NAME": "",
                    "MOBILE_NUMBER":"",
                    "NO_OF_TRIPS":"",
                    "VEHICLE_TYPE_ID": "" ,
                ]
            ]
                    
        ] as [String : Any]
        print(params)
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message:noInternet);return}
        NetworkRequest.makeRequest(type: SUbmitStruct.self, urlRequest: Router.submitConcessionerReq(Parameters: params)) { [weak self](result) in
                switch result {
                case .success(let resp):
                    print(resp)
                    if resp.statusCode == "200"
                    {
                        self?.showAlert(message: resp.statusMessage ?? ""){
                            let viewControllers: [UIViewController] = (self?.navigationController!.viewControllers)!
                            for aViewController in viewControllers {
                                if aViewController is ConcessionerDasboardVC {
                                    NotificationCenter.default.post(name: NSNotification.Name("refreshconcesionerdashboard"), object: nil)
                                    self?.navigationController!.popToViewController(aViewController, animated: true)
                                }
                            }
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
    
    @IBAction func proceedtoBtnClick(_ sender: Any) {
       // print(self.IsAccept)
        if   self.IsAccept == "Y" {
            if validation(){
                let vc = storyboards.Concessioner.instance.instantiateViewController(withIdentifier: "VehicleDataVC") as! VehicleDataVC
                vc.grievanceId = grievanceId
                navigationController?.pushViewController(vc, animated: true)
              //  self.submitWS()
            }
            
        }
        else if self.IsAccept == "N" {
            self.rejectionWS()
        }
      
    }
}
// MARK: - Claimlist
struct SUbmitStruct: Codable {
    let statusCode, statusMessage , cndwGrievanceId: String?
    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
        case cndwGrievanceId = "CNDW_GRIEVANCE_ID"
    }
}
