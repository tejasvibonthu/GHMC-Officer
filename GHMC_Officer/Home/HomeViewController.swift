//
//  HomeViewController.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 07/09/19.
//  Copyright © 2019 IOSuser3. All rights reserved.
//

import UIKit
import SideMenuSwift
class HomeViewController: UIViewController {
    @IBOutlet weak var bgimageview: UIImageView!
    @IBOutlet weak var bgImagev: UIImageView!
    @IBOutlet weak var userMobileNumber: UILabel!
    @IBOutlet weak var userDesignationLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var otherCountLabel: UILabel!
    @IBOutlet weak var SlfcountLabel: UILabel!
    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var otherGrivencesLabel: UILabel!
    @IBOutlet weak var slfLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var otherGrivences: UIView!
    @IBOutlet weak var slfGrivences: UIView!
    @IBOutlet weak var totalGrievances: UIView!
    @IBOutlet var grievanceView: UIView!
    @IBOutlet var checkStatusView: UIView!
    @IBOutlet weak var menuicon: UIButton!
    var totalType :String?
    var slfType :String?
    var otherType :String?
    var getCountsModel:GetAllCountsStruct?
    
    
    override func viewDidLoad() {
        let image = UserDefaults.standard.value(forKey:"bgImagview") as! String
         bgImagev.image = UIImage.init(named:image)
         bgimageview.image = UIImage.init(named:image)
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("theme"), object: nil)
        self.navigationController?.navigationBar.isHidden = true
        userNameLabel.text = UserDefaultVars.empName
        userDesignationLabel.text = UserDefaultVars.designation
        userMobileNumber.text = UserDefaultVars.mobileNumber

        let totalTap = UITapGestureRecognizer.init(target: self, action: #selector(taponTotalGrivence))
        totalGrievances.addGestureRecognizer(totalTap)
        let slfTap = UITapGestureRecognizer.init(target: self, action: #selector(taponSlfGrivence))
        slfGrivences.addGestureRecognizer(slfTap)
        let otherTap = UITapGestureRecognizer.init(target: self, action: #selector(taponotherGrivence))
        otherGrivences.addGestureRecognizer(otherTap)
        let grievanceViewtap = UITapGestureRecognizer(target: self, action:#selector(self.touchTapped))
        grievanceView.addGestureRecognizer(grievanceViewtap)
        let checkStatustap = UITapGestureRecognizer(target: self, action:#selector(self.touchTapped))
        checkStatusView.addGestureRecognizer(checkStatustap)

        self.getGrivanceCountsWS()

    }
    
    @objc func touchTapped(_ sender: UITapGestureRecognizer) {
        let view = sender.view //cast pointer to the derived class if needed
        if view!.tag == 1
        {
            let vc = storyboards.HomeStoryBoard.instance.instantiateViewController(withIdentifier: "GrievanceCategoryListVC") as? GrievanceCategoryListVC
            self.navigationController?.pushViewController(vc!, animated: true)
        }else if view!.tag == 2
        {
            let vc = storyboards.HomeStoryBoard.instance.instantiateViewController(withIdentifier: "CheckStatusListVC") as? CheckStatusListVC
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
    }
@objc func methodOfReceivedNotification(notification: Notification) {
    let theme = notification.object as! String
    bgimageview.image = UIImage.init(named:theme)
    bgImagev.image = UIImage.init(named:theme)
    }
   @objc func taponTotalGrivence(){
  //  print(totalCountLabel.text )
    if totalCountLabel.text != "0"{
    let vc = storyboards.Complaints.instance.instantiateViewController(withIdentifier:"UserListVC") as! UserListVC
    if totalType != nil {
     vc.grievanceType = totalType
    }
    self.navigationController?.pushViewController(vc, animated:true)
    }else {
    showAlert(message:datanotAvaliable)
    }
    }
    @objc func taponSlfGrivence(){
        if SlfcountLabel.text != "0"{
        let vc = storyboards.Complaints.instance.instantiateViewController(withIdentifier:"UserListVC") as! UserListVC
        if slfType != nil {
            vc.grievanceType = slfType
          //  print(slftype2 ?? "")
        }
        self.navigationController?.pushViewController(vc, animated:true)
        }else {
            showAlert(message:datanotAvaliable)
//            showCustomAlert(message: datanotAvaliable){
//                self.navigationController?.popViewController(animated: true)
//            }
        }
    }
    @objc func taponotherGrivence(){
        if self.otherCountLabel.text != "0"{
        let vc = storyboards.Complaints.instance.instantiateViewController(withIdentifier:"UserListVC") as! UserListVC
        if otherType != nil {
            vc.grievanceType = otherType
        }
        self.navigationController?.pushViewController(vc, animated:true)
        }else {
            self.showAlert(message:datanotAvaliable)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
         NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("theme"), object: nil)
  
        
    }
    
    @IBAction func menuAction(_ sender: Any) {
        sideMenuController?.revealMenu()
//        if self.revealViewController() != nil {
//            self.revealViewController().rearViewRevealWidth = 0.75 * UIScreen.main.bounds.size.width
//            self.revealViewController().panGestureRecognizer().isEnabled = true
//            self.revealViewController().tapGestureRecognizer()
//            revealViewController().revealToggle(sender)
//
//        } else {
//
//            let objReavealController = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
//            objReavealController.panGestureRecognizer().isEnabled = true
//            objReavealController.tapGestureRecognizer()
//            objReavealController.revealToggle(sender)
//        }
        
    }
    func getGrivanceCountsWS(){
        let uid = UserDefaults.standard.value(forKey:"EMP_D") as! String
        let type_Id = UserDefaults.standard.value(forKey:"TYPE_ID") as! String
        let params = ["userid" : userid,
                      "password" :password,
                      "uid" :uid,
                      "type_Id":type_Id]
        //   print(dict)
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
        NetworkRequest.makeRequest(type: GetAllCountsStruct.self, urlRequest: Router.getAllCount(params: params)) { [weak self](result) in
            switch result
            {
            case .success(let getCounts):
                print(getCounts)
                self?.getCountsModel = getCounts
                if getCounts.status == "true"{
                    if getCounts.row?.isEmpty == true {
                        self?.showAlert(message: "No Records found")
                    } else {
                        let totalGrivances = getCounts.row?[0].total?.split(separator:"-")
                        let slfGrivances = getCounts.row?[0].slf?.split(separator: "-")
                        let otherGrivances = getCounts.row?[0].nonSlf?.split(separator:"-")
                        let totalGrivancesCount = getCounts.row?[0].total?.split(separator:"-")
                        let slfGrivancesCount = getCounts.row?[0].slf?.split(separator: "-")
                        let otherGrivancesCount = getCounts.row?[0].nonSlf?.split(separator:"-")
                        
                        self?.totalLabel.text = String(totalGrivances?[2] ?? "")
                        self?.slfLabel.text = String(slfGrivances?[2] ?? "")
                        self?.otherGrivencesLabel.text = String(otherGrivances?[2] ?? "")
                        self?.totalCountLabel.text = String(totalGrivancesCount?[0] ?? "")
                        self?.SlfcountLabel.text = String(slfGrivancesCount?[0] ?? "")
                        self?.otherCountLabel.text = String(otherGrivancesCount?[0] ?? "")
                        self?.totalType = String(totalGrivancesCount?[1] ?? "")
                        self?.slfType = String(slfGrivancesCount?[1] ?? "")
                        self?.otherType = String(otherGrivancesCount?[1] ?? "")
                    }
                } else {
                    self?.showAlert(message: getCounts.status ?? "")
                }
          
            case .failure(let err):
                print(err)
                DispatchQueue.main.async {
                    self?.showAlert(message: serverNotResponding)
                }
            }
        }
        
    }
    }
    
//    func getallCOuntWS() {
//        print(UserDefaults.standard.value(forKey:"EMP_D") as! String)
//    let uid = UserDefaults.standard.value(forKey:"EMP_D") as! String
//    let type_Id = UserDefaults.standard.value(forKey:"TYPE_ID") as! String
//
//    let dict:Parameters = ["userid" : userid,
//                           "password" :password,
//                           "uid" :uid,
//                           "type_Id":type_Id]
//        print(dict)
//
//    DispatchQueue.main.async {
//    self.loading(text:progressMsgWhenLOginClicked)
//    PKHUD.sharedHUD.show()
//    }
//
//    Alamofire.request(Router.getAllCount(params:dict)).responseJSON {response in
//    DispatchQueue.main.async {
//    PKHUD.sharedHUD.hide()
//    }
//    switch response.result{
//    case .success:
//
//
//        guard let responseDict = response.result.value as? NSDictionary  else {
//
//            return
//        }
//        print(responseDict)
////        if !(responseDict.value(forKey:"ROW") is NSNull)  &&
////             responseDict.value(forKey:"ROW") != nil {
//        guard let row = responseDict.value(forKey:"ROW") as? NSArray else {
//            self.otherGrivences.isHidden = true
//
//            self.totalGrievances.isHidden = true
//            self.slfGrivences.isHidden = true
//            self.showAlert(message:"No Records Found")
//            return
//          }
//            //let row = responseDict.value(forKey:"ROW") as! NSArray
//            let RowsDict = row[0] as! NSDictionary
//            let total = RowsDict.value(forKey:"Total") as! String
//            let totalCount = total.split(separator:"-")
//            let slf = RowsDict.value(forKey:"SLF") as! String
//            let slfCount = slf.split(separator:"-")
//
//            let other = RowsDict.value(forKey:"NON SLF") as! String
//            let otherCount = other.split(separator:"-")
//            self.totalCountLabel.text = String(totalCount[0])
//            self.otherCountLabel.text = String(otherCount[0])
//            self.SlfcountLabel.text =  String(slfCount[0])
//            self.totalLabel.text =  String(totalCount[2])
//            self.otherGrivencesLabel.text = String(otherCount[2])
//            self.slfLabel.text = String(slfCount[2])
//            self.slftype1 = String(totalCount[1])
//            self.slftype2 = String(slfCount[1])
//         //  print(self.slftype2)
//            self.slftype3 = String(otherCount[1])
//            self.totalCount = String(totalCount[0])
//            self.slfCount = String(slfCount[0])
//            self.otherCount = String(otherCount[0])
//
//    break
//    case .failure(let error):
//    self.showAlert(message:"Please Try Again Later")
//    print(error)
//
//    break
//
//
//    }
//
//    }
//    }
    
//}
// MARK: - GetAllCounts
struct GetAllCountsStruct: Codable {
    let status: String?
    let tag: JSONNull?
    let row: [Row]?

    enum CodingKeys: String, CodingKey {
        case status, tag
        case row = "ROW"
    }
}

// MARK: - Row
struct Row: Codable {
    let total, slf, nonSlf: String?

    enum CodingKeys: String, CodingKey {
        case total = "Total"
        case slf = "SLF"
        case nonSlf = "NON SLF"
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
