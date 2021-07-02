//
//  ConcessionerRejectListVC.swift
//  GHMC_Officer
//
//  Created by deep chandan on 24/06/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//

import UIKit

class RequestLists: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var navTitleLb: UILabel!
    var requestListModel:RequestListStruct?
    var tableviewnoofReqDatasource:[RequestListStruct.Details]?
    var paymentComformListModel:GetPaidListStruct?
    var tableviewPaymentDatasource:[GetPaidListStruct.PaidList]?
    var rejectListModel:ConcessionerRejectListStruct?
    var tableviewDatasource:[ConcessionerRejectListStruct.TicketList]?
    var estimationDetailsModel:RequestEstimationStruct?
    var concessionerCloselistmodel:AmohconcessionerClosedListStruct?
    var concessionerCloselistTabledatasource:[AmohconcessionerClosedListStruct.TicketList]?
    var amohClosedListModel:AmohClosedListStruct?
    var amohClosedlistTableviewdatasource:[AmohClosedListStruct.TicketList]?
    var tag:Int?
        override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
            if tag == 0 {
                self.navTitleLb.text = "No of requests"
                self.getRequestListWS()
            }
            else if tag == 1 {
                self.navTitleLb.text = "Payment Conformed Tickets"
                self.getPaymentConformationListWS()
            }
            else if tag == 2 {
                self.navTitleLb.text = "Concessioner Rejected tickets"
                self.getConcessionerRejectListWS()
            }
            else if tag == 3 {
                self.navTitleLb.text = "Concessioner Closed tickets"
                self.getConcessionerCloseListWS()
            }
            else if tag == 4 {
                self.navTitleLb.text = "Amoh Closed tickets"
                self.getamohCloseListWS()
            }
    }
    func getRequestListWS(){
        let params = ["EMPLOYEE_ID":UserDefaultVars.empId,
                       "DEVICEID":deviceId,
                       "TOKEN_ID":UserDefaultVars.token
        ]
      //print(params)
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
        NetworkRequest.makeRequest(type: RequestListStruct.self, urlRequest: Router.getAMOHRequestList(Parameters: params)) { [weak self](result) in
            switch result
            {
            case .success(let getList):
                print(getList)
                self?.requestListModel = getList
                self?.tableviewnoofReqDatasource = self?.requestListModel?.amohList
                if getList.statusCode == "600"{
                    self?.showAlert(message: getList.statusMessage ?? ""){
                        let vc = storyboards.Main.instance.instantiateViewController(withIdentifier: "LoginViewControllerViewController") as! LoginViewControllerViewController
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
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
    func getPaymentConformationListWS(){
        let params = [
            "EMPLOYEE_ID": UserDefaultVars.empId,
            "DEVICEID": deviceId,
            "TOKEN_ID": UserDefaultVars.token
        ]
      //print(params)
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
        NetworkRequest.makeRequest(type: GetPaidListStruct.self, urlRequest: Router.getPaymentConformedList(Parameters: params)) { [weak self](result) in
            switch result
            {
            case .success(let getList):
              //  print(getList)
                self?.paymentComformListModel = getList
                self?.tableviewPaymentDatasource = self?.paymentComformListModel?
                    .paidList
                if getList.statusCode == "600"{
                    self?.showAlert(message: getList.statusMessage ?? ""){
                        let vc = storyboards.Main.instance.instantiateViewController(withIdentifier: "LoginViewControllerViewController") as! LoginViewControllerViewController
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                if getList.statusCode == "200"{
                    if getList.paidList?.isEmpty == true {
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
    func getConcessionerRejectListWS(){
        let params = ["AMOH_EMP_ID": UserDefaultVars.empId,
                      "AMOH_EMP_WARD_ID": "",
                      "DEVICEID": deviceId,
                      "TOKEN_ID": UserDefaultVars.token
        ]
      //print(params)
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
        NetworkRequest.makeRequest(type: ConcessionerRejectListStruct.self, urlRequest: Router.getConcessionerRejectList(Parameters: params)) { [weak self](result) in
            switch result
            {
            case .success(let getList):
              //  print(getList)
                self?.rejectListModel = getList
                self?.tableviewDatasource = self?.rejectListModel?.ticketsList
                if getList.statusCode == "600"{
                    self?.showAlert(message: getList.statusMessage ?? ""){
                        let vc = storyboards.Main.instance.instantiateViewController(withIdentifier: "LoginViewControllerViewController") as! LoginViewControllerViewController
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                if getList.statusCode == "200"{
                    if getList.ticketsList?.isEmpty == true {
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
    func getConcessionerCloseListWS(){
        let params = ["AMOH_EMP_ID": UserDefaultVars.empId,
                      "DEVICEID": deviceId,
                      "TOKEN_ID": UserDefaultVars.token
        ]
      //print(params)
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
        NetworkRequest.makeRequest(type: AmohconcessionerClosedListStruct.self, urlRequest: Router.getamohConcessionerCloseList(Parameters: params)) { [weak self](result) in
            switch result
            {
            case .success(let getList):
              //  print(getList)
                self?.concessionerCloselistmodel = getList
                self?.concessionerCloselistTabledatasource = self?.concessionerCloselistmodel?.ticketList
                if getList.statusCode == "600"{
                    self?.showAlert(message: getList.statusMessage ?? ""){
                        let vc = storyboards.Main.instance.instantiateViewController(withIdentifier: "LoginViewControllerViewController") as! LoginViewControllerViewController
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                if getList.statusCode == "200"{
                    if getList.ticketList?.isEmpty == true {
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
    func getamohCloseListWS(){
        let params = ["AMOH_EMP_ID": UserDefaultVars.empId,
                      "AMOH_EMP_WARD_ID": "",
                      "DEVICEID": deviceId,
                      "TOKEN_ID": UserDefaultVars.token
        ]
      print(params)
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
        NetworkRequest.makeRequest(type: AmohClosedListStruct.self, urlRequest: Router.amohclosedList(Parameters: params)) { [weak self](result) in
            switch result
            {
            case .success(let getList):
               print(getList)
                self?.amohClosedListModel = getList
                self?.amohClosedlistTableviewdatasource = self?.amohClosedListModel?.ticketList
                if getList.statusCode == "600"{
                    self?.showAlert(message: getList.statusMessage ?? ""){
                        let vc = storyboards.Main.instance.instantiateViewController(withIdentifier: "LoginViewControllerViewController") as! LoginViewControllerViewController
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                if getList.statusCode == "200"{
                    if getList.ticketList?.isEmpty == true {
                        self?.showAlert(message: "No Records found"){
                            self?.navigationController?.popViewController(animated: true)
                        }
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
                      "EMPLOYEE_ID":UserDefaultVars.empId,
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
                    self?.showAlert(message: getDetails.statusMessage ?? ""){
                        let vc = storyboards.Main.instance.instantiateViewController(withIdentifier: "LoginViewControllerViewController") as! LoginViewControllerViewController
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                if getDetails.statusCode == "200"{
                    let vc = storyboards.AMOH.instance.instantiateViewController(withIdentifier: "RequestEstimationVC")as! RequestEstimationVC
                    vc.estimationDetails = self?.estimationDetailsModel
                    vc.ticketId = ticketID
                    vc.tag = 0
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
    
    @IBAction func backbtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tag == 0 {
            return tableviewnoofReqDatasource?.count ?? 0
        }else if tag == 1 {
            return tableviewPaymentDatasource?.count ?? 0
        } else if tag == 2{
            return tableviewDatasource?.count ?? 0
        } else if tag == 3{
            return concessionerCloselistTabledatasource?.count ?? 0
        } else if tag == 4{
            return amohClosedlistTableviewdatasource?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestsListCell") as! RequestsListCell
        //no of requests
        if tag == 0{
            let details = tableviewnoofReqDatasource?[indexPath.row]
            cell.ticketIdLb.text = details?.tokenID
            cell.locationLb.text = details?.location
            cell.dateLb.text = details?.createdDate
            cell.estimatedwasteLb.text = details?.estWt
            cell.imgView?.image = UIImage.init(named:details?.imagePath ?? "")
            cell.satusLb.isHidden = true
            cell.selectionStyle = .none
            //paymentConformation
        } else if tag == 1 {
            let details = tableviewPaymentDatasource?[indexPath.row]
            cell.ticketIdLb.text = details?.ticketID
            cell.locationLb.text = details?.location
            cell.dateLb.text = details?.createdDate
            cell.estimatedwasteLb.text = details?.estWt
            cell.imgView?.image = UIImage.init(named:details?.image1Path ?? "")
            cell.satusLb.text = details?.status
            cell.satusLb.isHidden = false
            cell.selectionStyle = .none
            //concessionerRejected
        } else if tag == 2{
            let details = tableviewDatasource?[indexPath.row]
            cell.ticketIdLb.text = details?.tokenID
            cell.locationLb.text = details?.location
            cell.dateLb.text = details?.createdDate
            cell.estimatedwasteLb.text = details?.estWt
            cell.imgView?.image = UIImage.init(named:details?.imagePath ?? "")
            cell.satusLb.isHidden = false
            cell.selectionStyle = .none
        } else if tag == 3{
            let details = concessionerCloselistTabledatasource?[indexPath.row]
            cell.ticketIdLb.text = details?.ticketID
            cell.locationLb.text = details?.location
            cell.dateLb.text = details?.ticketClosedDate
          //  cell.estimatedwasteLb.text = details?.e
           // cell.imgView?.image = UIImage.init(named:details?.i ?? "")
            cell.satusLb.isHidden = false
            cell.selectionStyle = .none
        } else if tag == 4{
            let details = amohClosedlistTableviewdatasource?[indexPath.row]
            cell.ticketIdLb.text = details?.ticketID
            cell.locationLb.text = details?.location
            cell.dateLb.text = details?.ticketClosedDate
          //  cell.estimatedwasteLb.text = details?.e
           // cell.imgView?.image = UIImage.init(named:details?.im ?? "")
            cell.satusLb.isHidden = false
            cell.selectionStyle = .none
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        switch tag {
        case 0:
            let details = tableviewnoofReqDatasource?[indexPath.row]
            guard let ticketIdLb = details?.tokenID else { return  }
            getRequestDetailsWS(ticketID: ticketIdLb)
        case 1:
            let details = tableviewPaymentDatasource?[indexPath.row]
            let vc = storyboards.AMOH.instance.instantiateViewController(withIdentifier: "ForwordtoConcessioner")as! ForwordtoConcessioner
            vc.ticketDetails = details
//            vc.tag = 1
            // print(ticketIdLb)
            self.navigationController?.pushViewController(vc, animated:true)
        case 2:
            let details = tableviewDatasource?[indexPath.row]
            let vc = storyboards.AMOH.instance.instantiateViewController(withIdentifier: "ConcessionerRejcetorassignTicketVC")as! ConcessionerRejcetorassignTicketVC
            vc.ticketDetails = details
            // print(ticketIdLb)
            self.navigationController?.pushViewController(vc, animated:true)
        case 3: //ConcessionerCloseTicketDetails
             let details = concessionerCloselistTabledatasource?[indexPath.row]
            let vc = storyboards.AMOH.instance.instantiateViewController(withIdentifier: "ConcessionerCloseTicketDetailsVc")as! ConcessionerCloseTicketDetailsVc
            vc.tag = 0
            vc.ticketDetails = details
            // print(ticketIdLb)
            self.navigationController?.pushViewController(vc, animated:true)
        case 4: //amohCloseTicketDetails
             let amohdetails = amohClosedlistTableviewdatasource?[indexPath.row]
            let vc = storyboards.AMOH.instance.instantiateViewController(withIdentifier: "ConcessionerCloseTicketDetailsVc")as! ConcessionerCloseTicketDetailsVc
            vc.tag = 1
            vc.amohDetails = amohdetails
            // print(ticketIdLb)
            self.navigationController?.pushViewController(vc, animated:true)
        default:
            break
        }
        
       // print(ticketIdLb)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchString = searchText
        if searchText == ""{
            switch tag {
            case 0:
                self.tableviewnoofReqDatasource = self.requestListModel?.amohList
            case 1:
                self.tableviewPaymentDatasource = self.paymentComformListModel?.paidList
            case 2:
                self.tableviewDatasource = self.rejectListModel?.ticketsList
            default:
                break
            }
        } else{
            if searchString != "", searchString.count > 0 {
                if tag == 0 {
                    self.tableviewnoofReqDatasource = self.requestListModel?.amohList?.filter {
                        return $0.tokenID?.range(of: searchString, options: .caseInsensitive) != nil
                    }
                }else if tag == 1 {
                    self.tableviewPaymentDatasource = self.paymentComformListModel?.paidList?.filter {
                        return $0.ticketID?.range(of: searchString, options: .caseInsensitive) != nil
                    }
                } else if tag == 2{
                    self.tableviewDatasource = self.rejectListModel?.ticketsList?.filter {
                        return $0.tokenID?.range(of: searchString, options: .caseInsensitive) != nil
                    }
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
// MARK: - RequestListStruct
struct ConcessionerRejectListStruct: Codable {
    let statusCode, statusMessage: String?
    let ticketsList: [TicketList]?

    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
        case ticketsList = "TicketList"
    }
    // MARK: - Encode/decode helpers
    class TicketList: Codable {
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


// MARK: - GetPaidListStruct
struct GetPaidListStruct: Codable {
    let statusCode, statusMessage: String?
    let paidList: [PaidList]?

    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
        case paidList = "PaidList"
    }
    // MARK: - PaidList
    struct PaidList: Codable {
        let ticketID, location, createdDate, estWt: String?
        let paymentStatus, wardID, wardName, circleID: String?
        let circleName, zoneID, zoneName, landmark: String?
        let vehicleType,vehicletypeId: String?
        let image1Path: String?
        let noOfVehicles, status: String?

        enum CodingKeys: String, CodingKey {
            case ticketID = "TICKET_ID"
            case location = "LOCATION"
            case createdDate = "CREATED_DATE"
            case estWt = "EST_WT"
            case paymentStatus = "PAYMENT_STATUS"
            case wardID = "WARD_ID"
            case wardName = "WARD_NAME"
            case circleID = "CIRCLE_ID"
            case circleName = "CIRCLE_NAME"
            case zoneID = "ZONE_ID"
            case zoneName = "ZONE_NAME"
            case landmark = "LANDMARK"
            case vehicleType = "VEHICLE_TYPE"
            case image1Path = "IMAGE1_PATH"
            case noOfVehicles = "NO_OF_VEHICLES"
            case status = "STATUS"
            case vehicletypeId = "VEHICLE_TYPE_ID"
        }
    }
}

// MARK: - AmohconcessionerClosedListStruct
struct AmohconcessionerClosedListStruct: Codable {
    let statusCode, statusMessage: String?
    let ticketList: [TicketList]?

    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
        case ticketList = "TicketList"
    }
    
    // MARK: - TicketList
    struct TicketList: Codable {
        let ticketID, location, ticketRaisedDate, ticketClosedDate: String?
        let zoneID: String?
        let zoneName: String?
        let circleID: String?
        let circleName: String?
        let wardID: String?
        let wardName, concessionerName: String?
        let typeOfWaste: String?
        let status: String?
        let listVehicles: [ListVehicle]?

        enum CodingKeys: String, CodingKey {
            case ticketID = "TICKET_ID"
            case location = "LOCATION"
            case ticketRaisedDate = "TICKET_RAISED_DATE"
            case ticketClosedDate = "TICKET_CLOSED_DATE"
            case zoneID = "ZONE_ID"
            case zoneName = "ZONE_NAME"
            case circleID = "CIRCLE_ID"
            case circleName = "CIRCLE_NAME"
            case wardID = "WARD_ID"
            case wardName = "WARD_NAME"
            case concessionerName = "CONCESSIONER_NAME"
            case typeOfWaste = "TYPE_OF_WASTE"
            case status = "STATUS"
            case listVehicles
        }
    }
    
    // MARK: - ListVehicle
    struct ListVehicle: Codable {
        let vehicleNo, vehicleID: String?

        enum CodingKeys: String, CodingKey {
            case vehicleNo = "VEHICLE_NO"
            case vehicleID = "VEHICLE_ID"
        }
    }


}


// MARK: - AmohClosedListStruct
struct AmohClosedListStruct: Codable {
    let statusCode, statusMessage: String?
    let ticketList: [TicketList]?

    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
        case ticketList = "TicketList"
    }
    // MARK: - TicketList
    struct TicketList: Codable {
        let ticketID, location, ticketRaisedDate, ticketClosedDate: String?
        let zoneID: String?
        let zoneName: String?
        let circleID: String?
        let circleName: String?
        let wardID: String?
        let wardName, concessionerName: String?
        let typeOfWaste: String?
        let status: String?
        let listVehicles: [ListVehicle]?

        enum CodingKeys: String, CodingKey {
            case ticketID = "TICKET_ID"
            case location = "LOCATION"
            case ticketRaisedDate = "TICKET_RAISED_DATE"
            case ticketClosedDate = "TICKET_CLOSED_DATE"
            case zoneID = "ZONE_ID"
            case zoneName = "ZONE_NAME"
            case circleID = "CIRCLE_ID"
            case circleName = "CIRCLE_NAME"
            case wardID = "WARD_ID"
            case wardName = "WARD_NAME"
            case concessionerName = "CONCESSIONER_NAME"
            case typeOfWaste = "TYPE_OF_WASTE"
            case status = "STATUS"
            case listVehicles
        }
    }
    
    // MARK: - ListVehicle
    struct ListVehicle: Codable {
        let vehicleNo, vehicleID: String?

        enum CodingKeys: String, CodingKey {
            case vehicleNo = "VEHICLE_NO"
            case vehicleID = "VEHICLE_ID"
        }
    }
}

