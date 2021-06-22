//
//  ConcessionerTicketscell.swift
//  GHMC_Officer
//
//  Created by Haritej on 24/05/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//
import UIKit
class ConcessionerTicketscell: UITableViewCell {
    @IBOutlet weak var ticketIdLb: UILabel!
    @IBOutlet weak var locationLb: UILabel!
    @IBOutlet weak var dateLB: UILabel!
    @IBOutlet weak var estimatedWtLB: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

