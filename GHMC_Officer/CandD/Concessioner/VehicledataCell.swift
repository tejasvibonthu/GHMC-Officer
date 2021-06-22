//
//  VehicledataCell.swift
//  GHMC_Officer
//
//  Created by Haritej on 28/05/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//

import UIKit

class VehicledataCell: UITableViewCell {
    @IBOutlet weak var driverNameTf: UITextField!
    @IBOutlet weak var vehicleNoTf: UITextField!
    @IBOutlet weak var mobileNameTf: UITextField!
    @IBOutlet weak var nooftripsTf: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
