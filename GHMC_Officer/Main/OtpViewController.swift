//
//  OtpViewController.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 05/09/19.
//  Copyright © 2019 IOSuser3. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import PinCodeTextField
import Alamofire
import PKHUD

class OtpViewController: UIViewController {
    //variables
    @IBOutlet weak var bgimageview: UIImageView!
   // var phonenumber:String! = nil
    var timer: Timer?
    var counter = 30
    var otp:String?
    var mobileNumber:String?


    @IBOutlet weak var otptextfiled: PinCodeTextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var validateButton: UIButton!
    //@IBOutlet weak var otpTextFiled: SkyFloatingLabelTextField!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var wholeOtpView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Verification Code"
        wholeOtpView.layer.cornerRadius = 5.0
        wholeOtpView.layer.masksToBounds = true
        validateButton.layer.cornerRadius = 10.0
        validateButton.layer.masksToBounds = true
        createTimer()
        let image = UserDefaults.standard.value(forKey:"bgImagview") as! String
        numberLabel.text = "Please type the verification code sent to " + (self.mobileNumber ?? "")
        print("mob",mobileNumber ?? "")
       // print("otprespone",otp!)
        bgimageview.image = UIImage.init(named:image)
        self.navigationController?.navigationBar.isHidden = true
    }
    
@objc func updateTimer() {
        // 1
        if counter > 0 {
            print("\(counter) seconds to the end of the world")
            counter -= 1
            timeLabel.text = "Waiting for OTP : 00:\(counter)"
        }else{
          timeLabel.text = "Resend OTP"
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(ResendOtp))
            timeLabel.isUserInteractionEnabled = true
            timeLabel.addGestureRecognizer(tap)
            
    }
    }
    @objc func ResendOtp(){
        
        if Reachability.isConnectedToNetwork(){
       resendOtpServiceCall()
        }else {
            showAlert(message:interNetconnection)
        }
        
        
    }
    
    func resendOtpServiceCall(){
      
        DispatchQueue.main.async {
            self.loading(text:progressMsgWhenLOginClicked)
            PKHUD.sharedHUD.show()
        }
        let parameters = ["userid":"cgg@ghmc","password":"ghmc@cgg@2018","mobile_no":mobileNumber]
        Alamofire.request(Router.resendOtp(params: parameters as Parameters)).responseJSON {response in
                 DispatchQueue.main.async {
                PKHUD.sharedHUD.hide()
                }
                switch response.result{
                case .success:
                    let responseDict = response.result.value as! NSDictionary
                    print(responseDict)
                    let status = responseDict.value(forKey:"status") as! Bool
                    if status == true {
                        if !(responseDict.value(forKey:"otp")  is NSNull)
                        {
                       let otp1 = responseDict.value(forKey:"otp") as! String
                           // print("otpresponse",otp1)
                            self.otp = otp1
                            self.counter = 30
                            self.createTimer()
                            
                        }
                    }else{
                        DispatchQueue.main.async {
                         //  let status = responseDict.value(forKey:"otp") as! Bool
                            self.showAlert(message : responseDict.value(forKey:"otp") as! String )
                        }
                        
                        
                    }
                  //  print(response)
                    break
                case .failure(let error):
                    print(error)
                    self.showAlert(message:trAagin)
                    
                    break
                    
                    
                }
                
            }
        }
        
  
    func createTimer() {
        // 1
        if timer == nil {
            timer?.tolerance = 0.1
            // 2
            timer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(updateTimer),
                                         userInfo: nil,
                                         repeats: true)
        }
    }

    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated:true)
    }
    
    @IBAction func validationButtonClicked(_ sender: Any) {
        if otptextfiled.text == nil {
            showAlert(message:otpnil)
        }else {
            print("otp : \(String(describing: otp))")
            if otptextfiled.text! == self.otp {
             fcmWS()
             // showAlert(message:validationSuccessFully)
               
               }else{
                showAlert(message:otpIncorrect)
            }
        }
    }
    func fcmWS(){
        let baseUrl = BASE_URL
        let fcm_Key1 = fcm_Key!
        let mainURL = baseUrl + "updateFCM_KEYOfficer?MOBILE_NO=\(mobileNumber!)&&FCM_KEY=\(fcm_Key1)"
        print(mainURL)
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
                    let vc = storyboards.Main.instance.instantiateViewController(withIdentifier:"UpdateMpinViewController") as! UpdateMpinViewController
                    vc.mobileNumber = self.mobileNumber
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else{
                    print("FCM_KEY updated not updated")
                }
            case .failure:
                break
            }
        }
    }
}
