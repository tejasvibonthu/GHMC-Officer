////
////  TakeActionViewController.swift
////  GHMC_Officer
////
////  Created by IOSuser3 on 14/09/19.
////  Copyright © 2019 IOSuser3. All rights reserved.
////
//
//import UIKit
//import Alamofire
//import PKHUD
//import CoreLocation
//import GoogleMaps
//import GooglePlaces
//import MobileCoreServices
//import iOSDropDown
//
//// MARK: - Element
////struct vehiclesFullData: Codable {
////    let slno, vehicleNumber: String
////
////
////}
//
//struct vehiclesFullData : Decodable {
//    let sLNO : String?
//    let vEHICLE_NUMBER : String?
//
//    enum CodingKeys: String, CodingKey {
//
//        case sLNO = "SLNO"
//        case vEHICLE_NUMBER = "VEHICLE_NUMBER"
//    }
//}
//
//
//class TakeActionVC: UIViewController,CLLocationManagerDelegate,UIPickerViewDelegate, UIPickerViewDataSource ,UITextViewDelegate,UIImagePickerControllerDelegate,UIDocumentPickerDelegate,UIDocumentMenuDelegate,UINavigationControllerDelegate{
//
//
//    @IBOutlet weak var ward_Name: DropDown!
//    @IBOutlet weak var complaint_Text: DropDown!
//    @IBOutlet weak var wardNameHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var complaintTypeTfHeight: NSLayoutConstraint!
//    @IBOutlet weak var sumitButton: UIButton!
//    @IBOutlet weak var imageView: UIImageView!
//    @IBOutlet weak var description1: UITextView!
//    @IBOutlet weak var wardTf: UITextField!
//    {
//        didSet
//        {
//            wardTf.inputView = UIView()
//        }
//    }
//    @IBOutlet weak var complaitTf: UITextField!
//    {
//        didSet
//        {
//            complaitTf.inputView = UIView()
//        }
//    }
//    @IBOutlet weak var selectvehicleType: UITextField!
//    @IBOutlet weak var noofTrips: UITextField!
//    @IBOutlet weak var totalnw: UITextField!
//    @IBOutlet weak var vehicleswheight: NSLayoutConstraint!
//    @IBOutlet weak var vehiclesvTop: NSLayoutConstraint!
//
//    var dropDOwn:DropDown?
//    var myComplaintId:String?
//    let complaintId:String? = nil
//    let wardId:String? = nil
//
//    var model: [getstatus]? = nil
//    var wardModel:getwardDeatils?
//    var data:String? = nil
//    var claimedStatusModel:[getClaimedStatus]?
//    var getLowerStaffModel:getLowerStaff?
//    var getIdProofModel:getIdProofsTpes?
//    var updateGrivencemodel:grivenceUpdate?
//  //  var image:UIImage?
//    var locationManager:CLLocationManager?
//    var location:String? = nil
//    var modeId:String?
//    var subcatId:String?
//    var designation:String?
//    //get vehicle ids
//    var vehicleDtaProofModel:[vehiclesFullData]?
//    let vehiclePicker = UIPickerView()
//    var vehicleSLNo : String?
//
//    var imagestr1:String!
//    let types: [String] = [kUTTypePDF as String]
//    var imagesPicker: UIImagePickerController! = UIImagePickerController()
//
//    //params
//    var ward_id:String? = nil
//    var complaint_id:String? = nil
//    var ç:String?
//    var updateWardModel:updateWrd?
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let image = UserDefaults.standard.value(forKey:"bgImagview") as! String
//        modeId = UserDefaultVars.modeID
//        subcatId = UserDefaultVars.subcatId
//        designation = UserDefaultVars.designation
//        //set vehicle picker
//        self.selectvehicleType.isHidden = true
//        self.noofTrips.isHidden = true
//        self.totalnw.isHidden = true
//        self.vehiclesvTop.constant = 0
//        self.vehicleswheight.constant = 0
//
//        self.vehiclePicker.delegate = self
//        self.vehiclePicker.dataSource = self
//        selectvehicleType.inputView = vehiclePicker
//        self.description1.delegate = self
//
//        self.imagesPicker.delegate = self
//        self.imagestr1 = ""
//
//        self.description1.text = "Enter Reramrks"
//        description1.textColor = UIColor.darkGray
//
//
//       // subcatId = "34"
//
//      //  modeId = "15"
//      //  print("modeidresponse",modeId ?? "")
//
//        self.navigationController?.navigationBar.isHidden = true
//        self.ward_Name.selectedIndex = 0
//        self.complaint_Text.selectedIndex = 0
//      //  imageView.layer.cornerRadius = self.imageView.frame.width/2
//       // imageView.layer.masksToBounds = true
//
//        locationManager = CLLocationManager()
//        locationManager?.delegate = self
//        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager?.requestAlwaysAuthorization()
//        locationManager?.startUpdatingLocation()
//
//
//      // set frame
//      //  complaint_Text?.listHeight = 300.0
//     //    ward_Name?.listHeight = 500.0
//        self.view.backgroundColor = UIColor.init(patternImage:UIImage.init(named:image)!)
//        complaint_Text!.borderWidth = 1.0
//        complaint_Text!.borderColor = UIColor.darkGray
//        complaint_Text?.selectedRowColor = .clear
//        complaint_Text?.isSelected = false
//
//        ///Complaint Text did Select
//        complaint_Text!.didSelect{[weak self](selectedText , index ,id) in
//            guard let self = self else {return}
//        self.complaint_Text.text = ""
//        self.complaint_id = String(id)
//        UserDefaults.standard.set(self.complaint_id, forKey:"COMPLAINT_ID")
//        self.complaint_Text.text = "\(selectedText)"
//        self.complaint_Text!.hideList()
//            if  self.complaint_id == "4" ||
//                self.complaint_id == "15" ||
//                self.complaint_id == "10"
//                {
//                self.wardTf.isHidden = false
//                self.ward_Name.isHidden = false
//                self.wardTf.text = ""
//                self.ward_Name.text = ""
//            }else {
//                self.wardTf.isHidden = true
//                self.ward_Name.isHidden = true
//                self.wardTf.text = ""
//                self.ward_Name.text = ""
//            }
//            if self.complaint_id == "15"{
//                self.getLowerStaffWS()
//            }else if self.complaint_id == "10"{
//                self.getClimaintStatusWS()
//            }else if self.complaint_id == "4"{
//                self.wardTf.placeholder = "Select"
//                self.getWardWS()
//            }
//
//            if(self.designation == "Ramky Engineer"){
//                if(self.complaintId == "11"){
//                    self.vehiclesvTop.constant = 8
//                    self.vehicleswheight.constant = 140
//                    self.selectvehicleType.isHidden = false
//                    self.noofTrips.isHidden = false
//                    self.totalnw.isHidden = false
//
//                }
//            }
//
//        }
//        //Complaint Did Select End
//
//         ward_Name.borderWidth = 1.0
//         ward_Name!.borderColor = UIColor.darkGray
//         ward_Name?.selectedRowColor = .clear
//         ward_Name?.isSelected = false
//
//         ward_Name!.didSelect{(selectedText , index ,id) in
//
//            self.ward_Name.text = ""
//            self.ward_Name.text = "\(selectedText)"
//            self.ward_Name!.hideList()
//            self.ward_id = String(id)
//            UserDefaults.standard.set(self.ward_id, forKey: "Ward_id")
//          //  print("wardidresponse",self.ward_id ?? "")
//        }
//
//        let firstRIghtView = UIView(frame: CGRect(x:0, y: 0, width:0, height: 0))
//        firstRIghtView.backgroundColor = UIColor.init(patternImage:UIImage.init(named:"arrow_right")!)
//
//       //  complaitTf.rightViewMode = .always
//      //   complaitTf.rightView = firstRIghtView
//        let gesture = UITapGestureRecognizer.init(target:self, action:#selector(taponDropDown))
//        firstRIghtView.addGestureRecognizer(gesture)
//        let SecondRIghtView = UIView(frame: CGRect(x:0, y: 0, width:0, height: 0))
//
//        SecondRIghtView.backgroundColor = UIColor.init(patternImage:UIImage.init(named:"arrow_right")!)
//     //   wardTf.rightViewMode = .always
//     //   wardTf.rightView = SecondRIghtView
//        let gesture2 = UITapGestureRecognizer.init(target:self, action:#selector(taponDropDown1))
//        SecondRIghtView.addGestureRecognizer(gesture2)
//        let imageGesture = UITapGestureRecognizer.init(target:self, action:#selector(imagegestureAction))
//         imageView.addGestureRecognizer(imageGesture)
//         self.navigationController?.navigationBar.isHidden = true
//        if Reachability.isConnectedToNetwork(){
//        self.getStatusTypeWS()
//        self.getVehicleIds()
//        }else{
//            showAlert(message:interNetconnection)
//        }
//        // self.getLowerStaffWS()
//
//
//
//        // Do any additional setup after loading the view.
//    }
//    func textViewDidBeginEditing(_ textView: UITextView) {
//       if textView.textColor == UIColor.darkGray {
//            textView.text = nil
//            textView.textColor = UIColor.black
//        }
//        }
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = "Enter Remarks"
//            textView.textColor = UIColor.darkGray
//        }
//    }
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return self.vehicleDtaProofModel?.count ?? 0
//
//    }
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return self.vehicleDtaProofModel?[row].vEHICLE_NUMBER
//    }
//    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        selectvehicleType.text = self.vehicleDtaProofModel?[row].vEHICLE_NUMBER
//        vehicleSLNo = self.vehicleDtaProofModel?[row].sLNO
//        UserDefaults.standard.set(vehicleSLNo, forKey:"vehicleSlnum")
//
//    }
//
//    func getVehicleIds(){
//
//        let dict1 :Parameters  = ["userid":"cgg@ghmc",
//                                  "password":"ghmc@cgg@2018"]
//
//
//        let baseUrl = BASE_URL
//        let mainURL = baseUrl + "getRamkyVehicles"
//        self.loading(text:progressMsgWhenLOginClicked)
//        PKHUD.sharedHUD.show()
//        Alamofire.request(mainURL, method:.post, parameters:dict1, headers:nil).responseJSON { response in
//
//         //   print(mainURL)
//         //   print(dict1)
//
//            DispatchQueue.main.async {
//                PKHUD.sharedHUD.hide()
//            }
//            switch response.result{
//            case .success:
//                do{
//                    self.vehicleDtaProofModel = try JSONDecoder().decode([vehiclesFullData].self, from: response.data!) // Decoding our data
//                  //  print("vehicleRes",response.result)
//                  //  print(self.vehicleDtaProofModel?.count ?? 0)
//
//                    self.vehiclePicker.reloadAllComponents()
//
//                }catch {
//                    print(error.localizedDescription)
//                }
//                break
//            case .failure(let error):
//                print(error)
//                break
//            }
//
//        }
//    }
//    @IBAction func back_buttonAction(_ sender: Any) {
//        self.navigationController?.popViewController(animated:true)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error.localizedDescription)
//    }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//        location = "\(locValue.latitude),\(locValue.longitude)"
//        UserDefaults.standard.set(location, forKey:"locationl")
//      //  print(location)
//    }
////    func checking(){
////        self.ward_Name?.optionArray = ["qwqwefg","eqwrger","34567"]
////        self.ward_Name?.optionIds = [1,2,3]
////    }
//    func updateWard(){
//        let deviceId = UIDevice.current.identifierForVendor!.uuidString
//       // var strBase64:String?
//        guard let location1 = location else {
//            showAlert(message:"Unable to fetch location.Please try again later..")
//            return
//        }
////        let string1 = "17.4058326"
////        let string2 = " 78.3766232"
////        var welcome = string1 + string2
//        let mobileno = UserDefaults.standard.value(forKey:"MOBILE_NO")!
//        let name = UserDefaults.standard.value(forKey:"EMP_NAME")!
//        let dict:Parameters = [ "userid":userid,
//        "password":password,
//        "remarks":description1.text ?? "",
//        "photo":imagestr1 ?? "",
//        "latlon":location1,
//        "mobileno":"\(mobileno)-\(name)",
//        "deviceid":deviceId,
//        "compId":myComplaintId ?? "",
//        "updatedstatus":self.complaint_id ?? "",
//        "ward":ward_id ?? ""]
//        DispatchQueue.main.async {
//            self.loading(text:progressMsgWhenLOginClicked)
//            PKHUD.sharedHUD.show()
//        }
//
//        Alamofire.request(Router.forwordtoAnotherWard(params:dict)).responseJSON {response in
//
//           // print(response)
//
//            DispatchQueue.main.async {
//                PKHUD.sharedHUD.hide()
//            }
//            switch response.result{
//            case .success:
//                do{
//                    let decoder = JSONDecoder()
//                   self.updateWardModel = try decoder.decode(updateWrd.self, from: response.data!)
//                    DispatchQueue.main.async {
//                        if  self.updateWardModel!.status == true{
//                            let alert = UIAlertController(title: "MYGHMC", message:(self.updateWardModel?.compid ?? ""), preferredStyle: UIAlertController.Style.alert)
//                            alert.addAction(UIAlertAction.init(title:"OK", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
//                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                                appDelegate.openDashboard()
//                            }))
//                            self.present(alert, animated: true, completion: nil)
//
//                        }else {
//                            self.showAlert(message:(self.updateWardModel?.tag ?? ""))
//                        }
//                    }
//                }catch {
//                    print(error.localizedDescription)
//                    self.showAlert(message:(self.updateWardModel?.tag! ?? ""))
//                }
//                break
//            case .failure(_):
//                self.showAlert(message:failedupdate)
//
//                break
//
//
//            }
//        }
//    }
//
//    func updateGrivence(){
//        let deviceId = UIDevice.current.identifierForVendor!.uuidString
//        //19.0176147,72.8561644
//       // let string1 = "19.0176147"
//      //  let string2 = " 72.8561644"
//      //  var welcome = string1 + string2
//
//        let mobileno = UserDefaults.standard.value(forKey:"MOBILE_NO")!
//        let name = UserDefaults.standard.value(forKey:"EMP_NAME")!
//        let type_id = UserDefaults.standard.value(forKey:"TYPE_ID")!
//      //  let emailId = UserDefaults.standard.value(forKey:"emailId")!
//      //  let amount = UserDefaults.standard.value(forKey:"amount")!
//      //  let nmosMobileNum = UserDefaults.standard.value(forKey:"nmosMobileno")!
//      //  let citizenortradeName = UserDefaults.standard.value(forKey:"citizenName")!
//      //  let idProof = UserDefaults.standard.value(forKey:"idproof")!
//      //  let idType = UserDefaults.standard.value(forKey:"idType")!
//      //  UserDefaults.standard.set(noofTrips.text, forKey: "nooftrips") //setObject
//      //  UserDefaults.standard.set(totalnw.text, forKey: "totalnw") //setObject
//
//
//        guard let location1 = location else {
//            showAlert(message:"Unable to fetch location.Please try again later..")
//            return
//        }
//        let dict :Parameters  = ["userid": userid,
//                                 "password": password,
//        "type_id": "\(type_id)",
//        "mobileno": "\(mobileno)-\(name)-\(type_id)",
//        "updatedstatus":self.complaint_id!,
//        "compId": self.myComplaintId!,
//        "remarks":description1.text!,
//        "photo":imagestr1 ??  "",
//        "latlon": location1,
//        "deviceid":deviceId,
//        "no_of_trips":noofTrips.text ?? "",
//        "total_net_weight":totalnw.text ?? "",
//        "trader_name":"",
//        "id_proof_type":"",
//        "id_proof_no":"",
//        "nmos_mobile_no":"",
//        "email":"",
//        "fine_amount":"",
//        "source":modeId ?? "",
//        "vehicleNo":vehicleSLNo ?? "",
//        "claimant_status":ward_id ?? "",
//        "lower_staff_id": ward_id ?? ""
//        ]
//
//        DispatchQueue.main.async {
//            self.loading(text:progressMsgWhenLOginClicked)
//            PKHUD.sharedHUD.show()
//        }
//
//        Alamofire.request(Router.updateGrivence(params:dict)).responseJSON {response in
//           print("photouploadparameters",dict)
//           print("photouploadresponse",response)
//
//            DispatchQueue.main.async {
//                PKHUD.sharedHUD.hide()
//            }
//            switch response.result{
//            case .success:
//                do{
//                    let decoder = JSONDecoder()
//                    self.updateGrivencemodel = try decoder.decode(grivenceUpdate.self, from: response.data!)
//                   DispatchQueue.main.async {
//                    if  self.updateGrivencemodel?.status == "True"{
////                            self.showAlert(message:(self.updateGrivencemodel?.compid! ?? ""))
//
//                        let alert = UIAlertController(title: "MYGHMC", message:self.updateGrivencemodel?.compid!, preferredStyle: UIAlertController.Style.alert)
//                        alert.addAction(UIAlertAction.init(title:"OK", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
//                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                            appDelegate.openDashboard()
//                        }))
//                        self.present(alert, animated: true, completion: nil)
//
//                        }else {
//                            self.showAlert(message:(self.updateGrivencemodel?.Message ?? ""))
//                        }
//                    }
//                }catch {
//                    print(error.localizedDescription)
//                }
//                break
//            case .failure( _):
//                 self.showAlert(message:failedupdate)
//
//                break
//
//
//            }
//
//        }
//    }
//    func dispalyWard()
//    {
//    let dataArray = self.data?.split(separator:"-")
//    self.wardTf.text = "qefwg"
//    self.ward_Name.text = ""
//    self.ward_Name.text = String((dataArray?[1])!)
//    }
//
//    func getWardWS(){
//
//        let dict :Parameters  = ["userid":userid,
//                                 "password":password,
//                                 ]
//
//        DispatchQueue.main.async {
//            self.loading(text:progressMsgWhenLOginClicked)
//            PKHUD.sharedHUD.show()
//        }
//
//        Alamofire.request(Router.getWard(params:dict)).responseJSON {response in
//
////print(response)
//
//            DispatchQueue.main.async {
//                PKHUD.sharedHUD.hide()
//            }
//            switch response.result{
//            case .success:
//                do{
//                    let decoder = JSONDecoder()
//                    self.wardModel = try decoder.decode(getwardDeatils.self, from: response.data!)
//                    //wardModel.data
//                   // print(self.wardModel?.data )
//                    var titlearray = [String]()
//                    var IDarray = [Int]()
//                    for  i in (0 ..< self.wardModel!.data!.count){
//                        let title = self.wardModel?.data?[i].ward!
//                        let some = title?.split(separator:"-")
//                        let finalTitle = String(some?[1] ?? "")
//                        titlearray.append(finalTitle)
//                        let id = Int((self.wardModel?.data?[i].id)!)
//                        IDarray.append(id! )
//                    }
//
//                 //   print(IDarray )
//
//                    DispatchQueue.main.async {
//                        if  self.model?[0].status == "success"{
//                            self.ward_Name?.optionArray = titlearray
//                            self.ward_Name?.optionIds = IDarray
//
//                        }else {
//                            self.showAlert(message:(self.model?[0].status! ?? ""))
//
//                        }
//                    }
//                }catch {
//                    print(error.localizedDescription)
//
//                }
//                break
//            case .failure(let error):
//                print(error)
//
//                break
//
//
//            }
//
//        }
//    }
//    func getIDproofs(){
//        let baseUrl = BASE_URL
//        let mainURL = baseUrl + "/getIdProofTypes"
//        self.loading(text:progressMsgWhenLOginClicked)
//        PKHUD.sharedHUD.show()
//        Alamofire.request(mainURL, method:.get, parameters:nil, encoding:JSONEncoding.default, headers:nil).responseJSON { response in
//            DispatchQueue.main.async {
//                PKHUD.sharedHUD.hide()
//            }
//            switch response.result{
//            case .success:
//                do{
//                    let decoder = JSONDecoder()
//                    self.getIdProofModel = try decoder.decode(getIdProofsTpes.self, from: response.data!)
//                    var titlearray = [String]()
//                    var IDarray = [Int]()
//
//                    if self.getIdProofModel?.status == "true"{
//                        for  i in (0 ..< self.getIdProofModel!.data!.count){
//                            titlearray.append(self.getIdProofModel!.data?[i].name ?? "")
//                            let id = Int((self.getIdProofModel!.data?[i].id)!)
//                            IDarray.append(id! )
//                        }
//                    }
//                //    print(IDarray )
//
//                    DispatchQueue.main.async {
//                        if  self.model?[0].status == "true"{
//                            //self.complaint_Text?.optionArray = titlearray
//                            //self.complaint_Text?.optionIds = IDarray
//
//                        }else {
//                            //self.showAlert(message: self.getLowerStaffModel!.tag ?? "")
//                        }
//                    }
//                }catch {
//                    print(error.localizedDescription)
//                }
//                break
//            case .failure(let error):
//                print(error)
//
//                break
//
//
//            }
//
//        }
//    }
//    func getLowerStaffWS(){
////        Service level URL: getLowerStaff
////        Input Query Parameters :empId
//        let empId =  UserDefaults.standard.value(forKey:"EMP_D") as! String
//        //let mobileNumber = mobileTextfiled.text!
//        let baseUrl = BASE_URL
//        let mainURL = baseUrl + "/getLowerStaff?empId=\(empId)"
//        self.loading(text:progressMsgWhenLOginClicked)
//        PKHUD.sharedHUD.show()
//        Alamofire.request(mainURL, method:.get, parameters:nil, encoding:JSONEncoding.default, headers:nil).responseJSON { response in
//            DispatchQueue.main.async {
//                PKHUD.sharedHUD.hide()
//            }
//           switch response.result{
//            case .success:
//                do{
//                    let decoder = JSONDecoder()
//
//                    self.getLowerStaffModel = try decoder.decode(getLowerStaff.self, from: response.data!)
//                    var titlearray = [String]()
//                    var IDarray = [Int]()
//
//                    if self.getLowerStaffModel?.status == true{
//                        for  i in (0 ..< self.getLowerStaffModel!.data!.count){
//                        titlearray.append(self.getLowerStaffModel!.data?[i].empName ?? "")
//                        let id = Int((self.getLowerStaffModel!.data?[i].empId)!)
//                        IDarray.append(id! )
//                    }
//                    }
//                  //  print(IDarray )
//
//                    DispatchQueue.main.async {
//                        if  self.getLowerStaffModel?.status == true{
//                            self.ward_Name.optionArray = titlearray
//                            self.ward_Name.optionIds = IDarray
//
//
//                        }else {
//                            self.showAlert(message: self.getLowerStaffModel!.tag ?? "")
//                            self.ward_Name.isHidden = true
//                            self.ward_Name.isHidden = true
//                            self.complaint_Text.text = "select"
//                            //self.complaint_Text.isEnabled = false
//
//                        }
//                    }
//                }catch {
//                    print(error.localizedDescription)
//
//                }
//                break
//            case .failure(let error):
//                print(error)
//
//                break
//
//
//            }
//
//        }
//    }
//
//    func getClimaintStatusWS(){
//
//        let dict :Parameters  = ["userid":userid,
//                                 "password":password,
//                                 "type_id":UserDefaults.standard.value(forKey:"TYPE_ID")!]
//
//        DispatchQueue.main.async {
//            self.loading(text:progressMsgWhenLOginClicked)
//            PKHUD.sharedHUD.show()
//        }
//
//        Alamofire.request(Router.getClaimtStatus(params:dict)).responseJSON {response in
//
//          //  print(response)
//
//            DispatchQueue.main.async {
//                PKHUD.sharedHUD.hide()
//            }
//            switch response.result{
//            case .success:
//                do{
//                    let decoder = JSONDecoder()
//                    self.claimedStatusModel = try decoder.decode([getClaimedStatus].self, from: response.data!)
//                   var titlearray = [String]()
//                    var IDarray = [Int]()
//
//
//
//                    for  i in (0 ..< self.claimedStatusModel!.count){
//                        titlearray.append(self.claimedStatusModel?[i].type ?? "")
//                        let id = Int((self.claimedStatusModel?[i].id)!)
//                        IDarray.append(id! )
//                    }
//
//                   // print(IDarray )
//
//                    DispatchQueue.main.async {
//                        if  self.model?[0].status == "success"{
//                            self.ward_Name.optionArray = titlearray
//                            self.ward_Name.optionIds = IDarray
//
//                        }else {
//                           self.showAlert(message:(self.model?[0].status! ?? ""))
//                            self.ward_Name.isHidden = true
//                            self.wardTf.isHidden = true
//                        }
//                    }
//                }catch {
//                    print(error.localizedDescription)
//                }
//                break
//            case .failure(let error):
//                print(error)
//
//                break
//
//
//            }
//
//        }
//    }
//
//
//    func getStatusTypeWS(){
//
//        let dict :Parameters  = ["userid":userid,
//            "password":password,
//            "type_id":UserDefaults.standard.value(forKey:"TYPE_ID")!,
//        "designation":UserDefaults.standard.value(forKey:"DESIGNATION")!]
//
//        DispatchQueue.main.async {
//            self.loading(text:progressMsgWhenLOginClicked)
//            PKHUD.sharedHUD.show()
//        }
//
//        Alamofire.request(Router.getstatusType(params:dict)).responseJSON {response in
//           // print(dict)
//           // print(response)
//
//            DispatchQueue.main.async {
//                PKHUD.sharedHUD.hide()
//            }
//            switch response.result{
//            case .success:
//                var status:String?
//                var statusArray:[String]?
//                let responseArray = response.result.value as! NSArray
//                  print("getstattustype",responseArray)
//                for i in responseArray {
//                    let some:NSDictionary = i as! NSDictionary
//                    status = some["status"] as? String
//                    statusArray?.append(status ?? "")
//
//
//                }
//
//
//                do{
//                     let decoder = JSONDecoder()
//                    self.model = try decoder.decode([getstatus].self, from: response.data!)
//                  //  print(self.model![0].type! )
//                    var titlearray = [String]()
//                    var IDarray = [Int]()
//
//                    if(self.subcatId == "34"){
//                        for  i in (0 ..< self.model!.count){
//                            titlearray.append(self.model?[i].type ?? "")
//                            let id = Int((self.model?[i].id)!)
//                            IDarray.append(id! )
//
//                        }
//                    } else{
//                        for  i in (0 ..< self.model!.count){
//                            titlearray.append(self.model?[i].type ?? "")
//                            titlearray = titlearray.filter { $0 != "Forward to Ramky" }
//                            let id = Int((self.model?[i].id)!)
//                            IDarray.append(id! )
//
//                        }
//                    }
//
//
//
//                 //   print(IDarray)
//
//                    DispatchQueue.main.async {
//                        if  self.model?[0].status == "success"{
//                            self.complaint_Text?.optionArray = titlearray
//                            self.complaint_Text?.optionIds = IDarray
//
//
//                        }else {
//                            self.showAlert(message:(self.model?[0].status! ?? ""))
//                       }
//                    }
//                }catch {
//                    print(error.localizedDescription)
//                }
//                break
//            case .failure(let error):
//                print(error)
//
//                break
//
//
//            }
//
//        }
//    }
//   @objc func taponDropDown(){
//
//      complaint_Text.showList()
//
//    }
//    func ConvertImageToBase64String (img: UIImage) -> String {
//        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
//    }
//    @objc func taponDropDown1(){
//        ward_Name.showList()
//    }
//    func camera()
//    {
//        if UIImagePickerController.isSourceTypeAvailable(.camera){
//            imagesPicker.delegate = self
//            imagesPicker.sourceType = .camera
//            self.present(imagesPicker, animated: true, completion: nil)
//        }
//
//    }
//    func photoLibrary()
//    {
//
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
//            imagesPicker.delegate = self
//            imagesPicker.sourceType = .photoLibrary
//            self.present(imagesPicker, animated: true, completion: nil)
//        }
//    }
//    func openDocument(){
//       let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
//       documentPicker.delegate = self
//       documentPicker.modalPresentationStyle = .formSheet
//        self.present(documentPicker, animated: true, completion: nil)
//
//       // self.present(importMenu, animated: true, completion: nil)
//    }
//    @objc func imagegestureAction(){
//
//        let controller = UIAlertController(title: "Select a picture which properly describes the issue!", message: nil, preferredStyle: .actionSheet)
//
//
//            controller.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (action) in
//             //   print("Choosed Camera")
//                self.camera()
//
//
//            }))
//
//            controller.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { (action) in
//              //  print("Choosed Gallery")
//
//            self.photoLibrary()
//
//            }))
//            controller.addAction(UIAlertAction(title: "Choose Document", style: .default, handler: { (action) in
//                    //   print("Choosed Document")
//            self.openDocument()
//
//                   }))
//
//            controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
//                print("Cancelled")
//
//            }))
//
//        if let popoverController = controller.popoverPresentationController {
//          popoverController.sourceView = self.view
//          popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
//          popoverController.permittedArrowDirections = []
//        }
//            self.present(controller, animated: true, completion: nil)
//
//        }
//          public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//          let data = try! Data(contentsOf: urls[0])
//          self.imageView.image = UIImage(named:"pdfnew")
//          imagestr1  = data.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
//
//
//
//
//               }
//
//
//          public func documentMenu(_ picker:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
//              documentPicker.delegate = self
//              self.present(documentPicker, animated: true, completion: nil)
//          }
//
//
//          func documentPickerWasCancelled(_ picker: UIDocumentPickerViewController) {
//             //   print("view was cancelled")
//              picker.dismiss(animated: true, completion: nil)
//          }
//
//
//       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//           dismiss(animated: true, completion: nil)
//       }
//
//
//
//      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//           NSLog("\(info)")
//
//
//                if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//                dismiss(animated: true, completion: nil)
//                self.imageView.image = image
//                let image1 : UIImage = image
//                let imageData:NSData = image1.jpeg(.lowest)! as NSData
//                imagestr1 = imageData.base64EncodedString(options: .lineLength64Characters)
//              //  print(imagestr1)
//
//
//
//
//               }
//
//
//       }
////        ImagePickerManager().pickImage(self){
////            image in
////            self.imageView.contentMode = .scaleAspectFill
////            self.image = image
////            self.imageView.image = image
////          //  print(image)
////
////
////        }
//
//
//
//    @IBAction func submitButtonAction(_ sender: Any) {
//
//      if  isdataValid(){
//            if self.complaint_Text.text == "Forward to another ward"{
//                if Reachability.isConnectedToNetwork(){
//                   self.updateWard()
//                }else{
//                    showAlert(message:interNetconnection)
//                }
//            }else{
//                if Reachability.isConnectedToNetwork(){
//                   self.updateGrivence()
//                }else{
//                    showAlert(message:interNetconnection)
//                }
//       }
//        }
//    }
//    func isdataValid()->Bool {
//
//
//       if complaitTf.text?.count == 0{
//            showAlert(message:complaint)
//         return false
//        }else if complaitTf.text == "select"{
//            showAlert(message:complaint)
//        return false
//        }else if self.complaint_id == "4"{
//            if wardTf.text?.count == 0{
//               showAlert(message:ward)
//                return false
//            }else if wardTf.text == "select"{
//                 showAlert(message:ward)
//                return false
//            }
//       }else if self.complaint_id == "10"{
//        if wardTf.text?.count == 0{
//            showAlert(message:"Please select status")
//            return false
//        }else if wardTf.text == "select"{
//            showAlert(message:"Please Select status")
//            return false
//        }
//       }else if self.complaint_id == "15"{
//        if wardTf.text?.count == 0{
//            showAlert(message:"Please Select the Staff")
//            return false
//        }else if wardTf.text == "select"{
//           showAlert(message:"Please Select the Staff")
//            return false
//        }
//       }
//       else if complaitTf.text == "Closed"{
//            if imagestr1 == nil {
//                showAlert(message:imageError)
//                return false
//            }
//
//        }
//       else if description1.text.count == 0
//       {
//         showAlert(message:"Please Enter Description")
//           return false
//        }
//        return true
//    }
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//
//}
//extension UIImage {
//    enum JPEGQuality: CGFloat {
//        case lowest  = 0
//        case low     = 0.25
//        case medium  = 0.5
//        case high    = 0.75
//        case highest = 1
//    }
//
//    /// Returns the data for the specified image in JPEG format.
//    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
//    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
//    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
//        return jpegData(compressionQuality: jpegQuality.rawValue)
//    }
//}
//extension TakeActionVC:UITextFieldDelegate {
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//       //complaint_Text?.showList()
//        if textField == self.complaitTf{
//            complaint_Text.showList()
//        }else {
//           self.ward_Name.showList()
//        }
//
//    }
//
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == self.complaitTf{
//            self.complaint_Text.showList()
//        }else {
//           self.ward_Name.showList()
//        }
//        return false
//    }
//
//
//}
