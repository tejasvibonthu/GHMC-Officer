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
       // self.revealViewController().rearViewRevealWidth = 250 //put the width you need

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
        if indexPath.section == 0{
            switch indexPath.row {
            case 0:
                let propertyNavVc = storyboards.HomeStoryBoard.instance.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
                let navController = UINavigationController(rootViewController: propertyNavVc)
                sideMenuController?.setContentViewController(to: navController, animated: true, completion: nil)
                break
            default:
                print("")
            }
        }
        if indexPath.section == 1{
            switch indexPath.row {
            case 0: // Grievances
                let vc = storyboards.HomeStoryBoard.instance.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                let homeVC = UINavigationController(rootViewController: vc)
                sideMenuController?.setContentViewController(to: homeVC, animated: true, completion: nil)
                break
            case 1: // abstract report
                let Vc = storyboards.Complaints.instance.instantiateViewController(withIdentifier: "AbstarctVC") as! AbstarctVC
                let abstractVC = UINavigationController(rootViewController: Vc)
                sideMenuController?.setContentViewController(to: abstractVC, animated: true, completion: nil)
                break
            default:
                print("")
            }
        }
        
        if indexPath.section == 2{
            switch indexPath.row {
            case 0: //themes
                let vc = storyboards.HomeStoryBoard.instance.instantiateViewController(withIdentifier: "ThemesVC") as! ThemesVC
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            case 1: // exit
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
                let vc = storyboards.Main.instance.instantiateViewController(withIdentifier: "LoginViewControllerViewController") as! LoginViewControllerViewController
                UserDefaults.standard.removeObject(forKey:"mpin")
                UserDefaults.standard.synchronize()
                let navVc = UINavigationController(rootViewController: vc)
                self.view.window?.rootViewController = navVc
                self.view.window?.makeKeyAndVisible()
       
            default:
                print("")
            }
        }
        self.sideMenuController?.hideMenu()
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x:0, y:0, width:tableView.frame.size.width, height:40))
       //  let view1 = UIView(frame: CGRect(x:0, y:0, width:tableView.frame.size.width-10, height:50))
        let label = UILabel(frame: view.frame)
        label.text = sectionTitles?[section]
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize:16 , weight: .semibold)
        view.addSubview(label)
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemGray6
        } else {
            // Fallback on earlier versions
            view.backgroundColor = .lightGray
        }
       //  view.addSubview(view1)
        return view
        }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
