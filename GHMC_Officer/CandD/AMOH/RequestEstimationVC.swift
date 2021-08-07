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
class RequestEstimationVC: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,CLLocationManagerDelegate ,TimeStampProtocol ,UITableViewDelegate ,UITableViewDataSource {
    func imgDelegate(img: UIImage ,imgView: UIImageView) {
        print("imgWithTimestamp\(img)")
        cameraImg.image  = img
        cameraImg.isUserInteractionEnabled = false
    }
    var imageWithTimestamp :UIImage?
    var estimationDetails:RequestEstimationStruct?
    var ticketId:String?
    var reqdatasourceArry:[String] = []
    var req:String?
    var reqId:String?
    var reqDataModel:GetreqTypeStruct?
    let dropdown = DropDown()
    var vehicledatasourceArry:[String] = []
    var noofTons:Int?
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
    var lat:String?
    var lon:String?
    var noofVehiclesArray : [TblItems] = []
    var totalAmount : String?
    var locationManager = CLLocationManager()
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
    @IBOutlet weak var estimationwasteTF: UILabel!
    @IBOutlet weak var landmarkTf: UITextField!
    @IBOutlet weak var btn_viewdirections: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableviewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var cameraImg: CustomImageView!
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
                btn_viewdirections.isHidden = true
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableviewHeight.constant = 0
       // self.getRequestTypeWS()
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
    
//    func calculateAmountWS(){
//        let params = ["EST_WT": self.weight]
//        guard Reachability.isConnectedToNetwork() else {self.showAlert(message:noInternet);return}
//        NetworkRequest.makeRequest(type: CalculateAmountStruct.self, urlRequest: Router.calculateAmountbyTons(Parameters: params)) { [weak self](result) in
//            switch result
//            {
//            case  .success(let CalData):
//                if CalData.statusCode == "200"{
//                    self?.amountTF.text = CalData.cndwAmount ?? ""
//                }
//                else{
//                    self?.showAlert(message: CalData.statusMessage ?? "")
//                }
//            case .failure(let err):
//                print(err)
//                self?.showAlert(message: serverNotResponding)
//            }
//        }
//    }
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
    @IBAction func btn_viewdirectionsClick(_ sender: Any) {
        openGoogleMap(destLat: lat ?? "" , destLon: lon ?? "")
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noofVehiclesArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AmoVehicledataCell") as! AmoVehicledataCell
        let cellItem = noofVehiclesArray[indexPath.row]
        cell.lb_vehicleType.text = cellItem.vehicleName
        cell.lb_noofvehicles.text = cellItem.noofVehicles
        cell.lb_amount.text = cellItem.amount
        //calculate estimation weight
        print("vehicledataArray\(noofVehiclesArray)")
        if  cell.lb_vehicleType.text != "" && cell.lb_noofvehicles.text != "" && cell.lb_amount.text != "" {
            let vehilennos = noofVehiclesArray.map({$0.noofVehicles})
            let vehicleType = noofVehiclesArray.map({$0.vehicleName.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()})
            let A = vehilennos.map { Int($0)!}
            let B = vehicleType.map { Int($0)!}
            let C = zip(A,B).map { $0 * $1 }
            let wt = C.sum()
            estimationwasteTF.text = String(wt)
            //calculate amount
            let amount = noofVehiclesArray.map({$0.amount})
            let D = amount.map { Int($0)!}
            let E = zip(A,D).map { $0 * $1 }
            self.totalAmount = String(E.sum())
            print(totalAmount)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            tableView.beginUpdates()
            noofVehiclesArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            tableviewHeight.constant -= 90
            //calculate estimation weight
            let vehilennos = noofVehiclesArray.map({$0.noofVehicles})
            let vehicleType = noofVehiclesArray.map({$0.vehicleName.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()})
            let A = vehilennos.map { Int($0)!}
            let B = vehicleType.map { Int($0)!}
            let C = zip(A,B).map { $0 * $1 }
            let wt = C.sum()
            estimationwasteTF.text = String(wt)
            //calculate amount
            let amount = noofVehiclesArray.map({$0.amount})
            let D = amount.map { Int($0)!}
            let E = zip(A,D).map { $0 * $1 }
            self.totalAmount = String(E.sum())
            print(totalAmount)
            tableView.endUpdates()
        }
    }
    @IBAction func btn_addVehicleClick(_ sender: Any) {
        let vc = storyboards.AMOH.instance.instantiateViewController(withIdentifier: "VehicledataEntryVC") as! VehicledataEntryVC
        vc.vehicleDatadelegate = self
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func submitClick(_ sender: Any) {
            if validation() {
                if tag == 0{ //request estimation from request list
                    self.requestestimationsubmitWS()
                }  else if tag == 5{ //directly from dashboard raise
                    self.raiseRequestWS()
                }
            }
    }
    func requestestimationsubmitWS(){
        let imgData = convertImageToBase64String(img: cameraImg.image!)
        var vehicleDetails :[[String:Any]] = [[:]]
        for item in noofVehiclesArray {
            let param = ["VEHICLE_TYPE_ID" : item.vehicleId ,
                         "NO_OF_TRIPS":item.noofVehicles]
            vehicleDetails.append(param)

        }
        let params = [
            "CNDW_GRIEVANCE_ID" : ticketId ?? "",
            "EMPLOYEE_ID": UserDefaultVars.empId,
            "DEVICEID": deviceId,
            "TOKEN_ID": UserDefaultVars.token ?? "",
            "IMAGE1_PATH": imgData,
            "VEHICLE_TYPE_ID":   "",
            "NO_OF_VEHICLES":  "",
            "EST_WT": estimationwasteTF.text ?? "",
            "AMOUNT":  totalAmount,
            "VEHICLE_DETAILS":  vehicleDetails,
            
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
        var vehicleDetails :[[String:Any]] = [[:]]
        for item in noofVehiclesArray {
            let param = ["VEHICLE_TYPE_ID" : item.vehicleId ,
                         "NO_OF_TRIPS":item.noofVehicles]
            vehicleDetails.append(param)

        }
        let params = [
            "ZONE_ID":zoneId ?? "",
            "CIRCLE_ID": circleId ?? "",
            "WARD_ID": wardId ?? "",
            "LANDMARK": landmarkTf.text ?? "",
            "IMAGE1_PATH": imgData,
            "IMAGE2_PATH": "",
            "IMAGE3_PATH": "",
            "EST_WT": estimationwasteTF.text ?? "",
            "CREATED_BY": UserDefaultVars.empName,
            "DEVICEID": deviceId,
            "TOKEN_ID": UserDefaultVars.token ?? "",
            "MOBILE_NUMBER": UserDefaultVars.mobileNumber,
            "LATITUDE": latitude ?? "",
            "LONGITUDE": longitude ?? "",
            "VEHICLE_DETAILS":  vehicleDetails,
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
    } else if noofVehiclesArray.isEmpty {
        showAlert(message: "Please add vehicle details")
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
extension RequestEstimationVC : VehicleDataProtocol{
        func vehicleDetails(vehicletype : String , vehicleId: String , noofVehicles : String ,amount : String ){
        noofVehiclesArray.append(contentsOf: [TblItems.init(vehicleName: vehicletype , vehicleId: vehicleId, noofVehicles: noofVehicles, amount: amount)])
            
        if !noofVehiclesArray.isEmpty{
            tableviewHeight.constant += 90
            tableView.reloadData()

        }
     //   print(noofVehiclesArray)
    }
}
struct TblItems {
    let vehicleName : String
    let vehicleId : String
    let noofVehicles : String
    let amount : String
}
extension Sequence where Element: AdditiveArithmetic {
    func sum() -> Element { reduce(.zero, +) }
}
