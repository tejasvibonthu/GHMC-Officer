////
////  TakeActionNewNMOSVC.swift
////  GHMC_Officer
////
////  Created by IOSuser3 on 27/04/20.
////  Copyright © 2020 IOSuser3. All rights reserved.
////
//
import UIKit
import GrowingTextView
import DropDown
import GoogleMaps
class TakeActionNewNMOSVC: UIViewController, CLLocationManagerDelegate {
    var getidProofsModel:getIdProofsStruct?
    var idproofsrabledatasourcearray:[String] = []
    var updateGrivencemodel:grivenceUpdateStruct?
    var dropdown = DropDown()
    var idProof:String?
    var compID:String?
    var locationManager:CLLocationManager?
    var location:String?
    @IBOutlet weak var idproof: UITextField!
    @IBOutlet weak var citizenName: UITextField!
    @IBOutlet weak var mobileNumber: UITextField!
    @IBOutlet weak var emailId: UITextField!
    @IBOutlet weak var ampunt: UITextField!
    @IBOutlet weak var remarks: GrowingTextView!
    @IBOutlet weak var selectIdProof: UIButton!
    @IBOutlet weak var bgImg: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        self.getIdProofsWS()

   }
    
    @IBAction func back_buttonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated:true)
    }
    

    @IBAction func idProofClick(_ sender: UIButton) {
        dropdown.dataSource = idproofsrabledatasourcearray
        dropdown.anchorView = sender
        dropdown.show()
        dropdown.selectionAction = {[unowned self] (index : Int , item : String) in
          print("selected index \(index) item \(item)")
                        sender.setTitle(item, for: .normal)
            selectIdProof.setTitleColor(.black, for: .normal)
            self.idProof = self.getidProofsModel?.data?[index].id
            self.dropdown.hide()
        }
    }
    func getIdProofsWS(){
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message:noInternet);return}
        NetworkRequest.makeRequest(type: getIdProofsStruct.self, urlRequest: Router.getIdProofs) { [weak self](result) in
            switch result
            {
            case .success(let idProofs):
                print(idProofs)
                self?.getidProofsModel = idProofs
                if self?.getidProofsModel?.status == true{
                    self?.getidProofsModel?.data?.forEach({self?.idproofsrabledatasourcearray.append($0.id ?? "")})
                } else {
                    self?.showAlert(message:self?.getidProofsModel?.tag ?? ""){
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            case .failure(let err):
                print(err)
                self?.showAlert(message: serverNotResponding)
            }
        }
    }
    @IBAction func submitbtnclick(_ sender: Any) {
        if isdataValid(){
            self.updateGrivence()
        }
    }
   func updateGrivence(){
    guard let location1 = location else {
        showAlert(message:"Unable to fetch location.Please try again later..")
        return
    }
        let mobileno = UserDefaultVars.mobileNumber
        let name = UserDefaultVars.empName
    let params  = ["userid":userid,
                   "password":password,
                   "remarks":remarks.text ?? "" ,
                   "photo":"",
                   "latlon":location1,
                   "mobileno":"\(mobileno)-\(name)",
                   "updatedstatus":"",
                   "compId":compID ?? "",
                   "deviceid":deviceId,
                   "no_of_trips":"",
                   "total_net_weight": "",
                   "claimant_status":"",
                   "source":UserDefaultVars.modeID,
                   "Trader_name":citizenName.text ?? "",
                   "email":emailId.text ?? "",
                   "Id_proof_type":idProof ?? "",
                   "Id_proof_no":idproof.text ?? "",
                   "Fine_amount":ampunt.text ?? "",
                   "Nmos_mobile_no":mobileNumber.text ?? "",
                   "lower_staff_id":"",
                   "vehicleNo":""
    ] as [String : Any]
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
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        location = "\(locValue.latitude),\(locValue.longitude)"
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    func isdataValid()->Bool {
        let mobNum = mobileNumber.text
        if citizenName.text == ""{
            showAlert(message:"Please enter Citizen / Trade Name")
            return false
        }
        else if selectIdProof.currentTitle == "Please select"{
            showAlert(message:"Please select idproof")
            return false
        }
        
        else if (mobileNumber.text == ""){
            showAlert(message:"Please enter mobile number")
            return false
        }
        else if((mobNum?.isPhoneNumber) != nil) || (phoneNumbervalidate(value: mobNum ?? "")){
            showAlert(message:"Please enter valid mobile number")

        }
        else if (mobileNumber.text == ""){
            showAlert(message:"Please enter valid mobile number")
            return false
        }
        else if emailId.text == ""{
            showAlert(message:"Please enter email")
            return false
        }
        else if ampunt.text == ""{
            showAlert(message:"Please enter Amount")
            return false
        }
        else if remarks.text == ""{
            showAlert(message:"Please enter remarks")
            return false
        }
            
        
        return true
    }
    func phoneNumbervalidate(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = phoneTest.evaluate(with: value)
        return result
    }

}
extension String {
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count && self.count == 10
            } else {
                return false
            }
        } catch {
            return false
        }
    }
 }
struct getIdProofsStruct:Decodable {
    var status:Bool?
    var tag:String?
    var data:[data3]?
}
struct data3:Decodable {
    var id:String?
    var name:String?
}
