//
//  CheckStatusListVC.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 15/05/20.
//  Copyright © 2020 IOSuser3. All rights reserved.
//

import UIKit

class CheckStatusListVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    var grievanceList : [ViewGrievance]?
    //    var filteredGrievanceList : [ViewGrievance]?
    var sectionGrievanceList = [[ViewGrievance]]()
    var filteredSectionGrievanceList = [[ViewGrievance]]()
    var compIDStr: String?
    var servernotrespond = "Server not responding, please try again later!"

    
    @IBOutlet var backgroundImg: UIImageView!
    
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.navigationController?.navigationBar.isHidden = true
        let image = UserDefaults.standard.value(forKey:"bgImagview") as! String
        backgroundImg.image = UIImage.init(named:image)
        
        searchBar.delegate = self
        self.navigationController?.navigationBar.isHidden = true
        getListOfGrievances()
        //listofServices()
//        self.tableView.delegate = self
//        self.tableView.datasource = self

        
        
        //to stop floating Header in tableview
        let dummyViewHeight = CGFloat(44)
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
        self.tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
        self.tableView.tableFooterView = UIView()
        
    }
    @IBAction func backClikced(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    override func viewWillAppear(_ animated: Bool) {
        
        //    tableView.reloadData()
    }
    //MARK:- Service Calls
    func getListOfGrievances()
    {
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message: interNetconnection) ; return}
        //self.loading(text:"Loading Details..")
        //PKHUD.sharedHUD.show(onView: self.view)
        
        let parameters: [String : Any] = ["userid" : "cgg@ghmc","password" : "ghmc@cgg@2018", "mobileno" : UserDefaults.standard.value(forKey:"MOBILE_NO") as! String]
      //  print("params",parameters)
         NetworkRequest.makeRequest(type: GrievanceHistory.self, urlRequest: Router.getViewGrievances(parameters: parameters))  { [unowned self](result) in
            switch result
            {
            case .success(let resp):
               
                
                if resp.status == "success" || resp.status == "Success"
                {
                    //self.grievanceList = resp.viewGrievances
                    guard resp.viewGrievances!.count > 0 else {self.searchBar.isHidden = true;self.showAlert(message: "No Records found");return}
                    self.grievanceList = resp.viewGrievances
                    self.sectionGrievanceList = self.make2DArray(oneDArray: self.grievanceList!)
                    self.filteredSectionGrievanceList = self.sectionGrievanceList
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                else if resp.status.lowercased() == "fail" || resp.status.contains("F")
                {
                    self.showAlert(message: resp.message){[unowned self] in
                        guard let navController = self.navigationController else {return}
                        navController.popViewController(animated: true)
                        
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "GHMC", message: resp.message, preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            let vc = storyboards.Main.instance.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController
                            
                            self.navigationController?.pushViewController(vc!, animated: false)                        }
                        
                        alertController.addAction(okAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                        
                        
                    }
                }
            case .failure(let err):
                print(err)
                self.serverNotRespondAlet()
                
            }
        }
    }
    func serverNotRespondAlet()  {
           DispatchQueue.main.async {
            let alertController = UIAlertController(title: "MyGHMC", message: self.servernotrespond, preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                   UIAlertAction in
                   let vc = storyboards.HomeStoryBoard.instance.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController

                   self.navigationController?.pushViewController(vc!, animated: false)                        }

               alertController.addAction(okAction)

               self.present(alertController, animated: true, completion: nil)



           }
       }
    func getGrievanceStatus(parameters : [String : Any])
    {
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message: interNetconnection) ; return}
      //  print(parameters)
        NetworkRequest.makeRequest(type: GrievanceStatusCitezen.self, urlRequest: Router.getGrievanceStatusCitizen(parameters: parameters)) { [weak self](result) in
            switch result
            {
            case .success(let resp):
              //  print(resp)
                guard resp.status == "success" || resp.status == "Success" else {return}
                let grievanceArray = resp.grievance
                let commentsArray = resp.comments
                //  print(self.sendingArray)
                let VC = storyboards.HomeStoryBoard.instance.instantiateViewController(withIdentifier: "DetailCheckStatusVC") as! DetailCheckStatusVC
                VC.grievanceArray = grievanceArray
                VC.commentsArray = commentsArray
                
                self?.navigationController?.pushViewController(VC, animated: true)
            case .failure(let err):
                print(err)
            }
        }
        
    }
    //MARK:- IBActions
//    @IBAction func backClicked(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//
////        let vc = storyboards.Main.instance.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController
////
////        self.navigationController?.pushViewController(vc!, animated: false)
//    }
}
//MARK:- TableView Delegate & DataSource
extension CheckStatusListVC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredSectionGrievanceList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredSectionGrievanceList[section].count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44))
        view.backgroundColor = UIColor(red: 0, green: 26/255, blue: 51/255, alpha: 1.0)
        let typeLabel = UILabel(frame: CGRect(x: 10, y: 0, width: view.frame.width - 20, height: view.frame.height))
        typeLabel.font = UIFont.systemFont(ofSize: 14.0)
        typeLabel.textColor = .white
        
        typeLabel.text = self.filteredSectionGrievanceList[section][0].type
        //typeLabel.text = "sample"
        let countLabel =  UILabel(frame: CGRect(x: view.frame.width-30, y: 0, width: 30, height: view.frame.height))
        countLabel.font = UIFont.systemFont(ofSize: 14.0)
        countLabel.textColor = .white
        
        countLabel.text = "\(self.filteredSectionGrievanceList[section].count)"
        view.addSubview(typeLabel)
        view.addSubview(countLabel)
        return view
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckStatusCell") as! CheckStatusCell
        
        // print(self.sectionGrievanceList)
        
        let dict = self.filteredSectionGrievanceList[indexPath.section]
        print(dict)
        cell.complanitID.text = dict[indexPath.row].id
        cell.subcategoryNameLabel.text = dict[indexPath.row].type
        compIDStr =  dict[indexPath.row].id
        cell.categoryLabel.text =  dict[indexPath.row].category
        cell.timestamp.text =  dict[indexPath.row].timestamp
        cell.assignedToLlabel.text =  dict[indexPath.row].assignedto

        cell.mainVIew.layer.cornerRadius = 4.0
       // let status = dict[indexPath.row].status.replacingOccurrences(of: " ", with: "").lowercased()
        let status = dict[indexPath.row].status
      //  print(status)
        
        switch status {
        case "Open":
            cell.view1.backgroundColor = UIColor(red: 64/255, green: 118/255, blue: 1, alpha: 1.0)
            cell.view2.backgroundColor = UIColor.white
            cell.view3.backgroundColor = UIColor.white
            cell.view4.backgroundColor = UIColor.white
            cell.view5.backgroundColor = UIColor.white
        case "Under Process":
            cell.view1.backgroundColor = UIColor.white
            cell.view2.backgroundColor = UIColor(red: 255/255, green: 69/255, blue: 0, alpha: 1.0)
            cell.view3.backgroundColor = UIColor.white
            cell.view4.backgroundColor = UIColor.white
            cell.view5.backgroundColor = UIColor.white
        case "Resolved By Officer":
           cell.view1.backgroundColor = UIColor.white
           cell.view2.backgroundColor = UIColor.white
           cell.view3.backgroundColor = UIColor.white
           cell.view4.backgroundColor = UIColor(red: 28/255, green: 151/255, blue: 28/255, alpha: 1.0)
           cell.view5.backgroundColor = UIColor.white
        case "Closed":
            cell.view1.backgroundColor = UIColor.white
            cell.view2.backgroundColor = UIColor.white
            cell.view3.backgroundColor = UIColor(red: 28/255, green: 151/255, blue: 28/255, alpha: 1.0)
            cell.view4.backgroundColor = UIColor.white
            cell.view5.backgroundColor = UIColor.white
        default:
            cell.view1.backgroundColor = UIColor.white
            cell.view2.backgroundColor = UIColor.white
            cell.view3.backgroundColor = UIColor.white
            cell.view4.backgroundColor = UIColor.white
            cell.view5.backgroundColor = UIColor(red: 177/255, green: 24/255, blue: 27/255, alpha: 1.0)
        }
        //
        //        switch status {
        //        case "open":
        //             cell.trackerView.image = UIImage.init(named: "onestar")
        //        case "Closed":
        //            cell.trackerView.image = UIImage.init(named: "twostar")
        //        case "Under Process":
        //            cell.trackerView.image = UIImage.init(named: "threestar")
        //        default:
        //             cell.trackerView.image = UIImage.init(named: "fourstar")
        //        }
        cell.selectionStyle = .none
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = filteredSectionGrievanceList[indexPath.section][indexPath.row]
        let parameters: [String : Any] = ["userid" : "cgg@ghmc","password" : "ghmc@cgg@2018", "mobileno" : UserDefaults.standard.string(forKey: "MOBILE_NO")!, "compId": dict.id]
        self.getGrievanceStatus(parameters: parameters)
        
    }
    
}
//MARK:- SearchBar Delegate
extension CheckStatusListVC : UISearchBarDelegate

{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard self.grievanceList?.count ?? 0 > 0 else {return}
        if searchText != "" || searchText.count > 0
        {
            let filteredGrievanceList = self.grievanceList!.filter({ (value) -> Bool in
                return value.id.contains(searchText) || value.category.contains(searchText) || value.type.contains(searchText)
            })
            
            self.filteredSectionGrievanceList = make2DArray(oneDArray: filteredGrievanceList)
        }
        else{
            self.filteredSectionGrievanceList = self.sectionGrievanceList
        }
        tableView.reloadData()
    }
    func make2DArray(oneDArray : [ViewGrievance]) -> [[ViewGrievance]]
    {
        var filteredArray = [[ViewGrievance]]()
        let group = Dictionary(grouping: oneDArray, by: {$0.type})
        let values = group.values
        values.forEach({ (value) in
            filteredArray.append(value)
        })
        let sorted = filteredArray.sorted(by: {$0.count > $1.count})
        return sorted
        
        
    }
    
}
//MARK:- NetWork Models
struct GrievanceHistory: Codable {
    var status, message: String
    let viewGrievances: [ViewGrievance]?
}

// MARK: - ViewGrievance
struct ViewGrievance: Codable {
    let flag, id, type, timestamp: String
    let status, category, assignedto: String
}
// MARK: - Welcome
struct GrievanceStatusCitezen: Codable {
    let status: String
    let grievance: [Grievance]
    let comments: [Comment]
    
    enum CodingKeys: String, CodingKey {
        case status, grievance
        case comments = "Comments"
    }
}

// MARK: - Comment
struct Comment: Codable {
    let flag: String
    let cid, cdid, cremarks, cphoto: String?
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
    let feedback, status, id, type: String
    let landmark: String
    let photo: String
    let photo2, photo3: String
    let latlon, mobileno, cmobileno, timeStamp: String
    let gstatus, userName, remarks, assignedto: String
    let subCatID, statusid: String
    
    enum CodingKeys: String, CodingKey {
        case feedback, status, id, type, landmark, photo, photo2, photo3, latlon, mobileno, cmobileno
        case timeStamp = "time_stamp"
        case gstatus
        case userName = "user_name"
        case remarks, assignedto
        case subCatID = "sub_cat_id"
        case statusid
    }
}
