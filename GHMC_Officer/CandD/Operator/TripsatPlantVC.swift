import UIKit
class TripsatPlantVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var requestListModel:GetTripsatPlantStruct?
    var tableviewDatasource:[GetTripsatPlantStruct.OperatorVehicleList]?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        self.getTripsListWS()
    }
    @IBAction func logoutClick(_ sender: Any) {
        let vc = storyboards.Main.instance.instantiateViewController(withIdentifier: "LoginViewControllerViewController") as! LoginViewControllerViewController
        UserDefaults.standard.removeObject(forKey:"mpin")
        UserDefaults.standard.synchronize()
        let navVc = UINavigationController(rootViewController: vc)
        self.view.window?.rootViewController = navVc
        self.view.window?.makeKeyAndVisible()
    }
    func getTripsListWS() {
        let params = ["EMPLOYEE_ID":UserDefaultVars.empId,
                       "DEVICEID":deviceId,
                       "TOKEN_ID":UserDefaultVars.token
        ]
        print(params)
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
        NetworkRequest.makeRequest(type: GetTripsatPlantStruct.self, urlRequest: Router.gettripsAtPlant(Parameters: params)) { [weak self](result) in
            switch result
            {
            case .success(let getList):
                print(getList)
                self?.requestListModel = getList
                self?.tableviewDatasource = self?.requestListModel?.operatorVehicleList
                if getList.statusCode == "200"{
                    if getList.operatorVehicleList?.isEmpty == true {
                        self?.showAlert(message: "No Records found")
                    } else {
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                    }
                }
                else if getList.statusCode == "600"{
                    self?.showAlert(message:getList.statusMessage ?? ""){
                            let vc = storyboards.Main.instance.instantiateViewController(withIdentifier: "LoginViewControllerViewController") as! LoginViewControllerViewController
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
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
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableviewDatasource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripsCell") as! TripsCell
        let details = tableviewDatasource?[indexPath.row]
        cell.vehicleNumLb.text = details?.vehicleNumber
        cell.typeofVehicleLb.text = details?.vehicleType
        cell.driverNameLb.text = details?.driverName
        cell.mobileNumberLb.text = details?.driverMobileNumber
        cell.supervisorNoLB.text = details?.supervisorName
        cell.supervisorNameLb.text = details?.supervisorName
        cell.ticketIdLb.text = details?.cndwGrievancesID
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        let details = tableviewDatasource?[indexPath.row]
        let vc = storyboards.Operator.instance.instantiateViewController(withIdentifier:"PickupSlipDetailsVC") as! PickupSlipDetailsVC
        vc.tripDetails = details
        self.navigationController?.pushViewController(vc, animated:true)
        // print(ticketIdLb)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchString = searchText
        if searchText == ""{
            self.tableviewDatasource = self.requestListModel?.operatorVehicleList
        } else{
            if searchString != "", searchString.count > 0 {
                self.tableviewDatasource = self.requestListModel?.operatorVehicleList?.filter {
                    return $0.cndwGrievancesID?.range(of: searchString, options: .caseInsensitive) != nil
                }
            }
        }
        tableView.reloadData()
    }

}

// MARK: - GetTripsatPlantStruct
struct GetTripsatPlantStruct: Codable {
    let statusCode, statusMessage: String?
    let operatorVehicleList: [OperatorVehicleList]?

    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
        case operatorVehicleList = "OperatorVehicleList"
    }
    // MARK: - OperatorVehicleList
    struct OperatorVehicleList: Codable {
        let cndwGrievancesID, vehicleNumber, vehicleTypeID, driverName: String?
        let driverMobileNumber, supervisorNumber, supervisorName: String?
        let zone ,ward ,circle , vehicleType:String?

        enum CodingKeys: String, CodingKey {
            case cndwGrievancesID = "CNDW_GRIEVANCES_ID"
            case vehicleNumber = "VEHICLE_NUMBER"
            case vehicleTypeID = "VEHICLE_TYPE_ID"
            case driverName = "DRIVER_NAME"
            case driverMobileNumber = "DRIVER_MOBILE_NUMBER"
            case supervisorNumber = "SUPERVISOR_NUMBER"
            case supervisorName = "SUPERVISOR_NAME"
            case zone = "ZONE"
            case circle = "CIRCLE"
            case ward = "WARD"
            case vehicleType = "VEHICLE_TYPE"
        }
    }
}


