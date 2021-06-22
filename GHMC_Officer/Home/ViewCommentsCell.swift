//
//  ViewCommentsCell.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 21/05/20.
//  Copyright © 2020 IOSuser3. All rights reserved.
//

import UIKit
//protocol imageTappedOne2{
//    func image1TappingAction22(string:Int?)
//
//}

class ViewCommentsCell: UITableViewCell {

   @IBOutlet var mainView: UIView!
        @IBOutlet var postedBY: UILabel!
        @IBOutlet var mobileNo: UILabel!
        @IBOutlet var complaintID: UILabel!
        @IBOutlet var remarks: UILabel!
        @IBOutlet var status: UILabel!
        @IBOutlet var timeStamp: UILabel!
        @IBOutlet weak var img: UIImageView!
        //var delegate22:imageTappedOne2?
        var rowNo:Int?

       
        override func awakeFromNib() {
            super.awakeFromNib()
    //        let gesture = UITapGestureRecognizer.init(target:self , action:#selector(some))
    //        image2.addGestureRecognizer(gesture)
            // Initialization code
        }
//   @objc func imageTapping1(){
//        guard  let delegate = delegate22 else {
//         return
//        }
//        delegate.image1TappingAction22(string:rowNo)
//        }
        
//        func setup(indexpath:IndexPath){
//            rowNo = indexpath.row
//            let gesture1 = UITapGestureRecognizer.init(target:self , action:#selector(imageTapping1))
//            img.addGestureRecognizer(gesture1)
//            img.isUserInteractionEnabled = true
//
//
//        }
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            
            // Configure the view for the selected state
        }

    }
