//
//  PaymentDetailsTableViewCell.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 26/10/19.
//  Copyright © 2019 IOSuser3. All rights reserved.
//

import UIKit

class PaymentDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var firstLabelView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func something(){
        let border = CALayer()
        border.backgroundColor = UIColor.black.cgColor
        border.frame = CGRect(x: 0, y: firstLabelView.frame.size.height - 1, width: firstLabelView.frame.size.width, height:1)
        firstLabelView.layer.addSublayer(border)
    }
    
    

}
