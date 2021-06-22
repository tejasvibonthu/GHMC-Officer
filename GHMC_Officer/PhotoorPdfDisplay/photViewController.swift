//
//  photViewController.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 19/09/19.
//  Copyright © 2019 IOSuser3. All rights reserved.
//

import UIKit
import SDWebImage
class photViewController: UIViewController {
    var imageString:String?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var wholeView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        wholeView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
       let tap = UITapGestureRecognizer.init(target:self, action:#selector(displayPhoto))
        wholeView.addGestureRecognizer(tap)
         do {
            try  imageView.sd_setImage(with: URL(string:imageString!), placeholderImage: UIImage(named: "load"))
        } catch  {
            showAlert(message: "Photo format is wrong")
        }
    }
   @objc func displayPhoto(){
    self.dismiss(animated:true, completion:nil)
    }
}
