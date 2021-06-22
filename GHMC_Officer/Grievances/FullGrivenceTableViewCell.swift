//
//  FullGrivenceTableViewCell.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 13/09/19.
//  Copyright © 2019 IOSuser3. All rights reserved.
//

import UIKit
protocol imageTapped {
    func image1TappingAction(string:Int?)
     func image2TappingAction(string:Int?)
     func image3TappingAction(string:Int?)
}

class FullGrivenceTableViewCell: UITableViewCell {
    @IBOutlet weak var image2: UIImageView!
    
    @IBOutlet weak var wholeView: UIView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var imgae1: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    var rowNo:Int?
    var delegate1:imageTapped?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        let gesture = UITapGestureRecognizer.init(target:self , action:#selector(some))
//        image2.addGestureRecognizer(gesture)
        // Initialization code
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
