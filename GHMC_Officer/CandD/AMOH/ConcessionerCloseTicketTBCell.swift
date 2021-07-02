//
//  ConcessionerCloseTicketTBCell.swift
//  GHMC_Officer
//
//  Created by deep chandan on 29/06/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//

import UIKit

class ConcessionerCloseTicketTBCell: UITableViewCell {
    @IBOutlet weak var lb_mobileNo: UILabel!
    @IBOutlet weak var lb_tripno: UILabel!
    @IBOutlet weak var lb_vehicleno: UILabel!
    @IBOutlet weak var lb_drivername: UILabel!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
