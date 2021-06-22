//
//  LoginViewControllerViewController.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 05/09/19.
//  Copyright © 2019 IOSuser3. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import PKHUD
class LoginViewControllerViewController: UIViewController {
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var wholeLoginView: UIView!
    @IBOutlet weak var mobileTextfiled: SkyFloatingLabelTextField!
    @IBOutlet weak var loginButton: UIButton!
    var loginModel:LoginStruct?
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = true
        super.viewDidLoad()
       // webService()
       // mobileTextfiled.text = "7993360239"
        let image = UserDefaults.standard.value(forKey:"bgImagview") as! String
        imageV.image = UIImage.init(named:image)
        self.title = "Login"
        loginButton.layer.cornerRadius = 5.0
        loginButton.layer.masksToBounds = true
        wholeLoginView.layer.cornerRadius = 5.0
        wholeLoginView.layer.masksToBounds = true
         //loginWS()
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor.black
        UINavigationBar.appearance().titleTextAttributes =
            [NSAttributedString.Key.foregroundColor : UIColor.white]
        }
        // Do any additional setup after loading the view.
    
    @IBAction func LoginAction(_ sender: Any) {
        if mobileTextfiled.text?.count != 0 {
            if Reachability.isConnectedToNetwork(){
                loginWS()
            }else{
                showAlert(message: interNetconnection)
            }
        } else {
            showAlert(message:enterPHoneNumber)
        }
     }
    func loginWS(){
        let mobileNumber = mobileTextfiled.text!
        let baseUrl = BASE_URL
        let mainURL = baseUrl + "getMpin?MOBILE_NO=\(mobileNumber)"
        self.loading(text:progressMsgWhenLOginClicked)
        PKHUD.sharedHUD.show()
         Alamofire.request(mainURL, method:.get, parameters:nil, encoding:JSONEncoding.default, headers:nil).responseJSON { response in
            DispatchQueue.main.async {
               PKHUD.sharedHUD.hide()
            }
          switch response.result {
                case .success:
                    guard let responseDict = response.result.value as? NSDictionary else {
                        return
                    }
                    print(responseDict)
                    do{
                        let decoder = JSONDecoder()
                        self.loginModel = try decoder.decode(LoginStruct.self, from: response.data!)
                    }catch {
                        print(error.localizedDescription)
                    }
                    UserDefaults.standard.set(self.mobileTextfiled.text, forKey: "MOBILENUMBER") //setObject
                    
//                let  statusMessage =  responseDict.value(forKey:"message") as? String
//                let status = responseDict.value(forKey:"status") as? String
                    let  statusMessage = self.loginModel?.message
                    let status = self.loginModel?.status
                
                if status == "N"{
                    self.showAlert(message:statusMessage!)
                }else if status == "M"{
                    let mpin = self.loginModel?.mpin
                    UserDefaults.standard.set(mpin, forKey:"mpin")
                    UserDefaultVars.mpin = mpin ?? ""
                    
                    let DESIGNATION = self.loginModel?.designation
                    UserDefaults.standard.set(DESIGNATION, forKey:"DESIGNATION")
                    UserDefaultVars.designation = DESIGNATION ?? ""
                    
                    let EMP_NAME = self.loginModel?.empName
                    UserDefaults.standard.set(EMP_NAME, forKey:"EMP_NAME")
                    UserDefaultVars.empName = EMP_NAME ?? ""
                    
                    let otp = self.loginModel?.otp
                    UserDefaults.standard.set(otp, forKey:"otp")
                    
                    let TYPE_ID = self.loginModel?.typeID
                    UserDefaults.standard.set(TYPE_ID, forKey:"TYPE_ID")
                    UserDefaultVars.typeId = TYPE_ID ?? ""
                    
                    let MOBILE_NO = self.loginModel?.mobileNo
                    UserDefaults.standard.set(MOBILE_NO, forKey:"MOBILE_NO")
                    UserDefaultVars.mobileNumber = MOBILE_NO ?? ""
                    
                    
                    let EMP_D = self.loginModel?.empD
                    UserDefaults.standard.set(EMP_D, forKey:"EMP_D")
                    UserDefaultVars.empId = EMP_D ?? ""
                    
                    let Token = self.loginModel?.tokenID
                    UserDefaults.standard.set(Token, forKey:"TOKEN_ID")
                    UserDefaultVars.token = Token ?? ""
                    print( UserDefaultVars.token)
              
                    
                    let vc = storyboards.Main.instance.instantiateViewController(withIdentifier:"MPINViewController") as! MPINViewController
                    self.navigationController?.pushViewController(vc, animated:true)

                }else {
                    let vc = storyboards.Main.instance.instantiateViewController(withIdentifier:"OtpViewController") as! OtpViewController
                    vc.otp = self.loginModel?.otp
                    vc.mobileNumber = self.mobileTextfiled.text!
                    
                    let EMP_D = self.loginModel?.empD
                    UserDefaults.standard.set(EMP_D, forKey:"EMP_D")
                    UserDefaultVars.empId = EMP_D ?? ""
                    
                    let TYPE_ID = self.loginModel?.typeID
                    UserDefaults.standard.set(TYPE_ID, forKey:"TYPE_ID")
                    UserDefaultVars.typeId = TYPE_ID ?? ""
                    
                    let MOBILE_NO = self.loginModel?.mobileNo
                    UserDefaults.standard.set(MOBILE_NO, forKey:"MOBILE_NO")
                    UserDefaultVars.mobileNumber = MOBILE_NO ?? ""
                    
                    let DESIGNATION = self.loginModel?.designation
                    UserDefaults.standard.set(DESIGNATION, forKey:"DESIGNATION")
                    UserDefaultVars.designation = DESIGNATION ?? ""
                    
                    let EMP_NAME = self.loginModel?.empName
                    UserDefaults.standard.set(EMP_NAME, forKey:"EMP_NAME")
                    UserDefaultVars.empName = EMP_NAME ?? ""
                    
                    let Token = self.loginModel?.tokenID
                    UserDefaults.standard.set(Token, forKey:"TOKEN_ID")
                    UserDefaultVars.token = Token ?? ""
                    print( UserDefaultVars.token)
                    self.navigationController?.pushViewController(vc, animated:true)
                }
                case .failure:
                    self.showAlert(message:trAagin)
                break
            }
        }
    }
}
extension LoginViewControllerViewController : UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case mobileTextfiled:
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        default:
            let maxLength = 30
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
    }
}
    
// MARK: - LoginStruct
struct LoginStruct: Codable {
    let status, message, empD, empName: String?
    let mobileNo, designation, typeID, mpin: String?
    let otp, tokenID: String?

    enum CodingKeys: String, CodingKey {
        case status, message
        case empD = "EMP_D"
        case empName = "EMP_NAME"
        case mobileNo = "MOBILE_NO"
        case designation = "DESIGNATION"
        case typeID = "TYPE_ID"
        case mpin, otp
        case tokenID = "TOKEN_ID"
    }
}

