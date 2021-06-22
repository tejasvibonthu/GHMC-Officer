//
//  RequestEstimationVC.swift
//  GHMC_Officer
//
//  Created by deep chandan on 09/04/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//

import UIKit
import DropDown
class RequestEstimationVC: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var estimationDetails:RequestEstimationStruct?
    var reqdatasourceArry:[String] = []
    var req:String?
    var reqId:String?
    var vehicleId:String?
    var reqDataModel:GetreqTypeStruct?
    let dropdown = DropDown()
    var vehicledatasourceArry:[String] = []
    var noofTons:Int?
    var vehicledatamodel:GetVehicledataStruct?
    var weight:String?
    var tag:Int!
    var imgStr:String?
    var imagePicker: UIImagePickerController! = UIImagePickerController()
    @IBOutlet weak var dtaeLB: UILabel!
    @IBOutlet weak var zoneLB: UILabel!
    @IBOutlet weak var circleLB: UILabel!
    @IBOutlet weak var wardLB: UILabel!
    @IBOutlet weak var reqTypeBtn: UIButton!
    @IBOutlet weak var locationLB: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var estimationView: UIView!
    @IBOutlet weak var noofVehiclesTF: UITextField!
    @IBOutlet weak var vehicletypeBtn: UIButton!
    @IBOutlet weak var estimationwasteTF: UITextField!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var cameraImg: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setshadow()
        dtaeLB.text = estimationDetails?.createdDate
        zoneLB.text = estimationDetails?.zoneID
        circleLB.text = estimationDetails?.circleID
        wardLB.text = estimationDetails?.wardID
        locationLB.text = estimationDetails?.landmark
        imgView.image = UIImage(named: estimationDetails?.image1Path ?? "")
        estimationwasteTF.isHidden = true
        noofVehiclesTF.delegate = self
        amountTF.isHidden = true
        amountTF.delegate = self
        self.getRequestTypeWS()
        self.getVehiclesDataWS()
       
        }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        guard vehicletypeBtn.currentTitle != ""{
//            
//        }
        if noofVehiclesTF.text != "" {
        let noofVehicles = Int(noofVehiclesTF.text ?? "")
        let totalCost: Int = noofTons! * noofVehicles!
        self.weight = String(totalCost)
        estimationwasteTF.isHidden = false
        estimationwasteTF.text = ("\(weight ?? "0") TONS")
        if estimationwasteTF.text != "" {
            self.calculateAmountWS()
            self.amountTF.isHidden = false
        }
    }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        noofVehiclesTF.resignFirstResponder()
       // estimationwasteTF.resignFirstResponder()
        
        return true
        }
    @IBAction func typeofReqClick(_ sender: UIButton) {
        DropDown.appearance().textColor = UIColor.black
        dropdown.dataSource = reqdatasourceArry
        dropdown.anchorView = sender
        dropdown.show()
        dropdown.selectionAction = {[unowned self] (index : Int , item : String) in
            //  print("selected index \(index) item \(item)")
            sender.setTitle(item, for: .normal)
            reqTypeBtn.setTitleColor(.black, for: .normal)
            self.req = self.reqDataModel?.claimlist?[index].claimID
           // print(self.req)
            self.dropdown.hide()
                    }
    }
    @IBAction func vehicleTypeClick(_ sender: UIButton) {
        dropdown.dataSource = vehicledatasourceArry
        dropdown.anchorView = sender
        dropdown.show()
        dropdown.selectionAction = {[unowned self] (index : Int , item : String) in
            //  print("selected index \(index) item \(item)")
            
            sender.setTitle(item, for: .normal)
            vehicletypeBtn.setTitleColor(.black, for: .normal)
            self.vehicleId = self.vehicledatamodel?.vehiclelist?[index].vehicleTypeID
            self.dropdown.hide()
            self.noofTons = Int((vehicletypeBtn.currentTitle?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())! )
            //  self.noofTons = String(Tons ?? 0)
                    }
    }

   
    //get vehicle types API call
    func getRequestTypeWS()
    {
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message:noInternet);return}
        NetworkRequest.makeRequest(type: GetreqTypeStruct.self, urlRequest: Router.getClaimTypes) { [weak self](result) in
            switch result
            {
            case  .success(let
                            reqData):
                if reqData.statusCode == "200"{
                    self?.reqDataModel = reqData
                    self?.reqDataModel?.claimlist?.forEach({self?.reqdatasourceArry.append($0.claimType ?? "")})
                   
                }
                 else{
                 self?.showAlert(message: reqData.statusMessage ?? "")
             }
            case .failure(let err):
                print(err)
                self?.showAlert(message: serverNotResponding)
            }
        }
    }
    //get vehicle types API call
    func getVehiclesDataWS()
    {
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message:noInternet);return}
        NetworkRequest.makeRequest(type: GetVehicledataStruct.self, urlRequest: Router.getVehicleData) { [weak self](result) in
            switch result
            {
            case  .success(let vehicledata):
              //  print(vehicledata)
                if vehicledata.statusCode == "200"{
                    self?.vehicledatamodel = vehicledata
                    self?.vehicledatamodel?.vehiclelist?.forEach({self?.vehicledatasourceArry.append($0.vehicleType ?? "")})
                }
                 else{
                 self?.showAlert(message: vehicledata.statusMessage ?? "")
             }
            case .failure(let err):
                print(err)
                self?.showAlert(message: serverNotResponding)
            }
        }
    }
    func calculateAmountWS(){
        let params = ["EST_WT": self.weight]
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message:noInternet);return}
        NetworkRequest.makeRequest(type: CalculateAmountStruct.self, urlRequest: Router.calculateAmountbyTons(Parameters: params)) { [weak self](result) in
            switch result
            {
            case  .success(let CalData):
                if CalData.statusCode == "200"{
                    self?.amountTF.text = CalData.cndwAmount ?? ""
                }
                else{
                    self?.showAlert(message: CalData.statusMessage ?? "")
                }
            case .failure(let err):
                print(err)
                self?.showAlert(message: serverNotResponding)
            }
        }
    }
    @IBAction func backbuttonClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func cameraBtnClick(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            tag = 0
            break
      
        default:
            break
        }
        
        
        var alertStyle = UIAlertController.Style.actionSheet
        if (UIDevice.current.userInterfaceIdiom == .pad) {
          alertStyle = UIAlertController.Style.alert
        }
        let controller = UIAlertController(title: "Select a picture which properly describes the issue!", message: nil, preferredStyle: alertStyle)
        controller.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (action) in
            print("Choosed Camera")
            self.camera()
        }))
        controller.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { (action) in
            print("Choosed gsllry")
            self.photoLibrary()
        }))
       
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            print("Cancelled")
            
        }))
     
        self.present(controller, animated: true, completion: nil)
    }
    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    func photoLibrary()
    {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    //MARK:- imagePickerController Delegates
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
//let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        NSLog("\(info)")
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        switch tag {
        case 0:
            cameraImg.setImage(image, for: .normal)
            dismiss(animated: true, completion: nil)
            cameraImg.isSelected = true
            imgStr = convertImageToBase64(image:image)
            
    
        default:
            print("default")
        }

    }
    func convertImageToBase64(image: UIImage) -> String {

        //   let imageData1 = (image1Btn.image(for: .normal)!).jpeg(.lowest)
        let imageData = image.jpegData(compressionQuality: 0.001)!


        //   let imageData = UIImagePNGRepresentation(image, 0.001)!
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
        @IBAction func submitClick(_ sender: Any) {
    }
    func  setshadow(){
        // corner radius
        detailsView.layer.cornerRadius = 4

        // border
        detailsView.layer.borderWidth = 0.2
        // shadow
        detailsView.layer.shadowColor = UIColor.gray.cgColor
        detailsView.layer.shadowOffset = CGSize(width: 3, height: 3)
        detailsView.layer.shadowOpacity = 0.7
        detailsView.layer.shadowRadius = 2.0

        // border
        estimationView.layer.borderWidth = 0.2
        // shadow
        estimationView.layer.shadowColor = UIColor.gray.cgColor
        estimationView.layer.shadowOffset = CGSize(width: 3, height: 3)
        estimationView.layer.shadowOpacity = 0.7
        estimationView.layer.shadowRadius = 2.0
        estimationView.layer.cornerRadius = 4
    }
}

// MARK: - RequestEstimationStruct
struct GetreqTypeStruct: Codable {
    let statusCode, statusMessage: String?
    let claimlist: [Claimlist]?

    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
        case claimlist = "CLAIMLIST"
    }
}

// MARK: - Claimlist
struct Claimlist: Codable {
    let claimID, claimType: String?

    enum CodingKeys: String, CodingKey {
        case claimID = "CLAIM_ID"
        case claimType = "CLAIM_TYPE"
    }
}
// MARK: - CalculateAmountStruct
struct CalculateAmountStruct: Codable {
    let statusCode, statusMessage, cndwAmount: String?

    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
        case cndwAmount = "CNDW_AMOUNT"
    }
}
// MARK: - GetVehicledataStruct
struct GetVehicledataStruct: Codable {
    let statusCode, statusMessage: String?
    let vehiclelist: [Vehiclelist]?

    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
        case vehiclelist = "VEHICLELIST"
    }
    // MARK: - Vehiclelist
    struct Vehiclelist: Codable {
        let vehicleTypeID, vehicleType: String?

        enum CodingKeys: String, CodingKey {
            case vehicleTypeID = "VEHICLE_TYPE_ID"
            case vehicleType = "VEHICLE_TYPE"
        }
    }

}
