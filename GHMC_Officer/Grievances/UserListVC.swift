//
//  UserListViewController.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 09/09/19.
//  Copyright © 2019 IOSuser3. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD
import SDWebImage
class UserListVC: UIViewController {
    @IBOutlet weak var bgImagev1: UIImageView!
    @IBOutlet weak var bgimageV: UIImageView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var userMobileNumber: UILabel!
    @IBOutlet weak var designationLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    var grievanceType:String?
    var userListmodel:UsersListStruct?
    var dict:Parameters?
    var uid:String?
    var type_Id:String?
   
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
      //  print("slfType\(self.slfType ?? "")")
         NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("theme"), object: nil)
        //tableview.estimatedRowHeight = 100
        let image = UserDefaults.standard.value(forKey:"bgImagview") as! String
        bgImagev1.image = UIImage.init(named:image)
        bgimageV.image = UIImage.init(named:image)
        tableview.rowHeight = UITableView.automaticDimension
        userNameLabel.text = UserDefaultVars.empName
        designationLabel.text = UserDefaultVars.designation
        userMobileNumber.text = UserDefaultVars.mobileNumber
        UserDefaults.standard.set(grievanceType, forKey:"grievanceType")
        UserDefaultVars.grievanceType = grievanceType ?? ""
        self.UsersListWS()
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool){
        searchBar.placeholder = "Search by complaint id"
        searchBar.text = ""
        
    }
    @objc func methodOfReceivedNotification(notification: Notification) {
        let theme = notification.object as! String
        bgImagev1.image = UIImage.init(named:theme)
        bgimageV.image = UIImage.init(named:theme)
    }
    override func viewWillAppear(_ animated: Bool) {
         NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("theme"), object: nil)
    }
    
    @IBAction func menuAction(_ sender: Any) {
        
        if self.revealViewController() != nil {
            self.revealViewController().rearViewRevealWidth = 0.88 * UIScreen.main.bounds.size.width
            self.revealViewController().panGestureRecognizer().isEnabled = true
            self.revealViewController().tapGestureRecognizer()
            revealViewController().revealToggle(sender)
            
        } else {
            
            let objReavealController = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            objReavealController.panGestureRecognizer().isEnabled = true
            objReavealController.tapGestureRecognizer()
            objReavealController.revealToggle(sender)
        }
        
    }
    func UsersListWS(){
        let params = ["userid":userid,
                      "password":password,
                      "uid":UserDefaultVars.empId,
                      "type_id":UserDefaultVars.typeId,
                      "slftype":UserDefaultVars.grievanceType]
        //  print(dict)
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
        NetworkRequest.makeRequest(type: UsersListStruct.self, urlRequest: Router.userList(params: params)) { [weak self](result) in
            switch result
            {
            case .success(let getList):
                //  print(getCounts)
                self?.userListmodel = getList
                if getList.status == "true"{
                    if getList.row?.isEmpty == true {
                        self?.showAlert(message: "No Records found")
                    } else {
                        DispatchQueue.main.async {
                            self?.tableview.reloadData()
                        }
                    }
                } else {
                    self?.showCustomAlert(message: getList.status ?? ""){
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
                
            case .failure(let err):
                print(err)
                DispatchQueue.main.async {
                    //  self?.showAlert(message: serverNotResponding)
                    self?.showCustomAlert(message: serverNotResponding){
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
        
    }
  
}
// MARK: - UsersListStruct
struct UsersListStruct: Codable {
    let status: String?
    let tag: JSONNull?
    let row: [Row]?

    enum CodingKeys: String, CodingKey {
        case status, tag
        case row = "ROW"
    }
    // MARK: - Row
    struct Row: Codable {
        let roworder, modeID, mcount, cName: String?
        let iURL: String?
        let order, empid: String?

        enum CodingKeys: String, CodingKey {
            case roworder = "ROWORDER"
            case modeID = "MODE_ID"
            case mcount = "MCOUNT"
            case cName = "C_NAME"
            case iURL = "I_URL"
            case order = "ORDER"
            case empid = "EMPID"
        }
    }
    // MARK: - Encode/decode helpers

    class JSONNull: Codable, Hashable {

        public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
        }

        public var hashValue: Int {
            return 0
        }

        public init() {}

        public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }
}





extension UserListVC:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText \(searchText)")
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let vc = storyboards.Complaints.instance.instantiateViewController(withIdentifier:"GrievanceHistoryViewController") as! GrievanceHistoryVC
        //    if searchBar.text != nil &&
        //        searchBar.text != ""
        //      {
        vc.complaintId = searchBar.text!
        //          vc.grivenceHistoryWS()
        //         }
        //    if vc.history != "s"{
        //
        self.navigationController?.pushViewController(vc, animated:true)
        //}
    }
}
extension UserListVC:UITableViewDelegate,UITableViewDataSource

{
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int //
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.userListmodel?.row != nil{
            
            return self.userListmodel?.row?.count ?? 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboards.Complaints.instance.instantiateViewController(withIdentifier:"UserdetailsVC") as! UserdetailsVC
        let details = userListmodel?.row?[indexPath.row]
        let mode = details?.modeID
        UserDefaults.standard.set(mode, forKey:"MODEID")
        UserDefaultVars.modeID = mode ?? ""
       // print(UserDefaultVars.modeID)
        let source = details?.cName
        vc.mode = mode
        vc.source = source
        vc.grievanceType = grievanceType
        // vc.detailsDict = dict ?? [:]
        self.navigationController?.pushViewController(vc, animated:true)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier:"UserListTableViewCell") as! UserListTableViewCell
        //        cell.wholeView.layer.cornerRadius = 5.0
        //        cell.wholeView.layer.borderWidth = 1.0
        //        cell.wholeView.layer.borderColor = UIColor.black.cgColor
        let details = userListmodel?.row?[indexPath.row]
        cell.userName.text = details?.cName
        cell.complaint.text = details?.mcount
        let imgeStr = details?.iURL
        cell.userImage.sd_setImage(with: URL(string:imgeStr!), placeholderImage: UIImage(named: "noi"))
        cell.selectionStyle = .none
        return cell
    }
    
}
