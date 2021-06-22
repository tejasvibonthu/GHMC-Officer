//
//  NewLaunchViewController.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 04/05/20.
//  Copyright © 2020 IOSuser3. All rights reserved.
//

import UIKit

class NewLaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message: interNetconnection);return}
        if UserDefaults.standard.object(forKey: "mpin") != nil{
              if UserDefaults.standard.object(forKey: "mpin") as! String == "0000"
              {
                  let vc = UIStoryboard.init(name:"Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewControllerViewController") as? LoginViewControllerViewController
                self.navigationController?.pushViewController(vc!, animated: true)
              }
              else{
                  let vc = self.storyboard?.instantiateViewController(withIdentifier: "MPINViewController") as! MPINViewController
                  self.navigationController?.pushViewController(vc, animated: true)
              }
          }
        else
        {
            let vc = UIStoryboard.init(name:"Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewControllerViewController") as? LoginViewControllerViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }
      //  self.versionCheck()
    }
    
    func versionCheck(){
        let params = ["userid":"cgg@ghmc",
                      "password":"ghmc@cgg@2018",
                      "mode":"ios"]
        NetworkRequest.makeRequest(type: VersionCheckModel.self, urlRequest: Router.versionCheck(Parameters: params), completion: { [weak self](result) in
            switch result{
            case  .success(let data):
                print(data.tag)
                if data.status == true {
                    let serverVersion = data.tag!
                    let localVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
                    print(localVersion)
                    if serverVersion == localVersion {
                        if UserDefaults.standard.object(forKey: "mpin") != nil{
                            if UserDefaults.standard.object(forKey: "mpin") as! String == "0000"
                            {
                                let vc = UIStoryboard.init(name:"Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewControllerViewController") as? LoginViewControllerViewController
                                self?.navigationController?.pushViewController(vc!, animated: true)
                            }
                            else{
                                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "MPINViewController") as! MPINViewController
                                self?.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                        else
                        {
                            let vc = UIStoryboard.init(name:"Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewControllerViewController") as? LoginViewControllerViewController
                            self?.navigationController?.pushViewController(vc!, animated: true)
                        }
                    } else{
                        self?.showAlert(message: "Please update the app to version " + (data.tag ?? " "))
                        {
                            if let customAppURL = URL(string: "https://apps.apple.com/us/app/ghmc-officer/id1229555401"){
                                if(UIApplication.shared.canOpenURL(customAppURL)){
                                    UIApplication.shared.open(customAppURL, options: [:], completionHandler: nil)
                                }
                                else {
                                    self?.showAlert(message: "Unable to open Appstore")
                                }
                            }
                        }
                    }
                }
                //                                     else {
                //                                        self?.showAlert(message: data.message ?? "Server Not Respomding")
                //                                    }
                //                        if UserDefaults.standard.object(forKey: "mpin") != nil{
                //                                   let vc = self?.storyboard?.instantiateViewController(withIdentifier: "MPINViewController") as! MPINViewController
                //                                   //  vc.mpin = data.data?.mpin
                //                                   self?.navigationController?.pushViewController(vc, animated: true)
                //                               } else {
                //                               let  vc = UIStoryboard.init(name:"Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewControllerViewController") as? LoginViewControllerViewController
                //                               self?.navigationController?.pushViewController(vc!, animated: true)
                //                           }
                //                        }  else {
                //                            self?.showAlert(message: data.message ?? "")
                //                                if let url = URL(string: "itms-apps://apple.com/app/id1528824793") {
                //                                   UIApplication.shared.open(url)
                //                            }
                //                        }
                //                      } else {
                //                        self?.showAlert(message: data.message ?? "Server Not Responding")
                
                
            case .failure(let err):
                print(err)
                DispatchQueue.main.async {
                    self?.showAlert(message: "Server went wrong")
                    //code to be executed on main thread
                }
            }
        })
    }
    }
struct VersionCheckModel: Codable {
    let tag: String?
    let url: String?
    let message: String?
    let status: Bool?

    enum CodingKeys: String, CodingKey {
        case tag, url
        case message = "Message"
        case status
    }
}
