//
//  RequestListVC.swift
//  GHMC_Officer
//
//  Created by deep chandan on 09/04/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//

import UIKit

class RequestListVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
  //  var params:Parameters?
    var requestListModel:RequestListStruct?
    var tableviewDatasource:[RequestListStruct.Details]?
    var estimationDetailsModel:RequestEstimationStruct?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        self.getRequestListWS()
    }
    @IBAction func backbuttonClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func getRequestListWS(){
       let params = ["EMPLOYEE_ID":"843",
                       "DEVICEID":deviceId,
                       "TOKEN_ID":UserDefaultVars.token
        ]
      //  print(params)
        
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
        NetworkRequest.makeRequest(type: RequestListStruct.self, urlRequest: Router.getAMOHRequestList(Parameters: params)) { [weak self](result) in
            switch result
            {
            case .success(let getList):
              //  print(getList)
                self?.requestListModel = getList
                self?.tableviewDatasource = self?.requestListModel?.amohList
                if getList.statusCode == "200"{
                    if getList.amohList?.isEmpty == true {
                        self?.showAlert(message: "No Records found")
                    } else {
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                    }
                } else {
                    self?.showCustomAlert(message: getList.statusMessage ?? ""){
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
    func getRequestDetailsWS(ticketID:String){
        let params = ["CNDW_GRIEVANCE_ID":ticketID,
                      "EMPLOYEE_ID":"843",
                      "DEVICEID":deviceId,
                      "TOKEN_ID":UserDefaultVars.token
        ]
      //  print(params)
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
        NetworkRequest.makeRequest(type: RequestEstimationStruct.self, urlRequest: Router.getAMOHRequestEstimation(Parameters: params )) { [weak self](result) in
            switch result
            {
            case .success(let getDetails):
              //  print(getList)
                self?.estimationDetailsModel = getDetails
                if getDetails.statusCode == "600"{
                    self?.showCustomAlert(message: getDetails.statusMessage ?? ""){
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
                if getDetails.statusCode == "200"{
                    let vc = storyboards.AMOH.instance.instantiateViewController(withIdentifier: "RequestEstimationVC")as! RequestEstimationVC
                    vc.estimationDetails = self?.estimationDetailsModel
                   // print(ticketIdLb)
                     self?.navigationController?.pushViewController(vc, animated:true)
                    }
                 else {
                    self?.showCustomAlert(message: getDetails.statusMessage ?? ""){
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableviewDatasource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestListCell") as! RequestListCell
        let details = tableviewDatasource?[indexPath.row]
        cell.ticketIdLb.text = details?.tokenID
        cell.locationLB.text = details?.location
        cell.dateLb.text = details?.createdDate
        cell.estimatedwasteLb.text = details?.estWt
        cell.imageIs?.image = UIImage.init(named:details?.imagePath ?? "")
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        let details = tableviewDatasource?[indexPath.row]
        guard let ticketIdLb = details?.tokenID else { return  }
        getRequestDetailsWS(ticketID: ticketIdLb)
       // print(ticketIdLb)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchString = searchText
        if searchText == ""{
            self.tableviewDatasource = self.requestListModel?.amohList
        } else{
            if searchString != "", searchString.count > 0 {
                self.tableviewDatasource = self.requestListModel?.amohList?.filter {
                    return $0.tokenID?.range(of: searchString, options: .caseInsensitive) != nil
                }
            }
        }
        tableView.reloadData()
    }
}
// MARK: - RequestListStruct
struct RequestListStruct: Codable {
    let statusCode, statusMessage: String?
    let amohList: [Details]?

    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
        case amohList = "AMOHList"
    }
    // MARK: - Encode/decode helpers
    class Details: Codable {
        let tokenID, location, imagePath ,estWt,createdDate,status: String?
        enum CodingKeys: String, CodingKey {
            case tokenID = "TICKET_ID"
            case location = "LOCATION"
            case imagePath = "IMAGE1_PATH"
            case estWt = "EST_WT"
            case createdDate = "CREATED_DATE"
            case status = "STATUS"
        }
    }
}

// MARK: - RequestEstimationStruct
struct RequestEstimationStruct: Codable {
    let statusCode, statusMessage, zoneID, circleID: String?
    let wardID, landmark, vehicleType: String?
    let image1Path: String?
    let image2Path, image3Path, noOfVehicles, estWt: String?
    let createdBy, createdDate, status: String?

    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
        case zoneID = "ZONE_ID"
        case circleID = "CIRCLE_ID"
        case wardID = "WARD_ID"
        case landmark = "LANDMARK"
        case vehicleType = "VEHICLE_TYPE"
        case image1Path = "IMAGE1_PATH"
        case image2Path = "IMAGE2_PATH"
        case image3Path = "IMAGE3_PATH"
        case noOfVehicles = "NO_OF_VEHICLES"
        case estWt = "EST_WT"
        case createdBy = "CREATED_BY"
        case createdDate = "CREATED_DATE"
        case status = "STATUS"
    }
}

