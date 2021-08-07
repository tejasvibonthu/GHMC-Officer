//
//  OperatorHomeVC.swift
//  GHMC_Officer
//
//  Created by deep chandan on 22/07/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//

import UIKit

class OperatorHomeVC: UIViewController {
    @IBOutlet weak var lb_name: UILabel!
    @IBOutlet weak var lb_designation: UILabel!
    @IBOutlet weak var lb_mobileno: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lb_name.text = UserDefaultVars.empName
        self.lb_designation.text = UserDefaultVars.designation
        self.lb_mobileno.text = UserDefaultVars.mobileNumber
    }
    
    @IBAction func btn_tripsatPlantClick(_ sender: Any) {
        
            let vc = storyboards.Operator.instance.instantiateViewController(withIdentifier:"TripsatPlantVC") as! TripsatPlantVC
            self.navigationController?.pushViewController(vc, animated:true)
    }
    
    @IBAction func btn_logoutClick(_ sender: Any) {
        let vc = storyboards.Main.instance.instantiateViewController(withIdentifier: "LoginViewControllerViewController") as! LoginViewControllerViewController
        UserDefaults.standard.removeObject(forKey:"mpin")
        UserDefaults.standard.synchronize()
        let navVc = UINavigationController(rootViewController: vc)
        self.view.window?.rootViewController = navVc
        self.view.window?.makeKeyAndVisible()
    }
 

}
