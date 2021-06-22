//
//  GrivenceHistoryTableViewCell.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 13/09/19.
//  Copyright © 2019 IOSuser3. All rights reserved.
//

import UIKit

class GrivenceHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var image2: UIImageView!
    
    var rowNo:Int?
    var delegate1:imageTapped?
    
    @IBOutlet weak var nomstopHeight: NSLayoutConstraint!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var imgae1: UIImageView!
    
    @IBOutlet weak var nmosHeight: NSLayoutConstraint!
    @IBOutlet weak var wholeView: UIView!
    @IBOutlet weak var remarks: UILabel!
    @IBOutlet weak var landMark: UILabel!
    @IBOutlet weak var postedBy: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var mobileNumber: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var nmosStackView: UIStackView!
    @IBOutlet weak var callButton: UIButton!
    
    @IBOutlet weak var nmosLandmark: UILabel!
    @IBOutlet weak var ward: UILabel!
    @IBOutlet weak var circle: UILabel!
    @IBOutlet weak var tradeName: UILabel!
    var  modeId:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       //  modeId = UserDefaults.standard.value(forKey:"MODEID") as? String
        modeId = "15"
        if(modeId == "15"){
            self.nmosStackView.isHidden = false

        } else {
        self.nmosStackView.isHidden = true
        }
    }
    @objc func imageTapping1(){
        guard  let delegate = delegate1 else {
            return
        }
        delegate.image1TappingAction(string:rowNo)
    }
    @objc func imageTapping2(){
        guard  let delegate = delegate1 else {
            return
        }
        delegate.image2TappingAction(string:rowNo)
    }
    @objc func imageTapping3(){
        guard  let delegate = delegate1 else {
            return
        }
        delegate.image3TappingAction(string:rowNo)
    }
    func setup(indexpath:IndexPath){
        rowNo = indexpath.row
        let gesture1 = UITapGestureRecognizer.init(target:self , action:#selector(imageTapping1))
        imgae1.addGestureRecognizer(gesture1)
        imgae1.isUserInteractionEnabled = true
        
        let gesture2 = UITapGestureRecognizer.init(target:self , action:#selector(imageTapping2))
        image2.addGestureRecognizer(gesture2)
        image2.isUserInteractionEnabled = true
        
        let gesture3 = UITapGestureRecognizer.init(target:self , action:#selector(imageTapping3))
        image3.addGestureRecognizer(gesture3)
        image3.isUserInteractionEnabled = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
