//
//  GrievanceCategoryListCell.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 06/05/20.
//  Copyright © 2020 IOSuser3. All rights reserved.
//

import UIKit

class GrievanceCategoryListCell: UICollectionViewCell {
    @IBOutlet var displayImage: UIImageView!
    @IBOutlet var displayName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class var identifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    
    
    var model: GrievanceCategoryListViewModel? {
        didSet {
            
            
            self.displayName.text = model?.name
            self.displayImage.sd_setImage(with: URL(string: (model?.image)!), placeholderImage: UIImage(named: "sample"))
            // let id : String = (model?.id)!
            // print(id)
            
            
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        displayName.text = nil
    }
    
    

    
    
}
