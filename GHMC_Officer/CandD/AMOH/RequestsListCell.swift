//
//  ConcessionerRejectCell.swift
//  GHMC_Officer
//
//  Created by deep chandan on 24/06/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//

import UIKit

class RequestsListCell: UITableViewCell {
    @IBOutlet weak var ticketIdLb: UILabel!
    @IBOutlet weak var locationLb: UILabel!
    @IBOutlet weak var dateLb: UILabel!
    @IBOutlet weak var estimatedwasteLb: UILabel!
    @IBOutlet weak var satusLb:UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
