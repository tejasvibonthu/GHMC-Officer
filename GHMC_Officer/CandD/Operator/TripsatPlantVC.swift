//
//  TripsatPlantVC.swift
//  GHMC_Officer
//
//  Created by Haritej on 27/06/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//

import UIKit

class TripsatPlantVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var requestListModel:ConcessionerTicketsListStruct?
    var tableviewDatasource:[ConcessionerTicketsListStruct.TicketList]?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
       // self.getTripsListWS()
    }
    
    @IBAction func backClick(_ sender: Any) {
        
    }
    
    func getTripsListWS() {
       let params = ["EMPLOYEE_ID":"942",
                       "DEVICEID":deviceId,
                       "TOKEN_ID":UserDefaultVars.token
        ]
        print(params)
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
                else if getList.statusCode == "600"{
                        self?.showAlert(message:getList.statusMessage){
                            let vc = storyboards.Main.instance.instantiateViewController(withIdentifier: "LoginViewControllerViewController") as! LoginViewControllerViewController
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripsCell") as! TripsCell
        let details = tableviewDatasource?[indexPath.row]
        cell.vehicleNumLb.text = details?.ticketID
        cell.typeofVehicleLb.text = details?.location
        cell.driverNameLb.text = details?.createdDate
        cell.mobileNumberLb.text = details?.estWt
        cell.supervisorNoLB.text = details?.estWt
        cell.supervisorNameLb.text = details?.estWt
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
      //  let details = tableviewDatasource?[indexPath.row]

        let vc = storyboards.Operator.instance.instantiateViewController(withIdentifier:"PickupSlipDetailsVC") as! PickupSlipDetailsVC
//        vc.date = details?.createdDate
//        vc.zone = details?.zoneName
//        vc.circle = details?.circleName
//        vc.ward = details?.wardName
//        vc.location = details?.location
//        vc.grievanceId = details?.ticketID
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
