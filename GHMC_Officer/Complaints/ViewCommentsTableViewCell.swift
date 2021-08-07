//
//  ViewCommentsTableViewCell.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 20/09/19.
//  Copyright © 2019 IOSuser3. All rights reserved.
//

import UIKit
import SDWebImage

class ViewCommentsTableViewCell: UITableViewCell {
    @IBOutlet weak var imageview: UIImageView!
    
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var wholeView: UIView!
    @IBOutlet weak var remarks: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var mobileNumber: UILabel!
    @IBOutlet weak var postedBy: UILabel!
    //var array:[Comments1]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setup(array:GrievancehistoryStruct,row:Int){
        wholeView.layer.cornerRadius = 5.0
        wholeView.layer.borderColor = UIColor.black.cgColor
        wholeView.layer.borderWidth = 2.0
        
        remarks.text = array.comments?[row].cremarks ?? "-"
        timeStamp.text = array.comments?[row].ctimeStamp ?? "-"
        status.text = array.comments?[row].cstatus ?? "-"
        id.text = array.comments?[row].cdid ?? "-"
        mobileNumber.text = array.comments?[row].cmobileno ?? "-"
        postedBy.text = array.comments?[row].cuserName ?? "-"
        
        let imageString = array.comments?[row].cphoto ?? "-"
        imageview?.sd_setImage(with:URL.init(string:imageString), placeholderImage:UIImage.init(named:"noi"))
       
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
