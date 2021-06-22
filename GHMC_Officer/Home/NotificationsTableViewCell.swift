//
//  NotificationsTableViewCell.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 21/09/19.
//  Copyright © 2019 IOSuser3. All rights reserved.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {

    @IBOutlet weak var testingArea: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var wholeView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setUp(row:Int,model:[notifications]){
        //wholeView.layer.borderWidth = 1.0
       // wholeView.layer.borderColor = UIColor.yellow.cgColor
        titleLabel.text = model[row].title
        testingArea.text = model[row].msg
        timeStamp.text = model[row].timestamp
        
        
    }
    
    func addBottomBorder(with color: UIColor?, andWidth borderWidth: CGFloat)->UIView {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: borderWidth)
        return border
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
