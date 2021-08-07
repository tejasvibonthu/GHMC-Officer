//
//  ScreenshotVC.swift
//  GHMC_Officer
//
//  Created by deep chandan on 28/07/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//

import UIKit
protocol TimeStampProtocol : class {
    func imgDelegate(img:UIImage,imgView : UIImageView)
}
class ScreenshotVC: UIViewController {
    @IBOutlet weak var lb_time: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var capturedImg: UIImageView!
    var imgstring:UIImage?
    var delegate : TimeStampProtocol?
    var imgView :UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        capturedImg.image = imgstring
        lb_time.isUserInteractionEnabled = false
        lb_time.text = getTimestamp()
    }
    
    @IBAction func btn_conformphotoClick(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RequestEstimationVC") as! RequestEstimationVC
        capturedImg.image  = mainView.takeScreenshot()
        vc.imageWithTimestamp = capturedImg.image
        delegate?.imgDelegate(img: mainView.takeScreenshot() ,imgView: imgView!)
       // print(mainView.takeScreenshot())
        self.navigationController?.popViewController(animated: true)
    }
    func getTimestamp() -> String{
            let now = Date()
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
            let dateString = formatter.string(from: now)
            return dateString
    }
 }
extension UIView {
    func takeScreenshot() -> UIImage {
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
}
