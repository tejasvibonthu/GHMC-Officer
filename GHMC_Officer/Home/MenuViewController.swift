//
//  MenuViewController.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 07/09/19.
//  Copyright © 2019 IOSuser3. All rights reserved.
//

import UIKit
import SCLAlertView

class MenuViewController: UIViewController {
    var sectionTitles : [String]?
    
    @IBOutlet weak var bgimagev: UIImageView!
    var logoImages1:[String]?
    var rowTitles = [[String]]()
    var logoImages = [[String]]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
      self.navigationController?.navigationBar.isHidden = true
        self.revealViewController().rearViewRevealWidth = 250 //put the width you need

      sectionTitles = ["profile","services","others"]
      rowTitles = [["Inbox"],["Grivevance","Absract Report"],["Themes","Exit","logout"]]
      logoImages = [["notification_new_icon"],["grievance","grievance"],["theme","logout","logout"]]
        let image = UserDefaults.standard.value(forKey:"bgImagview") as! String
        bgimagev.image = UIImage.init(named:image)
      NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("theme"), object: nil)
    }
    @objc func methodOfReceivedNotification(notification: Notification) {
        let theme = notification.object as! String
        bgimagev.image = UIImage.init(named:theme)
    }
}
extension MenuViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int //
    {
        if sectionTitles != nil {
            return sectionTitles!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            return 2
        }else if section == 2{
            return 3
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell=tableView.dequeueReusableCell(withIdentifier:"HomeTableViewCell") as! HomeTableViewCell
        if indexPath.section == 0 {
            cell.menuLabel.text  =   rowTitles[indexPath.section][indexPath.row]
            let image = logoImages[indexPath.section][indexPath.row]
            cell.logoImagev.image = UIImage.init(named:image)
            cell.selectionStyle = .none
        }else if indexPath.section == 1{
             cell.menuLabel.text  =   rowTitles[indexPath.section][indexPath.row]
             let image = logoImages[indexPath.section][indexPath.row]
             cell.logoImagev.image = UIImage.init(named:image)
            cell.selectionStyle = .none
        }
        else if indexPath.section == 2{
             cell.menuLabel.text  =   rowTitles[indexPath.section][indexPath.row]
             let image = logoImages[indexPath.section][indexPath.row]
             cell.logoImagev.image = UIImage.init(named:image)
            cell.selectionStyle = .none
        }

       
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.revealViewController().revealToggle(self)
        self.revealViewController().panGestureRecognizer().isEnabled = true
        if indexPath.section == 0{
            switch indexPath.row {
            
            case 0: // track file
                let activeNav = self.revealViewController().frontViewController as! UINavigationController
                let propertyNavVc = storyboards.HomeStoryBoard.instance.instantiateViewController(withIdentifier: "NotificationsViewControllerNav") as! UINavigationController
                let propertyVC = propertyNavVc.viewControllers[0] as! NotificationsVC
                activeNav.pushViewController(propertyVC, animated: true)
                break
            default:
                print("tutiu")
            }
        }
        if indexPath.section == 1{
            switch indexPath.row {
            case 0: // Revoke File
                let activeNav = self.revealViewController().frontViewController as! UINavigationController
                let propertyNavVc = storyboards.HomeStoryBoard.instance.instantiateViewController(withIdentifier: "HomeViewControllerNav") as! UINavigationController
                let propertyVC = propertyNavVc.viewControllers[0] as! HomeViewController
                activeNav.pushViewController(propertyVC, animated: true)
                break
            case 1: // Revoke File
                let activeNav = self.revealViewController().frontViewController as! UINavigationController
                let propertyNavVc = storyboards.Complaints.instance.instantiateViewController(withIdentifier: "AbstarctViewControllerNav") as! UINavigationController
                let propertyVC = propertyNavVc.viewControllers[0] as! AbstarctVC
                activeNav.pushViewController(propertyVC, animated: true)
                break
//            case 2: // Revoke File
//                let reqNav = self.revealViewController().frontViewController as! UINavigationController
//                let propertyNavVc = storyboards.AMOH.instance.instantiateViewController(withIdentifier: "AmohRequestControllerNav") as! UINavigationController
//                let propertyVC = propertyNavVc.viewControllers[0] as! RequestListVC
//                reqNav.pushViewController(propertyVC, animated: true)
//                break
                
            default:
                print("wgfewsh")
            }
        }
        
        if indexPath.section == 2{
            
            switch indexPath.row {
            case 0: //themes
                let activeNav = self.revealViewController().frontViewController as! UINavigationController
                let propertyNavVc = storyboards.HomeStoryBoard.instance.instantiateViewController(withIdentifier: "ThemeViewControllerNav") as! UINavigationController
                
                propertyNavVc.modalTransitionStyle = .crossDissolve
                propertyNavVc.modalPresentationStyle = .overCurrentContext
                activeNav.present(propertyNavVc, animated:true, completion:nil)
                
            case 1: // exit
                
                //          UserDefaults.standard.removeObject(forKey:"mpin")
                //            UserDefaults.standard.removeObject(forKey:"DESIGNATION")
                //            UserDefaults.standard.removeObject(forKey:"EMP_NAME")
                //            UserDefaults.standard.removeObject(forKey:"TYPE_ID")
                //            UserDefaults.standard.removeObject(forKey:"MOBILE_NO")
                //            UserDefaults.standard.removeObject(forKey:"otp")
                //            UserDefaults.standard.synchronize()
                
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false
                )
                let alertView = SCLAlertView(appearance: appearance)
                alertView.addButton("Yes"){
                    DispatchQueue.main.async {
                        exit(0);
                    }
                }
                alertView.addButton("cancel") {
                }
                alertView.showInfo("GHMC", subTitle:"Do you want to exit from app?")
                break
            case 2: //logout
//                let activeNav = self.revealViewController().frontViewController as! UINavigationController
                let vc = storyboards.Main.instance.instantiateViewController(withIdentifier: "LoginViewControllerViewController") as! LoginViewControllerViewController
                UserDefaults.standard.removeObject(forKey:"mpin")
                UserDefaults.standard.synchronize()
                let navVc = UINavigationController(rootViewController: vc)
                self.view.window?.rootViewController = navVc
                self.view.window?.makeKeyAndVisible()
                
                
//
//                let loginVC = vc.viewControllers[0] as! LoginViewControllerViewController
//                activeNav.pushViewController(loginVC, animated: true)
            default:
                print("dghae")
            }
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x:0, y:0, width:tableView.frame.size.width-10, height:20))
       //  let view1 = UIView(frame: CGRect(x:0, y:0, width:tableView.frame.size.width-10, height:50))
        let label = UILabel(frame: CGRect(x:10, y:0, width:tableView.frame.size.width-10, height:30))
        label.text = sectionTitles![section]
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize:14)
        view.addSubview(label)
       //  view.addSubview(view1)
        return view
        }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles![section]
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]?{
         if let array = sectionTitles {
            return array
         }else{
           return [" "]
        }
        
    }
}
