//
//  TripsCell.swift
//  GHMC_Officer
//
//  Created by Haritej on 27/06/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//

import UIKit

class TripsCell: UITableViewCell {
    @IBOutlet weak var vehicleNumLb: UILabel!
    @IBOutlet weak var typeofVehicleLb: UILabel!
    @IBOutlet weak var driverNameLb: UILabel!
    @IBOutlet weak var mobileNumberLb: UILabel!
    @IBOutlet weak var supervisorNameLb: UILabel!
    @IBOutlet weak var supervisorNoLB: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
