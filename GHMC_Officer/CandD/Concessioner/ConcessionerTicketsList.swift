//
//  ConcessionerTicketsList.swift
//  GHMC_Officer
//
//  Created by Haritej on 24/05/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//

import UIKit

class ConcessionerTicketsList: UIViewController ,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navTitle: UILabel!
    var tag:Int?
    var requestListModel:ConcessionerTicketsListStruct?
    var tableviewDatasource:[ConcessionerTicketsListStruct.TicketList]?
    var pickupcapturelistModel:PickupcaptureListStruct?
    var pickuplisttableviewDatasource:[PickupcaptureListStruct.TicketList]?
    var concessionerRejectlistModel:ConcesRejectListStruct?
    var concessionerRejecttableviewDatasource:[ConcesRejectListStruct.TicketList]?
    var concessonerCloseListModel:ConcessionerClosedListStruct?
    var concessionerClosedTableDatasource:[ConcessionerClosedListStruct.TicketList]?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        // Concessionerticketsist
        if tag == 0 {
            self.navTitle.text = "Requests List"
            self.getRequestListWS()
        //pickupcapturelist
        }  else if tag == 1 {
            self.navTitle.text = "Pickup capture List"
            self.getpickupcaptureList()
        }  else if tag == 2 {
            self.navTitle.text = "Rejected List"
            self.getconcessionerRejectList()
        }  else if tag == 3 {
            self.navTitle.text = "Closed List"
            self.getconcessionerClosedList()
        }
    }
    
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func getRequestListWS(){
        let params = ["EMPLOYEE_ID":UserDefaultVars.empId,
                       "DEVICEID":deviceId,
                       "TOKEN_ID":UserDefaultVars.token]
        print(params)
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
        NetworkRequest.makeRequest(type: ConcessionerTicketsListStruct.self, urlRequest: Router.getConcessionerTickets(Parameters: params)) { [weak self](result) in
            switch result
            {
            case .success(let getList):
                print(getList)
                self?.requestListModel = getList
                self?.tableviewDatasource = self?.requestListModel?.ticketList
                if getList.statusCode == "600"{
                    self?.showCustomAlert(message: getList.statusMessage){
                        let vc = storyboards.Main.instance.instantiateViewController(withIdentifier: "LoginViewControllerViewController") as! LoginViewControllerViewController
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                if getList.statusCode == "200"{
                    if getList.ticketList?.isEmpty == true {
                        self?.showAlert(message: "No Records found"){
                            let viewControllers: [UIViewController] = (self?.navigationController!.viewControllers)!
                            for aViewController in viewControllers {
                                if aViewController is ConcessionerDasboardVC {
                                    self?.navigationController!.popToViewController(aViewController, animated: true)
                                }
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                    }
                }
//                else if getList.statusCode == "600"{
//                        self?.showAlert(message:getList.statusMessage)
//                    }
                 else {
                    self?.showCustomAlert(message: getList.statusMessage){
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
    func getpickupcaptureList(){
      let params : [String : Any] = ["EMPLOYEE_ID":UserDefaultVars.empId,
                       "DEVICEID":deviceId,
                       "TOKEN_ID":UserDefaultVars.token!]
        print(params)
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
        NetworkRequest.makeRequest(type: PickupcaptureListStruct.self, urlRequest: Router.getPickupCaptureTickets(Parameters: params)) { [weak self](result) in
            switch result
            {
            case .success(let getList):
               // print(getList)
                self?.pickupcapturelistModel = getList
                self?.pickuplisttableviewDatasource = self?.pickupcapturelistModel?.ticketList
                if  getList.statusCode == "600"{
                    self?.showAlert(message: getList.statusMessage ?? ""){
                        let vc = storyboards.Main.instance.instantiateViewController(withIdentifier: "LoginViewControllerViewController") as! LoginViewControllerViewController
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                if getList.statusCode == "200"{
                    if getList.ticketList?.isEmpty == true {
                        self?.showAlert(message: "No Records found"){
                            let viewControllers: [UIViewController] = (self?.navigationController!.viewControllers)!
                            for aViewController in viewControllers {
                                if aViewController is ConcessionerDasboardVC {
                                    self?.navigationController!.popToViewController(aViewController, animated: true)
                                }
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                    }
                }
//                else if getList.statusCode == "600"{
//                        self?.showAlert(message:getList.statusMessage)
//                    }
                 else {
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
    func getconcessionerRejectList(){
        let params = ["CONC_EMP_ID": UserDefaultVars.empId,
                      "DEVICEID": deviceId,
                      "TOKEN_ID": UserDefaultVars.token
        ]
      //print(params)
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
        NetworkRequest.makeRequest(type: ConcesRejectListStruct.self, urlRequest: Router.getConcesRejectList(Parameters: params)) { [weak self](result) in
            switch result
            {
            case .success(let getList):
              //  print(getList)
                self?.concessionerRejectlistModel = getList
                self?.concessionerRejecttableviewDatasource = self?.concessionerRejectlistModel?.ticketList
                if getList.statusCode == "600"{
                    self?.showAlert(message: getList.statusMessage ?? ""){
                        let vc = storyboards.Main.instance.instantiateViewController(withIdentifier: "LoginViewControllerViewController") as! LoginViewControllerViewController
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                if getList.statusCode == "200"{
                    if getList.ticketList?.isEmpty == true {
                        self?.showAlert(message: "No Records found"){
                            let viewControllers: [UIViewController] = (self?.navigationController!.viewControllers)!
                            for aViewController in viewControllers {
                                if aViewController is ConcessionerDasboardVC {
                                    self?.navigationController!.popToViewController(aViewController, animated: true)
                                }
                            }
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
    func getconcessionerClosedList(){
        let params = ["CONC_EMP_ID": UserDefaultVars.empId,
                      "DEVICEID": deviceId,
                      "TOKEN_ID": UserDefaultVars.token
        ]
      //print(params)
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
        NetworkRequest.makeRequest(type: ConcessionerClosedListStruct.self, urlRequest: Router.getConcClosedList(Parameters: params)) { [weak self](result) in
            switch result
            {
            case .success(let getList):
              //  print(getList)
                self?.concessonerCloseListModel = getList
                self?.concessionerClosedTableDatasource = self?.concessonerCloseListModel?.ticketList
                if getList.statusCode == "600"{
                    self?.showAlert(message: getList.statusMessage ?? ""){
                        let vc = storyboards.Main.instance.instantiateViewController(withIdentifier: "LoginViewControllerViewController") as! LoginViewControllerViewController
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                if getList.statusCode == "200"{
                    if getList.ticketList?.isEmpty == true {
                        self?.showAlert(message: "No Records found"){
                            let viewControllers: [UIViewController] = (self?.navigationController!.viewControllers)!
                            for aViewController in viewControllers {
                                if aViewController is ConcessionerDasboardVC {
                                    self?.navigationController!.popToViewController(aViewController, animated: true)
                                }
                            }
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
                    self?.showCustomAlert(message: serverNotResponding){
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tag == 0{
            return  tableviewDatasource?.count ?? 0
        } else if tag == 1{
            return pickuplisttableviewDatasource?.count ?? 0
        } else if tag == 2
        {
            return concessionerRejecttableviewDatasource?.count ?? 0
        } else if tag == 3
        {
            return concessionerClosedTableDatasource?.count ?? 0
        }
        return  0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConcessionerTicketscell") as! ConcessionerTicketscell
        if tag == 0 {
            let details = tableviewDatasource?[indexPath.row]
            cell.ticketIdLb.text = details?.ticketID
            cell.locationLb.text = details?.location
            cell.dateLB.text = details?.createdDate
            cell.estimatedWtLB.text = details?.estWt
            cell.img?.sd_setImage(with: URL(string:details?.image1Path  ?? ""), placeholderImage: UIImage(named: "noi"))
        } else if tag == 1{
            let details = pickuplisttableviewDatasource?[indexPath.row]
            cell.ticketIdLb.text = details?.ticketID
            cell.locationLb.text = details?.location
            cell.dateLB.text = details?.createdDate
            cell.estimatedWtLB.text = details?.estWt
            cell.img?.sd_setImage(with: URL(string:details?.image1Path  ?? ""), placeholderImage: UIImage(named: "noi"))
        } else if tag == 2{
            let details = concessionerRejecttableviewDatasource?[indexPath.row]
            cell.ticketIdLb.text = details?.ticketID
            cell.locationLb.text = details?.location
            cell.dateLB.text = details?.createdDate
            cell.img?.sd_setImage(with: URL(string:details?.image1Path  ?? ""), placeholderImage: UIImage(named: "noi"))
        } else if tag == 3{
            let details = concessionerClosedTableDatasource?[indexPath.row]
            cell.ticketIdLb.text = details?.ticketID
            cell.locationLb.text = details?.location
            cell.dateLB.text = details?.ticketClosedDate
            
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        let details = tableviewDatasource?[indexPath.row]
        if tag == 0 {
            let vc = storyboards.Concessioner.instance.instantiateViewController(withIdentifier:"ConcessionerRequest") as! ConcessionerRequest
            vc.date = details?.createdDate
            vc.zone = details?.zoneName
            vc.circle = details?.circleName
            vc.ward = details?.wardName
            vc.location = details?.location
            vc.grievanceId = details?.ticketID
            vc.imgIs = details?.image1Path
            self.navigationController?.pushViewController(vc, animated:true)
        } else if tag == 1 {
            let vc = storyboards.Concessioner.instance.instantiateViewController(withIdentifier:"ConcessionerpickupCaptureVC") as! ConcessionerpickupCaptureVC
          vc.ticketData = pickupcapturelistModel?.ticketList?[indexPath.row]
          self.navigationController?.pushViewController(vc, animated:true)
        }
        // print(ticketIdLb)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchString = searchText
        if searchText == ""{
            switch tag {
            case 0:
                self.tableviewDatasource = self.requestListModel?.ticketList
            case 1:
                self.pickuplisttableviewDatasource = self.pickupcapturelistModel?.ticketList
            case 2:
                self.concessionerRejecttableviewDatasource = self.concessionerRejectlistModel?.ticketList
            case 3:
                self.concessionerClosedTableDatasource = self.concessonerCloseListModel?.ticketList
            default:
                print("")
            }
        } else{
            if searchString != "", searchString.count > 0 {
                switch tag {
                case 0:
                    self.tableviewDatasource = self.requestListModel?.ticketList?.filter {
                        return $0.ticketID.range(of: searchString, options: .caseInsensitive) != nil
                    }
                case 1:
                    self.pickuplisttableviewDatasource = self.pickupcapturelistModel?.ticketList?.filter {
                        return $0.ticketID?.range(of: searchString, options: .caseInsensitive) != nil
                    }
                case 2:
                    self.concessionerRejecttableviewDatasource = self.concessionerRejectlistModel?.ticketList?.filter {
                        return $0.ticketID?.range(of: searchString, options: .caseInsensitive) != nil
                    }
                case 3:
                    self.concessionerClosedTableDatasource = self.concessonerCloseListModel?.ticketList?.filter {
                        return $0.ticketID?.range(of: searchString, options: .caseInsensitive) != nil
                    }
                default:
                    print("")
                }
               
            }
        }
        tableView.reloadData()
    }
}
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let concessionerTicketsListStruct = try? newJSONDecoder().decode(ConcessionerTicketsListStruct.self, from: jsonData)

import Foundation
// MARK: - ConcessionerTicketsListStruct
struct ConcessionerTicketsListStruct: Codable {
    let statusCode, statusMessage: String
    let ticketList: [TicketList]?

    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
        case ticketList = "TicketList"
    }
    // MARK: - TicketList
    struct TicketList: Codable {
        let ticketID, location, createdDate, estWt: String
        let paymentStatus, wardID, wardName, circleID: String
        let circleName, zoneID, zoneName, landmark: String
        let vehicleType: String
        let image1Path: String
        let noOfVehicles, status: String

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
        }
    }

}

// MARK: - PickupcaptureListStruct
struct PickupcaptureListStruct: Codable {
    let statusCode, statusMessage: String?
    let ticketList: [TicketList]?

    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
        case ticketList = "TicketList"
    }
    // MARK: - TicketList
    struct TicketList: Codable {
        let ticketID, location, createdDate, estWt: String?
        let paymentStatus: String?
        let wardID, wardName, circleID, circleName: String?
        let zoneID, zoneName: String?
        let landmark: String?
        let vehicleType, image1Path, noOfVehicles, status: String?
        let listVehicles: [ListVehicle]?

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
            case listVehicles
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
}



// MARK: - ConcessionerRejectListStruct
struct ConcesRejectListStruct: Codable {
    let statusCode, statusMessage: String?
    let ticketList: [TicketList]?

    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
        case ticketList = "TicketList"
    }
    // MARK: - TicketList
    struct TicketList: Codable {
        let ticketID, location, createdDate, reasonForReject: String?
        let paymentStatus, wardID, wardName, circleID: String?
        let circleName, zoneID, zoneName, landmark: String?
        let image1Path: String?
        let status: String?

        enum CodingKeys: String, CodingKey {
            case ticketID = "TICKET_ID"
            case location = "LOCATION"
            case createdDate = "CREATED_DATE"
            case reasonForReject = "REASON_FOR_REJECT"
            case paymentStatus = "PAYMENT_STATUS"
            case wardID = "WARD_ID"
            case wardName = "WARD_NAME"
            case circleID = "CIRCLE_ID"
            case circleName = "CIRCLE_NAME"
            case zoneID = "ZONE_ID"
            case zoneName = "ZONE_NAME"
            case landmark = "LANDMARK"
            case image1Path = "IMAGE1_PATH"
            case status = "STATUS"
        }
    }
}


// MARK: - ConcessionerClosedListStruct
struct ConcessionerClosedListStruct: Codable {
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
}



// MARK: - ListVehicle
struct ListVehicle: Codable {
    let vehicleNo, vehicleID: String?

    enum CodingKeys: String, CodingKey {
        case vehicleNo = "VEHICLE_NO"
        case vehicleID = "VEHICLE_ID"
    }
}





