//
//  Extensions.swift
//  GHMC_Officer
//
//  Created by deep chandan on 31/03/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController{
func showCustomAlert(message : String ,okCompletion : (()->())? = nil)
{
    var dialogMessage = UIAlertController(title: "GHMC", message: message, preferredStyle: .alert)
    
    // Create OK button with action handler
    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
       // print("Ok button tapped")
        okCompletion?()
     })
    
    //Add OK button to a dialog message
    dialogMessage.addAction(ok)
    // Present Alert to
    self.present(dialogMessage, animated: true, completion: nil)
//    DispatchQueue.main.async {
//        let appearance = SCLAlertView.SCLAppearance(
//            kTitleFont: UIFont(name: "HelveticaNeue-Bold", size: 20)!,
//            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
//            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
//            showCloseButton: false
//        )
//        let alert = SCLAlertView(appearance: appearance)
//
//        alert.addButton("OK") {
//            // print("ok button tapped")
//            okCompletion?()
//        }
//        alert.showSuccess("Virtuo", subTitle: message)
//    }
    
}
}
