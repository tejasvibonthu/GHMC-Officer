//
//  FullGrivenceDetailsViewController.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 13/09/19.
//  Copyright © 2019 IOSuser3. All rights reserved.
//

import UIKit
import  PKHUD
import Alamofire
import SDWebImage
class FullGrievancedetailsVC: UIViewController,UISearchBarDelegate {
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var bgImagev: UIImageView!
    @IBOutlet weak var tableview: UITableView!
    var detailsDict:Parameters?
    var model:fullGrivence?
    var filteredSectionGrievanceList : [grievance1]?
    var tableViewDataSource:[ViewtypeGriveancesStruct.Grievance]?
    var viewtypeGrivancesModel:[ViewtypeGriveancesStruct.Grievance]?
    var compTypeId:String?
    var imagestr1:String?
    var imagestr2:String?
    var imagestr3:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = UserDefaults.standard.value(forKey:"bgImagview") as? String  {
            bgImagev.image = UIImage.init(named:image)
        }
        tableview.rowHeight = UITableView.automaticDimension
        searchbar.delegate = self
        self.viewGrivanceTypesWS()
        self.navigationController?.navigationBar.isHidden = true
    }
 
    @IBAction func back_action(_ sender: Any) {
        navigationController?.popViewController(animated:true)
    }
    func viewGrivanceTypesWS(){
     let params =    ["mode":UserDefaultVars.modeID,
                     "userid":userid,
                     "password":password,
                     "uid":UserDefaultVars.empId,
                     "type_id":UserDefaultVars.typeId,
                     "slftype":UserDefaultVars.grievanceType,
                     "comptype": self.compTypeId
        ]
      //  print(params)
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
        NetworkRequest.makeRequest(type: ViewtypeGriveancesStruct.self, urlRequest:Router.fullGrievence(param: params as Parameters)) { [weak self](result) in
            switch result
            {
            case .success(let grivancesIs):
                print(grivancesIs)
                if  grivancesIs.status == "true" {
                    if  !grivancesIs.grievance.isEmpty {
                        self?.viewtypeGrivancesModel = grivancesIs.grievance
                        self?.tableViewDataSource = self?.viewtypeGrivancesModel
                        self?.tableview.reloadData()
                    }
                } else {
                    self?.showAlert(message: grivancesIs.status)
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
extension FullGrievancedetailsVC:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int //
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataSource?.count ?? 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboards.Complaints.instance.instantiateViewController(withIdentifier:"GrievanceHistoryVC") as! GrievanceHistoryVC
        vc.complaintId = tableViewDataSource?[indexPath.row].id
     //   let complaintId = model?.grievance?[indexPath.row].id!
       // UserDefaults.standard.set(complaintId, forKey: "complaint_id")
        self.navigationController?.pushViewController(vc, animated:true)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier:"FullGrivenceTableViewCell") as! FullGrivenceTableViewCell
        let dict = tableViewDataSource?[indexPath.row]
        cell.idLabel.text = dict?.id
        cell.typeLabel.text = dict?.type
        cell.statusLabel.text = dict?.status
        cell.timeStampLabel.text = dict?.timestamp
        cell.wholeView.layer.cornerRadius = 5.0
        cell.wholeView.layer.borderWidth = 1.0
        cell.wholeView.layer.borderColor = UIColor.black.cgColor
        self.imagestr1 = dict?.photo
        self.imagestr2 = dict?.photo2
        self.imagestr3 = dict?.photo3
        cell.setup(indexpath:indexPath)
        
        if (imagestr1?.hasSuffix("g"))!{
            cell.imgae1.image = UIImage.init(named:"viewimage")
            
        }else if (imagestr1?.hasSuffix("f"))!{
            cell.imgae1.image = UIImage.init(named:"pdfnew")
            
        }
        if (imagestr3?.hasSuffix("g"))!{
            cell.image3.image = UIImage.init(named:"viewimage")
            
        }else if (imagestr3?.hasSuffix("f"))!{
            cell.image3.image = UIImage.init(named:"pdfnew")
            
        }
        if (imagestr2?.hasSuffix("g"))!{
            cell.image2.image = UIImage.init(named:"viewimage")
            
        }else if (imagestr2?.hasSuffix("f"))!{
            cell.image2.image = UIImage.init(named:"pdfnew")
            
        }
        let  imgGesture1 = UITapGestureRecognizer.init(target:self, action:#selector(firstpdfTapped))
        cell.imgae1.isUserInteractionEnabled = true;
        cell.imgae1.addGestureRecognizer(imgGesture1)
        let  imgGesture2 = UITapGestureRecognizer.init(target:self, action:#selector(secondpdfTapped))
        cell.imgae1.isUserInteractionEnabled = true;
        cell.image2.addGestureRecognizer(imgGesture2)
        let  imgGesture3 = UITapGestureRecognizer.init(target:self, action:#selector(thirdpdfTapped))
        cell.imgae1.isUserInteractionEnabled = true;
        cell.image3.addGestureRecognizer(imgGesture3)
        cell.selectionStyle = .none
        return cell
    }
    @objc func firstpdfTapped(){
        if let img = imagestr1{
            print(img)
            if ((img.hasSuffix("g")) == true){
                let vc = storyboards.photoDisplay.instance.instantiateViewController(withIdentifier:"photViewController") as! photViewController
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .overCurrentContext
                vc.imageString = imagestr1
                self.present(vc, animated:false, completion:nil)
            } else if ((img.hasSuffix("pdf")) == true){
                let vc = storyboards.photoDisplay.instance.instantiateViewController(withIdentifier:"PdfVC") as! PdfVC
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .overCurrentContext
                vc.pdfString = img
                self.present(vc, animated:false, completion:nil)
            }
        }
    }
    @objc func secondpdfTapped(){
        // print(imagestr2)
        if ((imagestr2?.hasSuffix("g")) != nil){
            let vc = storyboards.photoDisplay.instance.instantiateViewController(withIdentifier:"photViewController") as! photViewController
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .overCurrentContext
            vc.imageString = imagestr2
            self.present(vc, animated:false, completion:nil)
        }else if ((imagestr2?.hasSuffix("f")) != nil){
            let vc = storyboards.photoDisplay.instance.instantiateViewController(withIdentifier:"PdfVC") as! PdfVC
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .overCurrentContext
            vc.pdfString = imagestr2
            self.present(vc, animated:false, completion:nil)
        }
    }
    @objc func thirdpdfTapped(){
        if ((imagestr3?.hasSuffix("g")) != nil){
            let vc = storyboards.photoDisplay.instance.instantiateViewController(withIdentifier:"photViewController") as! photViewController
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .overCurrentContext
            vc.imageString = imagestr3
            self.present(vc, animated:false, completion:nil)
        }else if ((imagestr3?.hasSuffix("f")) != nil){
            let vc = storyboards.photoDisplay.instance.instantiateViewController(withIdentifier:"PdfVC") as! PdfVC
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .overCurrentContext
            vc.pdfString = imagestr3
            self.present(vc, animated:false, completion:nil)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchString = searchText
        if searchText == ""{
            self.tableViewDataSource = self.viewtypeGrivancesModel
        } else{
            if searchString != "", searchString.count > 0 {
                self.tableViewDataSource = self.viewtypeGrivancesModel?.filter {
                    return $0.id.range(of: searchString, options: .caseInsensitive) != nil
                }
            }
        }
        tableview.reloadData()
    }
    
    // MARK: - ViewtypeGriveances
    struct ViewtypeGriveancesStruct: Codable {
        let status: String
        let ward: JSONNull?
        let grievance: [Grievance]
        // MARK: - Grievance
        struct Grievance: Codable {
            let id, type, timestamp, status: String
            let photo: String
            let photo2, photo3: String
            let coulurcode: String
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
