//
//  UpdateMpinViewController.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 07/09/19.
//  Copyright © 2019 IOSuser3. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import PKHUD
import Alamofire

class UpdateMpinViewController: UIViewController {

    @IBOutlet weak var bgImagev: UIImageView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var re_enterMpinTf: SkyFloatingLabelTextField!
    @IBOutlet weak var mpinTf: SkyFloatingLabelTextField!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var wholeView: UIView!
    var mobileNumber:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButton.layer.cornerRadius = 5.0
        updateButton.layer.masksToBounds = true
        wholeView.layer.cornerRadius = 5.0
        wholeView.layer.masksToBounds = true
        self.navigationController?.navigationBar.isHidden = true
        numberLabel.text = "Please update mpin to \(mobileNumber ?? "")"
        let image = UserDefaults.standard.value(forKey:"bgImagview") as! String
        bgImagev.image = UIImage.init(named:image)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func updateAction(_ sender: Any) {
        if self.mpinTf.text == nil {
            showAlert(message:enterMpin)
        }else if self.re_enterMpinTf.text == nil{
            showAlert(message:RenterMpin)
        }else if self.re_enterMpinTf.text != self.mpinTf.text {
            showAlert(message:incorrectMpin)
        }else{
            if Reachability.isConnectedToNetwork(){
            UpdateMpinWS()
            }else {
                showAlert(message:interNetconnection)
            }
        }
    }
    @IBAction func backButton_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated:true)
    }
    override func viewDidAppear(_ animated: Bool){
        self.mpinTf.text = ""
        self.re_enterMpinTf.text = ""
    }
    func UpdateMpinWS(){
        
        let baseUrl = BASE_URL
        let  mpin1 = self.mpinTf.text!
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
                print(responseDict)
                if responseDict.value(forKey:"status") as! Bool == true{
                     UserDefaults.standard.set(self.re_enterMpinTf.text!, forKey:"mpin")
                    
                    let alertController = UIAlertController(title: "GHMC", message:responseDict.value(forKey:"tag") as? String, preferredStyle: .alert)
                    
//                    alertController.addAction(UIAlertAction(title: "ok", style: .default, handler: { action in
                        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in

                        //run your function here
                                                let vc = storyboards.Main.instance.instantiateViewController(withIdentifier:"MPINViewController") as! MPINViewController
                                           //  vc.mobileNumber = self.mobileNumber
                                                self.navigationController?.pushViewController(vc, animated:true)
                    }

                    alertController.addAction(OKAction)
                    
                    self.present(alertController, animated: true, completion:nil)
                 //   let appdelete = UIApplication.shared.delegate as! AppDelegate
                 //   if appdelete.update == "otp"{
//                        self.loginWS()
//                    }else {
//                        if UserDefaults.standard.value(forKey:"mpin") != nil {
//                            UserDefaults.standard.set(self.re_enterMpinTf.text!, forKey:"mpin")
//
//                        }
//                    }
//
//
//                    appdelete.openDashboard()
                    
                }else{
                   self.showAlert(message:trAagin)
                }
                
            case .failure:
                self.showAlert(message:trAagin)
                
                
            }
        }
        
        
        }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UpdateMpinViewController : UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case mpinTf:
            let maxLength = 4
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        case re_enterMpinTf:
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
