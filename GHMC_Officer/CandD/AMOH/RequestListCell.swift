//
//  RequestListCell.swift
//  GHMC_Officer
//
//  Created by deep chandan on 09/04/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//

import UIKit

class RequestListCell: UITableViewCell {
    @IBOutlet weak var ticketIdLb: UILabel!
    @IBOutlet weak var locationLB: UILabel!
    @IBOutlet weak var dateLb: UILabel!
    @IBOutlet weak var estimatedwasteLb: UILabel!
    @IBOutlet weak var imageIs: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
