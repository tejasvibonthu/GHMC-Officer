//
//  ThemeViewController.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 23/09/19.
//  Copyright © 2019 IOSuser3. All rights reserved.
//

import UIKit

class ThemesVC: UIViewController {
    var gesture:UITapGestureRecognizer? = nil
    @IBOutlet var button: [UIButton]!
    
    @IBOutlet weak var backWhiteView: UIView!
    @IBOutlet weak var wholeView: UIView!
    var imageArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
       wholeView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        backWhiteView.layer.cornerRadius = 5.0
        gesture = UITapGestureRecognizer.init(target:self, action:#selector(showSomething))
        wholeView.addGestureRecognizer(gesture!)
        imageArray = ["theme_one","theme_two","theme_three","theme_four","theme_five","bg"]
        button.map { (button)  in
            button.layer.cornerRadius = button.frame.size.width/2
        }
        
        

    }
    @objc func showSomething(){
        self.dismiss(animated:true, completion:nil)
    }
    @IBAction func button_Action(_ sender:UIButton) {
        switch sender.tag {
        case 1:
            //UserDefaults.standard.removeObject(forKey:"bgImagview")
            UserDefaults.standard.set("theme_one", forKey:"bgImagview")
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: "theme"), object:"theme_one")
            self.dismiss(animated:true, completion:nil)
            break
        case 2:
            UserDefaults.standard.set("theme_two", forKey:"bgImagview")
            UserDefaults.standard.synchronize()
             NotificationCenter.default.post(name:NSNotification.Name(rawValue: "theme"), object:"theme_two")
            self.dismiss(animated:true, completion:nil)
            break
        case 3:
            UserDefaults.standard.set("theme_three", forKey:"bgImagview")
            UserDefaults.standard.synchronize()
             NotificationCenter.default.post(name:NSNotification.Name(rawValue: "theme"), object:"theme_three")
            self.dismiss(animated:true, completion:nil)
            break
        case 4:
            UserDefaults.standard.set("theme_four", forKey:"bgImagview")
            UserDefaults.standard.synchronize()
             NotificationCenter.default.post(name:NSNotification.Name(rawValue: "theme"), object:"theme_four")
            self.dismiss(animated:true, completion:nil)
            break
        case 5:
            UserDefaults.standard.set("theme_five", forKey:"bgImagview")
            UserDefaults.standard.synchronize()
             NotificationCenter.default.post(name:NSNotification.Name(rawValue: "theme"), object:"theme_five")
            self.dismiss(animated:true, completion:nil)
            break
        case 6:
            UserDefaults.standard.set("bg", forKey:"bgImagview")
            UserDefaults.standard.synchronize()
             NotificationCenter.default.post(name:NSNotification.Name(rawValue: "theme"), object:"bg")
            self.dismiss(animated:true, completion:nil)
            break
            
            
            
        default:
            break
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
