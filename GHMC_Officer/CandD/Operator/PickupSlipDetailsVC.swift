//
//  PickupSlipDetailsVC.swift
//  GHMC_Officer
//
//  Created by Haritej on 27/06/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//

import UIKit

class PickupSlipDetailsVC: UIViewController {
    @IBOutlet var bg: UIView!
    @IBOutlet weak var vehicleNumLb: UILabel!
    @IBOutlet weak var slipNoLb: UILabel!
    @IBOutlet weak var zoneLb: UILabel!
    @IBOutlet weak var circleLb: UILabel!
    @IBOutlet weak var wardLb: UILabel!
    @IBOutlet weak var localityLb: UILabel!
    @IBOutlet weak var driverNameLb: UILabel!
    @IBOutlet weak var wastetypeLb: UILabel!
    @IBOutlet weak var grosswtTF: UITextField!
    @IBOutlet weak var tarewtTF: UITextField!
    @IBOutlet weak var netwtLb: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func submitClick(_ sender: Any) {
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
