//
//  MPINViewController.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 06/09/19.
//  Copyright © 2019 IOSuser3. All rights reserved.
//7993360239

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import PKHUD
class MPINViewController: UIViewController {
    @IBOutlet weak var bgImagev: UIImageView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var Mpintextfiled: SkyFloatingLabelTextField!
    @IBOutlet weak var backbutton: UIButton!
    @IBOutlet weak var wholeviewController: UIView!
    var mobileNumber:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        print("token_id\(UserDefaultVars.token)")
        // self.navigationController?.navigationBar.isHidden = true
        wholeviewController.layer.cornerRadius = 5.0
        loginButton.layer.cornerRadius = 5.0
        backbutton.isHidden = true
        self.title = "MPIN"
        let image = UserDefaults.standard.value(forKey:"bgImagview") as! String
        self.mobileNumber =   UserDefaults.standard.value(forKey:"MOBILENUMBER") as? String
       //  Remove Key-Value Pair
      //  UserDefaults.standard.removeObject(forKey: "MOBILE_NO")
        bgImagev.image = UIImage.init(named:image)
    }
    override func viewDidAppear(_ animated: Bool){
      //  self.Mpintextfiled.text = "9999"
        if UserDefaults.standard.value(forKey: "isImageHidden") != nil{
            let condition = UserDefaults.standard.value(forKey: "isImageHidden") as! Bool
            if condition{
                //should be hidden
                self.backbutton.isHidden = true
                UserDefaults.standard.set(false, forKey: "isImageHidden")
            }
        }
        
        
    }
    @IBAction func ButtonAction(_ sender: Any) {
        UpdateMpinWS()
    }
    
    func UpdateMpinWS(){
        let baseUrl = BASE_URL
        let  mpin1 = "0000"
        let mainURL = baseUrl + "updateMpin?MOBILE_NO=\(mobileNumber ?? "")&&mpin=\(mpin1)"
        DispatchQueue.main.async {
            self.loading(text:progressMsgWhenLOginClicked)
            PKHUD.sharedHUD.show()
        }
        Alamofire.request(mainURL, method:.get, parameters:nil, encoding:JSONEncoding.default, headers:nil).responseJSON { response in
            DispatchQueue.main.async {
                PKHUD.sharedHUD.hide()
            }
            switch response.result {
                
            case .success:
                let responseDict = response.result.value as! NSDictionary
                if responseDict.value(forKey:"status") as! Bool == true{
                    
                                let vc = storyboards.Main.instance.instantiateViewController(withIdentifier:"LoginViewControllerViewController") as! LoginViewControllerViewController
                                self.navigationController?.pushViewController(vc, animated:true)
                    
                    
                }else{
                   self.showAlert(message:trAagin)
                }
                
            case .failure:
                self.showAlert(message:trAagin)
                
                
            }
        }
        }
   
    func fcmWS(){
        let baseUrl = BASE_URL
        let fcm_Key1 = fcm_Key ?? ""
        let mainURL = baseUrl + "updateFCM_KEYOfficer?MOBILE_NO=\(mobileNumber!)&&FCM_KEY=\(fcm_Key1)"
       // print(mainURL)
        DispatchQueue.main.async {
        self.loading(text:progressMsgWhenLOginClicked)
        PKHUD.sharedHUD.show()
        }
        Alamofire.request(mainURL, method:.get, parameters:nil, encoding:JSONEncoding.default, headers:nil).responseJSON { response in
            DispatchQueue.main.async {
               PKHUD.sharedHUD.hide()
            }
            switch response.result {
                
            case .success:
                let responseDict = response.result.value as! NSDictionary
//print(responseDict)
                if UserDefaultVars.designation == "Concessioner Supervisor"
                {
                    let vc = storyboards.Concessioner.instance.instantiateViewController(withIdentifier:"ConcessionerTicketsList") as! ConcessionerTicketsList
                    self.navigationController?.pushViewController(vc, animated:true)
                }
//                if responseDict.value(forKey:"status") as! Bool == true{
//                    let appdelete = UIApplication.shared.delegate as! AppDelegate
//                   appdelete.openDashboard()
//                    
//                    
//                }else{
//                    self.showAlert(message:trAagin)
//                }
//                
            case .failure:
                self.showAlert(message:trAagin)
                break
                
                
            }
        }
        
        
    }
        
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated:true)
    }
    
    @IBAction func MpinValidation(_ sender: Any) {
//        let appdelete = UIApplication.shared.delegate as! AppDelegate
//        appdelete.openDashboard()
        
        if Mpintextfiled.text == UserDefaults.standard.value(forKey:"mpin") as? String {
            if Reachability.isConnectedToNetwork(){
                fcmWS()
            }else {
                showAlert(message:interNetconnection)
            }


        }else{
            showAlert(message:mpinvalidatefail)

        }
   }
    
}
extension MPINViewController : UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case Mpintextfiled:
            let maxLength = 4
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
