//
//  RequestEstimationVC.swift
//  GHMC_Officer
//
//  Created by deep chandan on 09/04/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//

import UIKit
import DropDown
import GoogleMaps
class RequestEstimationVC: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,CLLocationManagerDelegate {
    var estimationDetails:RequestEstimationStruct?
    var ticketId:String?
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
    var ticketDetails:GetPaidListStruct.PaidList?
    var latitude : String?
    var longitude : String?
    var circleId:String?
    var zoneId:String?
    var wardId:String?
    var locationManager = CLLocationManager()
    @IBOutlet weak var imgtopConstraint: NSLayoutConstraint!
    @IBOutlet weak var ticketSV: UIStackView!
    @IBOutlet weak var dtaeLB: UILabel!
    @IBOutlet weak var ticketIdLb: UILabel!
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
    @IBOutlet weak var landmarkTf: UITextField!
    @IBOutlet weak var cameraImg: CustomImagePicker!
    {
        didSet
        {
            cameraImg.parentViewController = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setshadow()
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.distanceFilter = 50
            locationManager.startUpdatingLocation()
        }else {
            self.showAlert(message: "please enable location services")
        }
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
        whereAmIService()
        if tag == 0 {
            ticketIdLb.text = ticketId
            dtaeLB.text = estimationDetails?.createdDate
            zoneLB.text = estimationDetails?.zoneID
            circleLB.text = estimationDetails?.circleID
            wardLB.text = estimationDetails?.wardID
            landmarkTf.text = estimationDetails?.landmark
            landmarkTf.borderStyle = .none
            imgView.sd_setImage(with: URL(string:estimationDetails?.image1Path  ?? ""), placeholderImage: UIImage(named: "noi"))
        }
            else if tag == 5 {
            ticketSV.isHidden = true
            dtaeLB.text = Date().string(format:"dd-MM-YYYY")
            zoneLB.text = ticketDetails?.zoneID
            circleLB.text = ticketDetails?.circleID
            wardLB.text = ticketDetails?.wardID
            landmarkTf.textColor = .black
        }
        estimationwasteTF.isHidden = true
        self.estimationwasteTF.isEnabled = false
        noofVehiclesTF.delegate = self
        noofVehiclesTF.isHidden = true
        amountTF.isHidden = true
        amountTF.delegate = self
        self.amountTF.isEnabled = false
        self.getRequestTypeWS()
        self.getVehiclesDataWS()
        }
    //Mark :- LocationManager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {return}
        locationManager.stopUpdatingLocation()
        latitude  = String(location.coordinate.latitude)
        longitude = String(location.coordinate.longitude)
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
        whereAmIService()
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
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
          print("selected index \(index) item \(item)")
            
            sender.setTitle(item, for: .normal)
            vehicletypeBtn.setTitleColor(.black, for: .normal)
            self.vehicleId = self.vehicledatamodel?.vehiclelist?[index].vehicleTypeID
            self.dropdown.hide()
            if  vehicletypeBtn.currentTitle != "Select" {
                noofVehiclesTF.isHidden = false
                self.noofTons = Int((vehicletypeBtn.currentTitle?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())! )
            }
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
    func whereAmIService()
    {
        let parameters : [String : Any] = [
            "USER_ID": userid,
            "PASSWORD": password,
            "LATITUDE" : latitude ?? "",
            "LONGITUDE" : longitude ?? ""]
      //  print(parameters)
        NetworkRequest.makeRequest(type: GetZonesStruct.self, urlRequest: Router.DemoGraphics(Parameters: parameters)) { [unowned self](result) in
            switch result
            {
            case .success(let resp):
                print(resp)
                if resp.zoneID == ""
                {
                    self.showAlertWithOkAction(message: "Selected Location is Outside of GHMC") { (action) in
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                else{
                    self.circleLB.text = resp.circleName
                    self.zoneLB.text = resp.zoneName
                    self.wardLB.text = resp.wardName
                    self.zoneId = resp.zoneID
                    self.wardId  = resp.wardID
                    self.circleId = resp.circleID
                    
                }
            case .failure(let err):
                print(err)
                self.showAlert(message: serverNotResponding)
            //completion(nil)
            }
        }
    }
    @IBAction func backbuttonClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
    func convertImageToBase64(image: UIImage) -> String {
        let imageData = image.jpegData(compressionQuality: 0.001)!
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
        @IBAction func submitClick(_ sender: Any) {
            if validation() {
                if tag == 0{ //request estimation from request list
                    self.requestsubmitWS()
                }  else if tag == 5{ //directly from dashboard raise
                    self.raiseRequestWS()
                }
            }
    }
    func requestsubmitWS(){
        let imgData = convertImageToBase64String(img: cameraImg.image!)
        let params = [
            "CNDW_GRIEVANCE_ID" : ticketId ?? "",
            "EMPLOYEE_ID": UserDefaultVars.empId,
            "DEVICEID": deviceId,
            "TOKEN_ID": UserDefaultVars.token ?? "",
            "IMAGE1_PATH": imgData,
            "VEHICLE_TYPE_ID": vehicleId ?? "",
            "NO_OF_VEHICLES": noofVehiclesTF.text ?? "",
            "EST_WT": weight ?? "",
            "AMOUNT": amountTF.text ?? ""
            
        ] as [String : Any]
        print(params)
    guard Reachability.isConnectedToNetwork() else {self.showAlert(message:noInternet);return}
    NetworkRequest.makeRequest(type: SUbmitStruct.self, urlRequest: Router.submitAMohReq(Parameters: params)) { [weak self](result) in
            switch result {
            case .success(let resp):
                print(resp)
                if resp.statusCode == "600"{
                    self?.showAlert(message: resp.statusMessage ?? ""){
                    let vc = storyboards.Main.instance.instantiateViewController(withIdentifier: "LoginViewControllerViewController") as! LoginViewControllerViewController
                            self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                if resp.statusCode == "200"
                {
                    self?.showAlert(message: resp.statusMessage ?? ""){
                            let viewControllers: [UIViewController] = (self?.navigationController!.viewControllers)!
                            for aViewController in viewControllers {
                                if aViewController is AMOHDashoboardVC {
                                    NotificationCenter.default.post(name:NSNotification.Name("refreshDashboardCounts"), object: nil)
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

    func raiseRequestWS(){
        let imgData = convertImageToBase64String(img: cameraImg.image!)
        let params = [
            "ZONE_ID":zoneId ?? "",
              "CIRCLE_ID": circleId ?? "",
              "WARD_ID": wardId ?? "",
            "LANDMARK": landmarkTf.text ?? "",
              "VEHICLE_TYPE": vehicleId ?? "",
              "IMAGE1_PATH": imgData,
              "IMAGE2_PATH": "",
              "IMAGE3_PATH": "",
            "NO_OF_VEHICLES": noofVehiclesTF.text ?? "",
            "EST_WT": weight ?? "",
            "CREATED_BY": UserDefaultVars.empName,
              "DEVICEID": deviceId,
            "TOKEN_ID": UserDefaultVars.token ?? "",
            "MOBILE_NUMBER": UserDefaultVars.mobileNumber,
              "LATITUDE": latitude ?? "",
              "LONGITUDE": longitude ?? ""
            
            
        ] as [String : Any]
        print(params)
    guard Reachability.isConnectedToNetwork() else {self.showAlert(message:noInternet);return}
    NetworkRequest.makeRequest(type: AMograisegrivanceStruct.self, urlRequest: Router.raiseRequest(Parameters: params)) { [weak self](result) in
            switch result {
            case .success(let resp):
                print(resp)
                if resp.statusCode == "600"{
                        self?.showAlert(message: resp.statusMessage ?? ""){
                            let vc = storyboards.Main.instance.instantiateViewController(withIdentifier: "LoginViewControllerViewController") as! LoginViewControllerViewController
                            self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                if resp.statusCode == "200"
                {
                    self?.showAlert(message: "\(resp.statusMessage ?? serverNotResponding) \(resp.cndwGrievanceID ?? "")"){
                        let viewControllers: [UIViewController] = (self?.navigationController!.viewControllers)!
                        for aViewController in viewControllers {
                            if aViewController is AMOHDashoboardVC {
                                NotificationCenter.default.post(name:NSNotification.Name("refreshDashboardCounts"), object: nil)
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
                self?.showAlert(message: serverNotResponding)
            }
        }
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
    func validation() -> Bool{
        if tag == 5 && landmarkTf.text == ""{
       showAlert(message: "Please enter landmark")
        return false
    } else  if reqTypeBtn.currentTitle == "Select request type"{
         showAlert(message: "Select request type")
         return false
     } else  if vehicletypeBtn.currentTitle == "Select vehicle type"{
        showAlert(message: "Select vehicle type")
        return false
     } else  if noofVehiclesTF.text == ""{
        showAlert(message: "Select no of vehicles")
        return false
     } else if cameraImg.isImagePicked == false {
        showAlert(message: "Please capture image")
        return false
     }
    return true
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

// MARK: - PaymentPendingSubmitStruct
struct PaymentPendingSubmitStruct: Codable {
    let statusCode, statusMessage, cndwGrievanceID: String?

    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
        case cndwGrievanceID = "CNDW_GRIEVANCE_ID"
    }
}
// MARK: - GetZonesStruct
struct GetZonesStruct: Codable {
    let statusCode, statusMessage, wardID, wardName: String?
    let circleID, circleName, zoneID, zoneName: String?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
        case wardID = "WARD_ID"
        case wardName = "WARD_NAME"
        case circleID = "CIRCLE_ID"
        case circleName = "CIRCLE_NAME"
        case zoneID = "ZONE_ID"
        case zoneName = "ZONE_NAME"
    }
}

// MARK: - AMograisegrivanceStruct
struct AMograisegrivanceStruct: Codable {
    let statusCode, statusMessage, cndwGrievanceID, officerDetails: String?

    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
        case cndwGrievanceID = "CNDW_GRIEVANCE_ID"
        case officerDetails = "OFFICER_DETAILS"
    }
}
