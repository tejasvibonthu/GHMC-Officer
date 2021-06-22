//
//  Storyboard.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 05/09/19.
//  Copyright © 2019 IOSuser3. All rights reserved.
//

import Foundation
import Foundation
import UIKit

enum  storyboards:String {
    case Main,HomeStoryBoard,Complaints,photoDisplay,HoardingInfo,AMOH,Concessioner
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
}
var storyboardID : String {
    return "<Storyboard Identifier>"
}
