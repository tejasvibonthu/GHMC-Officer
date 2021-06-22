//
//  CheckStatusCell.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 15/05/20.
//  Copyright © 2020 IOSuser3. All rights reserved.
//

import UIKit

class CheckStatusCell: UITableViewCell {

    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var subcategoryNameLabel: UILabel!
    @IBOutlet weak var assignedToLlabel: UILabel!
    @IBOutlet weak var complanitID: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var mainVIew: UIView!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var trackerView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        mainVIew.layer.cornerRadius = 5.0
        mainVIew.layer.borderColor = UIColor.white.cgColor
        mainVIew.layer.borderWidth = 1.0
        mainVIew.clipsToBounds = true
        let allviews = [view1,view2,view3,view4,view5]
        for view in allviews
        {
            view?.layer.cornerRadius = view!.frame.width/2
            view?.layer.borderWidth = 2.0
            view?.layer.borderColor = UIColor.black.cgColor
            
        }
        
        
    }
    func fillColor(view : UIView , with Color : UIColor)
    {
        let allviews = [view1,view2,view3,view4,view5]
        allviews.forEach { (v) in
            if v == view
            {
                v?.backgroundColor = Color
            }
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
