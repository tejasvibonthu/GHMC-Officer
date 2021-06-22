//
//  HodlingDeatilsViewController.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 26/10/19.
//  Copyright © 2019 IOSuser3. All rights reserved.
//

import UIKit

class HodlingDeatilsViewController: UIViewController {

    @IBOutlet weak var fieldVisitLabel: UILabel!
    @IBOutlet weak var noticesLabel: UILabel!
    @IBOutlet weak var paymentDetailsLabel: UILabel!
    @IBOutlet weak var procedingCopyLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action:#selector(tapFunction(sender:)
            ))
        procedingCopyLabel.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    @objc func tapFunction(sender:UITapGestureRecognizer) {
       let vc = storyboards.HoardingInfo.instance.instantiateViewController(withIdentifier: "PaymentDetailsViewController")as! PaymentDetailsViewController
        self.navigationController?.pushViewController(vc, animated:true)
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
