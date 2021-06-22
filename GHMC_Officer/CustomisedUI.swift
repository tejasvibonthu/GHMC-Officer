//
//  CustomisedUI.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 27/04/20.
//  Copyright © 2020 IOSuser3. All rights reserved.
//

import Foundation

@IBDesignable


class cornerView : UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 0.5
        
        
    }
    
}

class cornerbtn : UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 0.5
        
        
    }
    
}
