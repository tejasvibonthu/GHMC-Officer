//
//  NotificationsViewController.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 21/09/19.
//  Copyright © 2019 IOSuser3. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD

class NotificationsVC: UIViewController {
    var notificationModel:[notifications]?

    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        tableview.rowHeight = UITableView.automaticDimension
//        navigationBarView.layer.addSublayer(addBorderBottom(y:navigationBarView.frame.size.height-1, width:navigationBarView.frame.size.width, colour:UIColor.black, height1:2.0))
        tableview.separatorStyle = .none
        
        if Reachability.isConnectedToNetwork(){
            self.notificationWS()
        }else{
            showAlert(message: noInternet)
    }
    }
    func notificationWS(){
    let dict :Parameters  = ["userid":userid,
    "password":password,
    "type_id":UserDefaults.standard.value(forKey:"TYPE_ID") ?? " ",
    "mobileno":UserDefaults.standard.value(forKey:"MOBILE_NO") ?? "",
    ]
    DispatchQueue.main.async {
    self.loading(text:progressMsgWhenLOginClicked)
    PKHUD.sharedHUD.show()
    }
    Alamofire.request(Router.showNotifications(params:dict)).responseJSON {response in
    
  //  print(response)
    
    DispatchQueue.main.async {
    PKHUD.sharedHUD.hide()
    }
    switch response.result{
    case .success:
    do{
    let decoder = JSONDecoder()
    self.notificationModel = try decoder.decode([notifications].self, from: response.data!)
    DispatchQueue.main.async {
        if self.notificationModel?.count != 0{
    if self.notificationModel?[0].status == "success"{
    self.tableview.reloadData()
        }else{
           self.showAlert(message:failedupdate)
        }
        
        }else{
            self.showAlert(message:"No Records Found")
        }
        }
    }
   
 
    catch {
    print(error.localizedDescription)
    }
    break
    case .failure(_): break
   
    
    
    }
        }
    }
    
   
    @IBAction func back_ButtonAction(_ sender: Any) {
        let vc = storyboards.HomeStoryBoard.instance.instantiateViewController(withIdentifier:"HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(vc, animated:true)
     //   self.navigationController?.popViewController(animated:true)
    }
//    func addBorderBottom(y:CGFloat,width:CGFloat,colour:UIColor,height1:CGFloat)->CALayer{
//        let bottomBorder = CALayer()
//        bottomBorder.frame = CGRect(x: 0.0, y:y, width:width, height: height1)
//        bottomBorder.backgroundColor = colour.cgColor
//        return bottomBorder
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension NotificationsVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int //
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.notificationModel != nil{
            return self.notificationModel!.count
        }
      return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let vc = storyboards.Complaints.instance.instantiateViewController(withIdentifier:"GrievanceHistoryViewController") as! GrievanceHistoryViewController
        //        vc.compliant_id = model?.grievance?[indexPath.row].id!
        //        self.navigationController?.pushViewController(vc, animated:true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier:"NotificationsTableViewCell") as! NotificationsTableViewCell
        cell.selectionStyle = .none
        
           cell.wholeView.layer.masksToBounds = true
      //  cell.wholeView.layer.addSublayer(addBorderBottom(y:cell.wholeView.frame.size.height-1, width:cell.wholeView.frame.size.width, colour:UIColor.lightGray, height1:1.0))
        cell.setUp(row:indexPath.row, model:notificationModel!)
        
        
        return cell
    }
    
    
    
}

struct notifications:Codable{
    
    let sno:String?
    let title:String?
    let msg:String?
    let isimage:String?
    let imageurl:String?
    let status:String?
    let timestamp:String?
   
}
