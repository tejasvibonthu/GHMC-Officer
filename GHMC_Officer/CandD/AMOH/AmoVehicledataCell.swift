//
//  AmoVehicledataCell.swift
//  GHMC_Officer
//
//  Created by deep chandan on 07/08/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//

import UIKit

class AmoVehicledataCell: UITableViewCell {
    @IBOutlet weak var lb_noofvehicles: UILabel!
    @IBOutlet weak var lb_amount: UILabel!
    @IBOutlet weak var lb_vehicleType: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
