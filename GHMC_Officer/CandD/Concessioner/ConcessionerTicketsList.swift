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
    var requestListModel:ConcessionerTicketsListStruct?
    var tableviewDatasource:[ConcessionerTicketsListStruct.TicketList]?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        self.getRequestListWS()
    }
    func getRequestListWS(){
       let params = ["EMPLOYEE_ID":"869",
                       "DEVICEID":deviceId,
                       "TOKEN_ID":UserDefaultVars.token
        ]
      //  print(params)
        
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
        NetworkRequest.makeRequest(type: ConcessionerTicketsListStruct.self, urlRequest: Router.getConcessionerTickets(Parameters: params)) { [weak self](result) in
            switch result
            {
            case .success(let getList):
                print(getList)
                self?.requestListModel = getList
                self?.tableviewDatasource = self?.requestListModel?.ticketList
                if getList.statusCode == "200"{
                    if getList.ticketList?.isEmpty == true {
                        self?.showAlert(message: "No Records found")
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableviewDatasource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConcessionerTicketscell") as! ConcessionerTicketscell
        let details = tableviewDatasource?[indexPath.row]
        cell.ticketIdLb.text = details?.ticketID
        cell.locationLb.text = details?.location
        cell.dateLB.text = details?.createdDate
        cell.estimatedWtLB.text = details?.estWt
        cell.img?.image = UIImage.init(named:details?.image1Path ?? "")
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        let details = tableviewDatasource?[indexPath.row]

        let vc = storyboards.Concessioner.instance.instantiateViewController(withIdentifier:"ConcessionerRequest") as! ConcessionerRequest
        vc.date = details?.createdDate
        vc.zone = details?.zoneName
        vc.circle = details?.circleName
        vc.ward = details?.wardName
        vc.location = details?.location
        vc.grievanceId = details?.ticketID
        self.navigationController?.pushViewController(vc, animated:true)
        // print(ticketIdLb)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchString = searchText
        if searchText == ""{
            self.tableviewDatasource = self.requestListModel?.ticketList
        } else{
            if searchString != "", searchString.count > 0 {
                self.tableviewDatasource = self.requestListModel?.ticketList?.filter {
                    return $0.ticketID.range(of: searchString, options: .caseInsensitive) != nil
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



