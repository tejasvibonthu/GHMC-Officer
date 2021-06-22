//
//  AbstarctTableViewCell.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 20/09/19.
//  Copyright © 2019 IOSuser3. All rights reserved.
//

import UIKit
class AbstarctTableViewCell: UITableViewCell {

    @IBOutlet weak var wholeView: UIView!
    @IBOutlet weak var uiimagev: UIImageView!
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setup(array:Array<String>,row:Int,colourArray:Array<String>,model:abstractRport){
        wholeView.layer.cornerRadius = 2.0
        
       let nameArray = ["Grievances Registered","Grievances Redressed","Grievances Under Process","Grievances Pending","Grievances Non GHMC","Grievances Fund Related"]
        //let mirror = Mirror.init(reflecting:model)
        var array1 = [String]()
        array1.append(model.TOTAL_RECEIVED ?? "")
        array1.append(model.TOTAL_CLOSED ?? "")
        array1.append(model.TOTAL_UNDER_PROCESS ?? "")
        array1.append(model.TOTAL_PENDING ?? "")
        array1.append(model.TOTAL_NON_GHMC ?? "")
        array1.append(model.TOTAL_FUND_RELATED ?? "")
        countLabel.text = array1[row]
        nameLabel.text = nameArray[row]
        
       
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
