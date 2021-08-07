//
//  UserDetailsViewController.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 11/09/19.
//  Copyright © 2019 IOSuser3. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD

// MARK: - UsersListStruct
struct userDeatilsStruct: Codable {
    let status, empName, designation, emplevel: String?
    let ward, wing: String?
    let dashboard: [Dashboard]?

    enum CodingKeys: String, CodingKey {
        case status
        case empName = "emp_name"
        case designation, emplevel, ward, wing, dashboard
    }
    
    // MARK: - Dashboard
    struct Dashboard: Codable {
        var typeID, typeName, gcount: String?

        enum CodingKeys: String, CodingKey {
            case typeID = "type_id"
            case typeName = "type_name"
            case gcount
        }
    }

}

class UserdetailsVC: UIViewController {
   // var detailsDict:Parameters? = nil
    var mode:String?
    var modeId:String?
    var params:Parameters?
    var grievanceType:String?
    @IBOutlet weak var sourceLb: UILabel!
    @IBOutlet weak var BgimagevIew: UIImageView!
    @IBOutlet weak var wingNameLabel: UILabel!
    @IBOutlet weak var employeeLevelLabel: UILabel!
    @IBOutlet weak var designationLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var employeeName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var designationLevel: UILabel!
    @IBOutlet weak var employeeLevel: UILabel!
    @IBOutlet weak var wholeView: UIView!
    @IBOutlet weak var wingName: UILabel!
    @IBOutlet weak var wholeViewConstarint: NSLayoutConstraint!
    var userDetailsmodel:userDeatilsStruct?
    var source:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UserDefaults.standard.value(forKey:"bgImagview") as! String
        BgimagevIew.image = UIImage.init(named:image)
        sourceLb.text = source
        userDetailsWS()
        // Do any additional setup after loading the view.
         self.navigationController?.navigationBar.isHidden = true
    }
        @IBAction func backButtob_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated:true)
    }
//    @IBAction func menuAction(_ sender: Any) {
//        if self.revealViewController() != nil {
//            self.revealViewController().rearViewRevealWidth = 0.88 * UIScreen.main.bounds.size.width
//            self.revealViewController().panGestureRecognizer().isEnabled = true
//            self.revealViewController().tapGestureRecognizer()
//            revealViewController().revealToggle(sender)
//        } else {
//            let objReavealController = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
//            objReavealController.panGestureRecognizer().isEnabled = true
//            objReavealController.tapGestureRecognizer()
//            objReavealController.revealToggle(sender)
//        }
//    }
    func userDetailsWS()  {
                self.params = ["mode":UserDefaultVars.modeID,
                             "userid":userid,
                             "password":password,
                             "uid":UserDefaultVars.empId,
                             "type_id":UserDefaultVars.typeId,
                             "slftype":UserDefaultVars.grievanceType]
      
              print(id.self)
              print(params)
  
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
            NetworkRequest.makeRequest(type: userDeatilsStruct.self, urlRequest: Router.userDetails(params: params ?? [:])) { [weak self](result) in
            switch result
            {
            case .success(let getList):
                print(getList)
                self?.userDetailsmodel = getList
                if getList.status == "true"{
                    if getList.dashboard?.isEmpty == true {
                        self?.showAlert(message: "No Records found")
                    } else {
                        DispatchQueue.main.async {
                            self?.employeeName.text = getList.empName
                            self?.employeeLevel.text = getList.emplevel
                            self?.wingName.text = getList.wing
                            self?.designationLabel.text = getList.designation
                            self?.tableView.reloadData()
                        }
                    }
                } else {
                    self?.showAlert(message: getList.status ?? ""){
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
                
            case .failure(let err):
                print(err)
                DispatchQueue.main.async {
                    //  self?.showAlert(message: serverNotResponding)
                    self?.showAlert(message: serverNotResponding){
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
            }
            
    }
}
    

extension UserdetailsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userDetailsmodel?.dashboard != nil {
            return   userDetailsmodel?.dashboard?.count ?? 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = userDetailsmodel?.dashboard?[indexPath.row]
        if UserDefaultVars.designation == "AMOH"{
           if id?.typeID == "34-2"{
                let vc = storyboards.AMOH.instance.instantiateViewController(withIdentifier:"AMOHDashoboardVC") as! AMOHDashoboardVC
            self.navigationController?.pushViewController(vc, animated:true)
            }
           else{
               let vc = storyboards.Complaints.instance.instantiateViewController(withIdentifier:"FullGrievancedetailsVC") as! FullGrievancedetailsVC
               vc.compTypeId = id?.typeID
               self.navigationController?.pushViewController(vc, animated:true)
           }
        } else{
            let vc = storyboards.Complaints.instance.instantiateViewController(withIdentifier:"FullGrievancedetailsVC") as! FullGrievancedetailsVC
            vc.compTypeId = id?.typeID
            self.navigationController?.pushViewController(vc, animated:true)
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier:"UserDetailsTableViewCell") as! UserDetailsTableViewCell
        cell.wholeView.layer.cornerRadius = 5.0
        cell.wholeView.layer.borderWidth = 1.0
        cell.wholeView.layer.borderColor = UIColor.black.cgColor
        cell.nameLabel.text = userDetailsmodel?.dashboard?[indexPath.row].typeName
        cell.countLabel.text = userDetailsmodel?.dashboard?[indexPath.row].gcount
        cell.selectionStyle = .none
        return cell
    }
    
}
    


