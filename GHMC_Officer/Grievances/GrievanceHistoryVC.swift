//
//  GrievanceHistoryViewController.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 13/09/19.
//  Copyright © 2019 IOSuser3. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD
import SDWebImage
class GrievanceHistoryVC: UIViewController {
    var complaintId:String?
    var grivenceHistorymodel:GrievancehistoryStruct?
    var phonenumber:String?
    var history:String?
    var modeId:String?
    var subcatID:String?
    @IBOutlet weak var bgImagev: UIImageView!
    @IBOutlet weak var viewCommentsButton: UIButton!
    @IBOutlet weak var takeActionButton: UIButton!
    @IBOutlet weak var viewdirectionsButton: UIButton!
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        modeId = UserDefaults.standard.value(forKey:"MODEID") as? String
        //  modeId = "15"
        self.viewdirectionsButton.isHidden = true
        tableview.rowHeight = UITableView.automaticDimension
        let image = UserDefaults.standard.value(forKey:"bgImagview") as! String
        bgImagev.image = UIImage.init(named:image)
        self.grivenceHistoryWs()
        tableview.delegate = self
        tableview.dataSource = self
        self.navigationController?.navigationBar.isHidden = true
    }
    @IBAction func backButton_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated:true)
    }
    @IBAction func viewComments_Action(_ sender: Any) {
        let vc = storyboards.Complaints.instance.instantiateViewController(withIdentifier:"ViewcommentsVc") as! ViewcommentsVc
         vc.array = self.grivenceHistorymodel
        self.navigationController?.pushViewController(vc, animated:true)
    }
    @IBAction func take_Action(_ sender: Any) {
        if(modeId == "15"){
//            let vc = storyboards.Complaints.instance.instantiateViewController(withIdentifier:"TakeActionNewNMOSVC") as! TakeActionNewNMOSVC
//            self.navigationController?.pushViewController(vc, animated:true)
        } else{
            let vc = storyboards.Complaints.instance.instantiateViewController(withIdentifier:"TakesactionVC") as! TakesactionVC
            vc.myComplaintId = complaintId
            self.navigationController?.pushViewController(vc, animated:true)
        }
    }
    @IBAction func viewdirections(_ sender: Any) {
        guard let latlan = self.grivenceHistorymodel?.grievance?[0].latlon else {self.showAlert(message: "Unable get location please try again later");return}
        let latlansArray = latlan.components(separatedBy: ",")
//        print("latres",strArray[0])
//        print("lonres",strArray[1])
       //  gotoGoogleMapsDirection(destLat: latlansArray[0], destLong: latlansArray[1])
        openGoogleMap(destLat: latlansArray[0], destLon: latlansArray[1])
//
//        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
//            UIApplication.shared.openURL(NSURL(string:
//                "comgooglemaps://?saddr=&daddr=\(latlansArray[0]),\(latlansArray[0])&directionsmode=driving")! as URL)
//
//        } else {
//          self.showAlert(message: "Google Maps not found")        }
        }
    func openGoogleMap(destLat : String , destLon : String) {
        let lat = destLat
        let latDouble =  Double(lat)
        let long = destLon
        let longDouble =  Double(long)
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app
            if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(String(describing: latDouble!)),\(String(describing: longDouble!))&directionsmode=driving") {
                UIApplication.shared.open(url, options: [:])
            }}
        else {
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(String(describing: latDouble!)),\(String(describing: longDouble!))&directionsmode=driving") {
                UIApplication.shared.open(urlDestination)
            }
        }
    }
    func grivenceHistoryWs(){
        let paramsDict:Parameters = ["userid":userid,
        "password":password,
        "compId":complaintId ?? ""]
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
        NetworkRequest.makeRequest(type: GrievancehistoryStruct.self, urlRequest:Router.grivenceHistory(params: paramsDict)) { [weak self](result) in
            switch result
            {
            case .success(let grivancesHistory):
             //   print(grivancesHistory)
                self?.grivenceHistorymodel = grivancesHistory
               // print( self?.grivenceHistorymodel)
                if  grivancesHistory.status == "success" {
                  self?.subcatID =  grivancesHistory.grievance?[0].subCat
                    UserDefaults.standard.set(self?.subcatID, forKey:"SUBCAT_ID")
                    UserDefaultVars.subcatId = self?.subcatID ?? ""
                    if((grivancesHistory.grievance?[0].latlon == "0.0,0.0") || (grivancesHistory.grievance?[0].latlon == nil)){
                        self?.viewdirectionsButton.isHidden = true

                    } else{
                        self?.viewdirectionsButton.isHidden = false

                   }
                   if grivancesHistory.commentsFlag == "false"{
                    self?.viewCommentsButton.isHidden = true

                   }else{
                    self?.viewCommentsButton.isHidden = false
                   }
                   if grivancesHistory.grievance?[0].gstatus == "closed"{
                    self?.takeActionButton.isHidden = true
                   }
                       else{
                        self?.takeActionButton.isHidden = false
                   }
                    DispatchQueue.main.async {
                        self?.tableview.reloadData()
                    }
                    
                } else {
                    self?.showAlert(message: grivancesHistory.status ?? "")
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
extension GrievanceHistoryVC:imageTapped {
    func image1TappingAction(string: Int?) {
        let str = grivenceHistorymodel?.grievance?[string!].photo
        if ((str?.hasSuffix("g"))!){
            let vc = storyboards.photoDisplay.instance.instantiateViewController(withIdentifier:"photViewController") as! photViewController
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .overCurrentContext
            vc.imageString = grivenceHistorymodel?.grievance?[string!].photo
            self.navigationController?.present(vc, animated:false, completion:nil)
        }else if (str!.hasSuffix("f")){
            let vc = storyboards.photoDisplay.instance.instantiateViewController(withIdentifier:"PdfViewController") as! PdfViewController
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .overCurrentContext
            vc.pdfString = grivenceHistorymodel?.grievance?[string!].photo
            self.navigationController?.present(vc, animated:false, completion:nil)
        }
    }
    
    func image2TappingAction(string: Int?) {
        let str =  grivenceHistorymodel?.grievance?[string!].photo2
        if (str?.hasSuffix("g"))!{
            let vc = storyboards.photoDisplay.instance.instantiateViewController(withIdentifier:"photViewController") as! photViewController
            vc.imageString = grivenceHistorymodel?.grievance?[string!].photo2
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .overCurrentContext
            self.navigationController?.present(vc, animated:false, completion:nil)
        }else if (str?.hasSuffix("f"))!{
            let vc = storyboards.photoDisplay.instance.instantiateViewController(withIdentifier:"PdfViewController") as! PdfViewController
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .overCurrentContext
            vc.pdfString = grivenceHistorymodel?.grievance?[string!].photo2
            self.navigationController?.present(vc, animated:false, completion:nil)
        }
    }
    
    func image3TappingAction(string: Int?) {
        let str =  grivenceHistorymodel?.grievance?[string!].photo3
        if (str?.hasSuffix("g"))!{
            let vc = storyboards.photoDisplay.instance.instantiateViewController(withIdentifier:"photViewController") as! photViewController
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .overCurrentContext
            vc.imageString = grivenceHistorymodel?.grievance?[string!].photo3
            self.navigationController?.present(vc, animated:false, completion:nil)
        }else if (str?.hasSuffix("f"))! {
            let vc = storyboards.photoDisplay.instance.instantiateViewController(withIdentifier:"PdfViewController") as! PdfViewController
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .overCurrentContext
            vc.pdfString = grivenceHistorymodel?.grievance?[string!].photo3
            self.navigationController?.present(vc, animated:false, completion:nil)
        }
    }
    
}

extension GrievanceHistoryVC:UITableViewDelegate,UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return   grivenceHistorymodel?.grievance?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier:"GrivenceHistoryTableViewCell") as! GrivenceHistoryTableViewCell
        cell.wholeView.layer.cornerRadius = 5.0
        cell.wholeView.layer.borderWidth = 1.0
        cell.wholeView.layer.borderColor = UIColor.black.cgColor
        let history = grivenceHistorymodel?.grievance?[indexPath.row]
        cell.id.text = history?.id
        cell.landMark.text  = history?.landmark
        cell.mobileNumber.text = history?.mobileno
        cell.postedBy.text = history?.userName
        cell.remarks.text = history?.remarks
        cell.status.text = history?.gstatus
        cell.type.text  = history?.type
        cell.timeStamp.text  = history?.timeStamp
        cell.nmosLandmark.text  = history?.landmark
        cell.circle.text  = history?.circle
        cell.ward.text  = history?.ward
        cell.tradeName.text  = history?.traderName
        if(modeId == "15"){
            cell.nmosStackView.isHidden =  false
            cell.nmosHeight.constant = 112
            cell.nomstopHeight.constant = 8
        } else{
            cell.nmosStackView.isHidden = true
            cell.nmosHeight.constant = 0
            cell.nomstopHeight.constant = 0
        }
        let phoneNumber = grivenceHistorymodel?.grievance?[indexPath.row].mobileno!
        phonenumber = phoneNumber!
        cell.callButton.addTarget(self, action:#selector(makeAPhoneCall), for: .touchUpInside)
        let imagestr1 = history?.photo ?? ""
        let imagestr2 = history?.photo2 ?? ""
        let imagestr3 = history?.photo3 ?? ""
        // cell.imgae1.sd_setImage(with: URL(string:"imagestr1"), placeholderImage: UIImage(named: "ghmc_layer"))
        // cell.image2.sd_setImage(with: URL(string:imagestr1!), placeholderImage: UIImage(named: "ghmc_layer"))
        // cell.image3.sd_setImage(with: URL(string:imagestr1!), placeholderImage: UIImage(named: "ghmc_layer"))
        
        cell.setup(indexpath:indexPath)
        cell.delegate1 = self
        
        if (imagestr1.hasSuffix("g")){
            cell.imgae1.image = UIImage.init(named:"viewimage")
            
        }else if (imagestr1.hasSuffix("f")){
            cell.imgae1.image = UIImage.init(named:"pdfnew")
            
        }
        if (imagestr3.hasSuffix("g")){
            cell.image3.image = UIImage.init(named:"viewimage")
            
        }else if (imagestr3.hasSuffix("f")){
            cell.image3.image = UIImage.init(named:"pdfnew")
            
        }
        if (imagestr2.hasSuffix("g")){
            cell.image2.image = UIImage.init(named:"viewimage")
            
        }else if (imagestr2.hasSuffix("f")){
            cell.image2.image = UIImage.init(named:"pdfnew")
            
        }
        
        cell.selectionStyle = .none
        return cell
    }
    @objc func makeAPhoneCall()  {
         let url: NSURL = URL(string: "TEL://\(phonenumber! )")! as NSURL
         UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
     }
    
}


// MARK: - GrievancehistoryStruct
struct GrievancehistoryStruct: Codable {
    let status, grievanceFlag, commentsFlag: String?
    let grievance: [Grievance]?
    let comments: [Comment]?

    enum CodingKeys: String, CodingKey {
        case status, grievanceFlag, commentsFlag, grievance
        case comments = "Comments"
    }
    
    // MARK: - Comment
    struct Comment: Codable {
        let flag, cid, cdid, cremarks: String?
        let cphoto: String?
        let clatlon, cmobileno, cuserName, cstatus: String?
        let ctimeStamp: String?

        enum CodingKeys: String, CodingKey {
            case flag, cid, cdid, cremarks, cphoto, clatlon, cmobileno
            case cuserName = "cuser_name"
            case cstatus
            case ctimeStamp = "ctime_stamp"
        }
    }
    // MARK: - Grievance
    struct Grievance: Codable {
        let status, id, type, landmark: String?
        let photo: String?
        let photo2, photo3: String?
        let latlon, mobileno, timeStamp, gstatus: String?
        let userName, remarks, sourceURL, claimantStatus: String?
        let ward, circle, traderName, claim: String?
        let subCat: String?

        enum CodingKeys: String, CodingKey {
            case status, id, type, landmark, photo, photo2, photo3, latlon, mobileno
            case timeStamp = "time_stamp"
            case gstatus
            case userName = "user_name"
            case remarks
            case sourceURL = "source_url"
            case claimantStatus = "claimant_status"
            case ward, circle
            case traderName = "trader_name"
            case claim
            case subCat = "Sub_Cat"
        }
    }

}


