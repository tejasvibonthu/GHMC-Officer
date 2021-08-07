//
//  TakesactionVC.swift
//  GHMC_Officer
//
//  Created by deep chandan on 19/04/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//

import UIKit
import DropDown
import CoreLocation
import GoogleMaps
import GooglePlaces
import MobileCoreServices
import GrowingTextView
import Alamofire

class TakesactionVC: UIViewController,UIImagePickerControllerDelegate,CLLocationManagerDelegate,UIPickerViewDelegate, UIPickerViewDataSource ,UITextViewDelegate,UIDocumentPickerDelegate,UIDocumentMenuDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var complaintBtn: UIButton!
    @IBOutlet weak var wardnameBtn: UIButton!
    @IBOutlet weak var vehicleTypeBtn: UIButton!
    @IBOutlet weak var nofTripsTF: UITextField!
    @IBOutlet weak var totalnetWtTF: UITextField!
    @IBOutlet weak var claimStatusBtn: UIButton!
    @IBOutlet weak var descriptionTV: GrowingTextView!
    @IBOutlet weak var camImg: UIImageView!
    var imagestr1:String!
    let types: [String] = [kUTTypePDF as String]
    var imagesPicker: UIImagePickerController! = UIImagePickerController()
    var locationManager:CLLocationManager?
    var vehicleId:String?
    var location:String? = nil
    var compID:String?
    var getwardsModel:getwardDeatilsStruct?
    var vehicleDataModel:[vehiclesFullData]?
    var getstatusTypesModel:[GetStatusTypesStruct]?
    var getClaimStatusModel:[GetClaimstatusTypeStruct]?
    var complainttypeDataSource:[String] = []
    var vehicledatasourceArry:[String] = []
    var wardsdatasourceArry:[String] = []
    var claimstatusdatasourceArray:[String] = []
    var lowerstaffModel:GetLowerstaffTypeStruct?
    var lowerstaffTabledataSourceArray:[String]?
    var updateGrivencemodel:grivenceUpdateStruct?
    var updateWardModel:updateWrdStruct?
    var compType:String?
    var compstatusId:String?
    var wardId:String?
    var claimstatusid:String?
    let dropdown = DropDown()
    var subcatId:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UserDefaults.standard.value(forKey:"bgImagview") as! String
        let imageGesture = UITapGestureRecognizer.init(target:self, action:#selector(imagegestureAction))
         camImg.addGestureRecognizer(imageGesture)
        descriptionTV.textColor = UIColor.darkGray
        self.imagesPicker.delegate = self
        self.imagestr1 = ""
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = UIColor.init(patternImage:UIImage.init(named:image)!)
        self.wardnameBtn.isHidden = true
        self.vehicleTypeBtn.isHidden = true
        self.nofTripsTF.isHidden = true
        self.totalnetWtTF.isHidden = true
        self.claimStatusBtn.isHidden = true
        self.getVehicleIds()
        self.getStatusTypeWS()
        self.navigationController?.navigationBar.isHidden = true
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()

    }
    @IBAction func backClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func complaintBtnClick(_ sender: UIButton) {
        dropdown.dataSource = complainttypeDataSource
        dropdown.anchorView = sender
        dropdown.show()
        dropdown.selectionAction = {[unowned self] (index : Int , item : String) in
            
            sender.setTitle(item, for: .normal)
            complaintBtn.setTitleColor(.black, for: .normal)
            self.compstatusId = self.getstatusTypesModel?[index].id
                       print("selected index \(index) item \(item)")
            dropdown.reloadAllComponents()
            self.dropdown.hide()
            if self.compstatusId == "4"{
                dropdown.reloadAllComponents()
                self.getWardWS()
                self.wardnameBtn.isHidden = false
                self.wardnameBtn.setTitle("Select Ward", for: .normal)
            } else {
                self.claimStatusBtn.isHidden = true
                self.wardnameBtn.isHidden = true
            }
          //  subcatId = "34"
         //   self.compstatusId = "10"
            if self.compstatusId == "10"{
                self.wardnameBtn.isHidden = true
                self.claimStatusBtn.isHidden = false
                getClaimStatusWS()
            } else {
                self.claimStatusBtn.isHidden = true
            }
            if self.compstatusId == "15"{
                self.claimStatusBtn.isHidden = true
                self.wardnameBtn.isHidden = true
                getLowerStaffWS()
            }
            if self.compstatusId != "10"{
                self.claimStatusBtn.isHidden = true
            }
            
            if(UserDefaultVars.designation == "Ramky Engineer"){
                if(self.compstatusId == "11"){
                    self.vehicleTypeBtn.isHidden = false
                    self.nofTripsTF.isHidden = false
                    self.totalnetWtTF.isHidden = false
                }
            }
        }
    }
    @IBAction func wardnameBtnClick(_ sender: UIButton) {
        dropdown.dataSource = wardsdatasourceArry
        dropdown.anchorView = sender
        dropdown.show()
        dropdown.selectionAction = {[unowned self] (index : Int , item : String) in
          print("selected index \(index) item \(item)")
                        sender.setTitle(item, for: .normal)
            wardnameBtn.setTitleColor(.black, for: .normal)
            self.wardId = self.getwardsModel?.data?[index].id
            dropdown.reloadAllComponents()
            self.dropdown.hide()

        }
    }
    @IBAction func claimStatusBtnClick(_ sender: UIButton) {
        print(claimstatusdatasourceArray)
        dropdown.dataSource = claimstatusdatasourceArray
        dropdown.anchorView = sender
        dropdown.show()
        dropdown.selectionAction = {[unowned self] (index : Int , item : String) in
          print("selected index \(index) item \(item)")
                        sender.setTitle(item, for: .normal)
            claimStatusBtn.setTitleColor(.black, for: .normal)
            self.claimstatusid = self.getClaimStatusModel?[index].id
            self.dropdown.hide()
        }
    }
    func getStatusTypeWS(){
           let parms  = [
            "userid":userid,
            "password":password,
            "type_id":UserDefaultVars.typeId,
            "designation":UserDefaultVars.designation
           ]
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message:noInternet);return}
        NetworkRequest.makeRequestArray(type: GetStatusTypesStruct.self, urlRequest: Router.getstatusType(params: parms)) { [weak self](result) in
                switch result {
                case .success(let resp):
                  //  print(resp)
                    self?.getstatusTypesModel = resp
                    if  ((self?.getstatusTypesModel?.isEmpty) != nil) {
                      //  self?.subcatId = "34"
                        if self?.subcatId == "34"{
                    self?.getstatusTypesModel?.forEach({self?.complainttypeDataSource.append($0.type ?? "")})
                        } else{
                          self?.getstatusTypesModel?.forEach({self?.complainttypeDataSource.append($0.type ?? "")})
                            self?.complainttypeDataSource.remove(at: 8)
                            self?.getstatusTypesModel?.remove(at: 8)
                        }
                    }
                    else
                    {
                        self?.showAlert(message: "No records found")
                    }
                case .failure(let err):
                    print(err)
                    self?.showAlert(message: err.localizedDescription)
                }
            }
        
    }
    func getVehicleIds(){
        let params  = ["userid":userid,
                       "password":password]
        
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message:noInternet);return}
        NetworkRequest.makeRequestArray(type: vehiclesFullData.self, urlRequest: Router.getRamkeyVehicles(Parameters: params)) { [weak self](result) in
            switch result
            {
            case  .success(let
                            vehicleData):
                if vehicleData != nil {
                    self?.vehicleDataModel = vehicleData
                    self?.vehicleDataModel?.forEach({self?.vehicledatasourceArry.append($0.vehicleNumber ?? "")})
                    
                    
                } else {
                    self?.showAlert(message:serverNotResponding)
                }
                
            case .failure(let err):
                print(err)
                self?.showAlert(message: serverNotResponding)
            }
        }
        
    }
    func getWardWS(){
        let params = ["userid":userid,
                      "password":password,
                     ]
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message:noInternet);return}
        NetworkRequest.makeRequest(type: getwardDeatilsStruct.self, urlRequest: Router.getWard(params: params)) { [weak self](result) in
            switch result
            {
            case  .success(let wardsData):
                self?.getwardsModel = wardsData
                if wardsData.status == "true" {
                    self?.getwardsModel?.data?.forEach({self?.wardsdatasourceArry.append($0.ward ?? "")})
                } else {
                    self?.showAlert(message:self?.getwardsModel?.status ?? "")
                }
            case .failure(let err):
                print(err)
                self?.showAlert(message: serverNotResponding)
            }
        }
    }
    @IBAction func vehicleTypeBtnClick(_ sender: UIButton) {
        print(vehicledatasourceArry)
        dropdown.dataSource = vehicledatasourceArry
        dropdown.anchorView = sender
        dropdown.show()
        dropdown.selectionAction = {[unowned self] (index : Int , item : String) in
            sender.setTitle(item, for: .normal)
            vehicleTypeBtn.setTitleColor(.black, for: .normal)
            self.vehicleId = self.vehicleDataModel?[index].slno
            self.dropdown.hide()
        }
    }
    
    func getClaimStatusWS(){
            let params  = ["userid":userid,
                                 "password":password,
                                 "type_id":UserDefaultVars.typeId]
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message:noInternet);return}
        NetworkRequest.makeRequestArray(type: GetClaimstatusTypeStruct.self, urlRequest: Router.getClaimtStatus(params: params)) { [weak self](result) in
            switch result
            {
            case  .success(let
                            statustypes):
                if statustypes != nil {
                    self?.getClaimStatusModel = statustypes
                    self?.getClaimStatusModel?.forEach({self?.claimstatusdatasourceArray.append($0.type ?? "")})
                } else {
                    self?.showAlert(message:serverNotResponding)
                }
                
            case .failure(let err):
                print(err)
                self?.showAlert(message: serverNotResponding)
            }
        }
    }
    func getLowerStaffWS(){
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message:noInternet);return}
        let empId = UserDefaultVars.empId
        let urlString = BASE_URL +  "/getLowerStaff?empId=\(empId)"
        Alamofire.request(urlString, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: nil).responseJSON { [weak self]
            response in
            guard let self = self else {return}
            switch response.result {
            case .success(let data):
                do {
                    let updateData = try JSONDecoder().decode(GetLowerstaffTypeStruct.self, from: response.data!)
                    if updateData.status == true {
                        self.lowerstaffModel = updateData
                      //  self.lowerstaffModel?.data?.forEach({self.lowerstaffTabledataSourceArray?.append($0.empName ?? "")})
                    } else{
                        self.showAlert(message: serverNotResponding)
                    }
                }
                catch let err {
                    self.showAlert(message:"\(err.localizedDescription)")
                    print("error decoding \(err)")
                }
                break
            case .failure(let error):
                self.showAlert(message:serverNotResponding)            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        location = "\(locValue.latitude),\(locValue.longitude)"
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.vehicleDataModel?.count ?? 0
    }
    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagesPicker.delegate = self
            imagesPicker.sourceType = .camera
            self.present(imagesPicker, animated: true, completion: nil)
        }

    }
    func photoLibrary()
    {

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagesPicker.delegate = self
            imagesPicker.sourceType = .photoLibrary
            self.present(imagesPicker, animated: true, completion: nil)
        }
    }
    func openDocument(){
       let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
       documentPicker.delegate = self
       documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)

       // self.present(importMenu, animated: true, completion: nil)
    }
    @objc func imagegestureAction(){
        
        let controller = UIAlertController(title: "Select a picture which properly describes the issue!", message: nil, preferredStyle: .actionSheet)
        
        
        controller.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (action) in
            //   print("Choosed Camera")
            self.camera()
            
            
        }))
        
        controller.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { (action) in
            //  print("Choosed Gallery")
            
            self.photoLibrary()
            
        }))
        controller.addAction(UIAlertAction(title: "Choose Document", style: .default, handler: { (action) in
            //   print("Choosed Document")
            self.openDocument()
            
        }))
        
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            print("Cancelled")
            
        }))
        
        if let popoverController = controller.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(controller, animated: true, completion: nil)
        
    }
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let data = try! Data(contentsOf: urls[0])
        self.camImg.image = UIImage(named:"pdfnew")
        imagestr1  = data.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
    }
    public func documentMenu(_ picker:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    
    func documentPickerWasCancelled(_ picker: UIDocumentPickerViewController) {
        //   print("view was cancelled")
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }


    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        NSLog("\(info)")
        
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            dismiss(animated: true, completion: nil)
            self.camImg.image = image
            let image1 : UIImage = image
            let imageData:NSData = image1.jpeg(.lowest)! as NSData
            imagestr1 = imageData.base64EncodedString(options: .lineLength64Characters)
                    }
           

       }
    @IBAction func submitClick(_ sender: Any) {
        if validation(){
        self.updateGrivenceWS()
        }
    }
    func validation() -> Bool{
        if complaintBtn.currentTitle == "Select complaint type"{
            self.showAlert(message: "Please select complaint type")
            return false
        } else if self.compstatusId == "4" && (self.wardnameBtn.currentTitle == "Select Ward" || self.wardnameBtn.currentTitle == ""){
            self.showAlert(message: "Please select ward")
            return false
        } else if self.compstatusId == "10" && (self.claimStatusBtn.currentTitle == "Select Claim status" || self.claimStatusBtn.currentTitle == ""){
            self.showAlert(message: "Please select Claim Status")
            return false
        } else if descriptionTV.text == ""{
            self.showAlert(message: "Please enetr remarks")
            return false
        }  else if imagestr1 == ""{
            self.showAlert(message: "Please capture photo")
            return false
        }
        return true
    }
    func updateGrivenceWS(){
        //19.0176147,72.8561644
        let mobileno = UserDefaultVars.mobileNumber
        let name = UserDefaultVars.empName
        let type_id = UserDefaultVars.typeId
        guard let location1 = location else {
            showAlert(message:"Unable to fetch location.Please try again later..")
            return
        }
        let params = ["userid": userid ,
                      "password": password,
                      "type_id": "\(type_id)",
                      "mobileno": "\(mobileno)-\(name)-\(type_id)",
                      "updatedstatus":self.compstatusId!,
                      "compId": compID ?? "",
                      "remarks":descriptionTV.text ?? "",
                      "photo":imagestr1 ??  "",
                      "latlon": location1,
                      "deviceid":deviceId,
                      "no_of_trips":nofTripsTF.text ?? "",
                      "total_net_weight":totalnetWtTF.text ?? "",
                      "trader_name":"",
                      "id_proof_type":"",
                      "id_proof_no":"",
                      "nmos_mobile_no":"",
                      "email":"",
                      "fine_amount":"",
                      "source":UserDefaultVars.modeID,
                      "vehicleNo":vehicleId ?? "",
                      "claimant_status":claimstatusid ?? "",
                      "lower_staff_id": wardId ?? ""
        ] as [String : Any]
        print(params)
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message:noInternet);return}
        NetworkRequest.makeRequest(type: grivenceUpdateStruct.self, urlRequest: Router.updateGrivence(params : params)) { [weak self](result) in
                switch result {
                case .success(let resp):
                    print(resp)
                    DispatchQueue.main.async {
                     self?.updateGrivencemodel = resp
                        if  self?.updateGrivencemodel?.status == "True"{
                            let alert = UIAlertController(title: "MYGHMC", message:self?.updateGrivencemodel?.compid, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction.init(title:"OK", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.openDashboard()
                            }))
                            self?.present(alert, animated: true, completion: nil)
                            
                        }else {
                            self?.showAlert(message:(self?.updateGrivencemodel?.status ?? ""))
                        }
                    }
                case .failure(let err):
                    print(err)
                    self?.showAlert(message: err.localizedDescription)
                }
            }
    }
    func updateWardWS(){
        guard let location1 = location else {
            showAlert(message:"Unable to fetch location.Please try again later..")
            return
        }
        let mobileno = UserDefaultVars.mobileNumber
        let name = UserDefaultVars.empName
        let params = [ "userid":userid,
                       "password":password,
                       "remarks":descriptionTV.text ?? "",
                       "photo":imagestr1 ?? "",
                       "latlon":location1,
                       "mobileno":"\(mobileno)-\(name)",
                       "deviceid":deviceId,
                       "compId":compID ?? "",
                       "updatedstatus":compstatusId,
                       "ward":wardId ?? ""] as [String : Any]
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message:noInternet);return}
        NetworkRequest.makeRequest(type: updateWrdStruct.self, urlRequest: Router.forwordtoAnotherWard(params : params)) { [weak self](result) in
                switch result {
                case .success(let resp):
                    print(resp)
                    DispatchQueue.main.async {
                     self?.updateWardModel = resp
                        if  self?.updateWardModel!.status == true{
                            let alert = UIAlertController(title: "MYGHMC", message:(self?.updateWardModel?.compid ?? ""), preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction.init(title:"OK", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.openDashboard()
                            }))
                            self?.present(alert, animated: true, completion: nil)
                            
                        }else {
                            self?.showAlert(message:(self?.updateWardModel?.tag ?? ""))
                        }
                    }
                case .failure(let err):
                    print(err)
                    self?.showAlert(message: err.localizedDescription)
                }
            }
}
}
// MARK: - GetStatusTypesStructElement
struct GetStatusTypesStruct: Codable {
    let id, type: String?
    let status: Status?
}

enum Status: String, Codable {
    case success = "success"
}


// MARK: - LoginStructElement
struct vehiclesFullData: Codable {
    let slno, vehicleNumber: String?

    enum CodingKeys: String, CodingKey {
        case slno = "SLNO"
        case vehicleNumber = "VEHICLE_NUMBER"
    }
}

struct grivenceUpdate:Codable{
    var compid:String?
    var status:String?
    var Message:String?
    var tag: String?
    var url: String?
}
struct getwardDeatilsStruct:Codable{
        let status: String?
        let tag: String?
        let data: [Datum]?
        // MARK: - Datum
    struct Datum: Codable {
        let ward, id: String?
    }
    }


// MARK: - GetClaimstatusTypeStructElement
struct GetClaimstatusTypeStruct: Codable {
    let id, type, status: String?
}

// MARK: - GetLowerstaffTypeStruct
struct GetLowerstaffTypeStruct: Codable {
    let tag: JSONNull?
    let status: Bool?
    let data: [Datum]?
}

// MARK: - Datum
struct Datum: Codable {
    let empID, empName: String?

    enum CodingKeys: String, CodingKey {
        case empID = "empId"
        case empName
    }
}
//grivenceUpdate
struct grivenceUpdateStruct:Codable{
    var compid:String?
    var status:String?
    var Message:String?
    var tag: String?
    var url: String?
}
struct updateWrdStruct:Codable {
  var  compid:String?
  var tag: String?
  var url: String?
  var status: Bool?
  var Message:String?
   
}
