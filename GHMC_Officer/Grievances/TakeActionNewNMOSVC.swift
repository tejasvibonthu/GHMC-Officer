////
////  TakeActionNewNMOSVC.swift
////  GHMC_Officer
////
////  Created by IOSuser3 on 27/04/20.
////  Copyright © 2020 IOSuser3. All rights reserved.
////
//
//import UIKit
//import Alamofire
//import PKHUD
//struct FullData : Decodable {
//    let tag : String?
//    let status : Bool?
//    let data : [Datas]?
//}
//struct Datas :Decodable {
//    let id : String?
//    let name : String?
//}
//class TakeActionNewNMOSVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource ,UITextFieldDelegate{
//    @IBOutlet weak var idproof: UITextField!
//    @IBOutlet weak var citizenName: UITextField!
//    @IBOutlet weak var mobileNumber: UITextField!
//    @IBOutlet weak var emailId: UITextField!
//    @IBOutlet weak var ampunt: UITextField!
//    @IBOutlet weak var remarks: UITextView!
//    @IBOutlet weak var submitBtn: cornerbtn!
//    @IBOutlet weak var selectIdProof: UITextField!
//    @IBOutlet weak var bgImg: UIImageView!
//    var image:String?
//    var getIdProofModel:FullData?
//    var myPickerData = [String]()
//    let thePicker = UIPickerView()
//    var idString : String?
//    var updateGrivencemodel:grivenceUpdate?
//    var mobNum : String?
//
//    
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let image = UserDefaults.standard.value(forKey:"bgImagview") as! String
//        UserDefaults.standard.set(emailId.text, forKey: "emailId") //setObject
//        UserDefaults.standard.set(ampunt.text, forKey: "amount")
//        UserDefaults.standard.set(mobileNumber.text, forKey: "nmosMobileno") //setObject
//        UserDefaults.standard.set(citizenName.text, forKey: "citizenName")
//        UserDefaults.standard.set(idproof.text, forKey: "idproof") //setObject
//        self.bgImg.image = UIImage.init(named:image);        self.navigationController?.navigationBar.isHidden = true
//        //create picker and getidproofs
//        self.thePicker.delegate = self
//        self.thePicker.dataSource = self
//        mobileNumber.delegate = self
//        selectIdProof.inputView = thePicker
//        getIDproofs()
//    }
//    
//    @IBAction func back_buttonAction(_ sender: Any) {
//        self.navigationController?.popViewController(animated:true)
//    }
//    
//  
//    @IBAction func submitbtnclick(_ sender: Any) {
//       mobNum = mobileNumber.text
//        if Reachability.isConnectedToNetwork(){
//            if  isdataValid(){
//                //call submit nmos service
//                self.updateGrivence()
//            }
//            
//        }else{
//            showAlert(message:interNetconnection)
//        }
//    }
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return self.getIdProofModel?.data?.count ?? 0
//
//    }
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return self.getIdProofModel?.data?[row].name
//    }
//    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        selectIdProof.text = self.getIdProofModel?.data?[row].name
//        idString = self.getIdProofModel?.data?[row].id
//        UserDefaults.standard.set(idString, forKey: "idType")
//
//    }
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard let textFieldText = mobileNumber.text,
//            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
//                return false
//        }
//        let substringToReplace = textFieldText[rangeOfTextToReplace]
//        let count = textFieldText.count - substringToReplace.count + string.count
//        return count <= 10
//    }
//    func getIDproofs(){
//        let baseUrl = BASE_URL
//        let mainURL = baseUrl + "getIdProofTypes"
//        self.loading(text:progressMsgWhenLOginClicked)
//        PKHUD.sharedHUD.show()
//        Alamofire.request(mainURL, method:.get, parameters:nil, headers:nil).responseJSON { response in
//            
//            DispatchQueue.main.async {
//                PKHUD.sharedHUD.hide()
//            }
//            switch response.result{
//            case .success:
//                do{
//                    self.getIdProofModel = try JSONDecoder().decode(FullData.self, from: response.data!) // Decoding our data
//                  //  print(self.getIdProofModel?.status ?? "")
//                    self.thePicker.reloadAllComponents()
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
//    
//
//    func updateGrivence(){
//        let deviceId = UIDevice.current.identifierForVendor!.uuidString
//        let mobileno = UserDefaults.standard.value(forKey:"MOBILE_NO")!
//        let name = UserDefaults.standard.value(forKey:"EMP_NAME")!
//        _ = UserDefaults.standard.value(forKey:"TYPE_ID")!
//       let  modeId = UserDefaults.standard.value(forKey:"MODEID") as? String
//        let  wardId = UserDefaults.standard.value(forKey:"Ward_id") as? String
//        let  location = UserDefaults.standard.value(forKey:"Location1") as? String
//        let  updatestatus = UserDefaults.standard.value(forKey:"COMPLAINT_ID") as? String
//        let  complaintID = UserDefaults.standard.value(forKey:"comp_id") as? String
//        let  vehicleId  = UserDefaults.standard.value(forKey:"vehicleSlnum") as? String
//        let  noofTrips  = UserDefaults.standard.value(forKey:"nooftrips") as? String
//        let  totalnw  = UserDefaults.standard.value(forKey:"totalnw") as? String
//        let dict :Parameters  = ["userid":"cgg@ghmc",
//                                 "password":"ghmc@cgg@2018",
//                                 "remarks":description ,
//                                 "photo":"",
//                                 "latlon":location ?? "",
//                                 "mobileno":"\(mobileno)-\(name)",
//                                 "updatedstatus":updatestatus ?? "",
//                                 "compId":complaintID ?? "",
//                                 "deviceid":deviceId,
//                                 "no_of_trips":noofTrips ?? "",
//                                 "total_net_weight":totalnw ?? "",
//                                 "claimant_status":wardId ?? "",
//                                 "source":modeId ?? "",
//                                 "Trader_name":citizenName.text ?? "",
//                                 "email":emailId.text ?? "",
//                                 "Id_proof_type":idString ?? "",
//                                 "Id_proof_no":idproof.text ?? "",
//                                 "Fine_amount":ampunt.text ?? "",
//                                 "Nmos_mobile_no":mobileNumber.text ?? "",
//                                 "lower_staff_id":wardId ?? "",
//                                 "vehicleNo":vehicleId ?? ""
//        ]
//        
//        DispatchQueue.main.async {
//            self.loading(text:progressMsgWhenLOginClicked)
//            PKHUD.sharedHUD.show()
//        }
//        
//        Alamofire.request(Router.updateGrivence(params:dict)).responseJSON {response in
//         //   print("photouploadparameters",dict)
//          //  print("photouploadresponse",response)
//            
//            DispatchQueue.main.async {
//                PKHUD.sharedHUD.hide()
//            }
//            switch response.result{
//            case .success:
//                do{
//                    let decoder = JSONDecoder()
//                    self.updateGrivencemodel = try decoder.decode(grivenceUpdate.self, from: response.data!)
//                    DispatchQueue.main.async {
//                        if  self.updateGrivencemodel?.status == "True"{
//                            //                            self.showAlert(message:(self.updateGrivencemodel?.compid! ?? ""))
//                            
//                            let alert = UIAlertController(title: "MYGHMC", message:self.updateGrivencemodel?.compid!, preferredStyle: UIAlertController.Style.alert)
//                            alert.addAction(UIAlertAction.init(title:"OK", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
//                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                                appDelegate.openDashboard()
//                            }))
//                            self.present(alert, animated: true, completion: nil)
//                            
//                        }else {
//                            self.showAlert(message:(self.updateGrivencemodel?.Message ?? ""))
//                        }
//                    }
//                }catch {
//                    print(error.localizedDescription)
//                }
//                break
//            case .failure(let error):
//                print(error)
//                self.showAlert(message:failedupdate)
//                
//                break
//                
//                
//            }
//            
//        }
//    }
//    func isdataValid()->Bool {
//        if citizenName.text == ""{
//            showAlert(message:"Please enter Citizen / Trade Name")
//            return false
//        }
//       else if selectIdProof.text?.count == 0{
//            showAlert(message:"Please select idproof")
//            return false
//        }
//        
//        else if (mobileNumber.text == ""){
//            showAlert(message:"Please enter mobile number")
//            return false
//        }
//        else if(!mobNum!.isPhoneNumber) || (phoneNumbervalidate(value: mobNum!)){
//            showAlert(message:"Please enter valid mobile number")
//
//        }
//        else if (mobileNumber.text == ""){
//            showAlert(message:"Please enter valid mobile number")
//            return false
//        }
//        else if emailId.text == ""{
//            showAlert(message:"Please enter email")
//            return false
//        }
//        else if ampunt.text == ""{
//            showAlert(message:"Please enter Amount")
//            return false
//        }
//        else if remarks.text == ""{
//            showAlert(message:"Please enter remarks")
//            return false
//        }
//            
//        
//        return true
//    }
//    func phoneNumbervalidate(value: String) -> Bool {
//        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
//        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
//        let result = phoneTest.evaluate(with: value)
//        return result
//    }
//
//}
//extension String {
//    var isPhoneNumber: Bool {
//        do {
//            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
//            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
//            if let res = matches.first {
//                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count && self.count == 10
//            } else {
//                return false
//            }
//        } catch {
//            return false
//        }
//    }
//}
