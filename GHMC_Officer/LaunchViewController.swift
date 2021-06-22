//
//  LaunchViewController.swift
//  GHMC_Officer
//
//  Created by deep chandan on 09/04/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = UserDefaults.standard.value(forKey:"MODEID") as? String
        
        
        //            let mpin =  UserDefaults.standard.value(forKey:"mpin")
        //                if(mpin != nil){
        //                    let vc = storyboards.Main.instance.instantiateViewController(withIdentifier:"MPINViewController") as! MPINViewController
        //
        //                    self.navigationController?.pushViewController(vc, animated:true)
        //                } else{
        //                    let activeNav = self.revealViewController().frontViewController as! UINavigationController
        //                    let propertyNavVc = storyboards.Main.instance.instantiateViewController(withIdentifier: "LoginNav") as! UINavigationController
        //                    let propertyVC = propertyNavVc.viewControllers[0] as! LoginViewControllerViewController
        //                    activeNav.pushViewController(propertyVC, animated: true)
        //                }
        //
        

        
        // Do any additional setup after loading the view.
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
