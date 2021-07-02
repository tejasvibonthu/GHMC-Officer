//
//  VehicleDataVC.swift
//  GHMC_Officer
//
//  Created by Haritej on 28/05/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//

import UIKit
import DropDown

class VehicleDataVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    @IBOutlet weak var submitBtnTop: NSLayoutConstraint!
    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var noofvehiclesLb: UITextField!
    @IBOutlet weak var estimationWasteLb: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var amountTF: UITextField!
    var tableViewDataSource : [VehicleData]?
    var grievanceId:String?
    var table1Data:[String]?
    var noofTons : Int = 0
    var imgData:String?
    var amount:String?
    {
        didSet
        {
            estimationWasteLb.text = "Estimation Weight(tons) :  \(noofTons)"
        }
    }

    @IBOutlet weak var camImg: CustomImagePicker!
    {
        didSet
        {
            camImg.parentViewController = self
        }
    }
    var vehicledatamodel:GetVehicledataStruct?
    var dropdown = DropDown()
    var vehicledatasourceArry:[String] = []
    var weight:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        noofvehiclesLb.delegate = self
       // estimationWasteLb.isHidden = true
        tableView.isHidden = true
        tableView.separatorStyle =  .none
        self.getVehiclesDataWS()
    }
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Selector Funcs
    @objc func vehicleTypeClick(sender:UIButton){
        dropdown.dataSource = vehicledatasourceArry
        dropdown.anchorView = sender
        dropdown.show()
        dropdown.selectionAction = {[unowned self] (index : Int , item : String) in
            //  print("selected index \(index) item \(item)")
            tableViewDataSource?[sender.tag].vehicleType = item
            sender.setTitle(item, for: .normal)
            let vehicleId = self.vehicledatamodel?.vehiclelist?[index].vehicleTypeID
            tableViewDataSource?[sender.tag].vehicleId = vehicleId ?? ""
            let totalNoofVehicles : Int = tableViewDataSource?.count ?? 0
            tableViewDataSource?[sender.tag].tons =  totalNoofVehicles * Int((item.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()))!
            self.noofTons = tableViewDataSource!.map({$0.tons}).reduce(0, +)
            self.dropdown.hide()
           
            self.calculateAmountWS()
        }
    }
    @objc func vehicleNoDidEndEditing(textField: UITextField)
    {
        let tag = textField.tag
      //  print(textField.text)
        tableViewDataSource?[tag].vehicleNo = textField.text ?? ""
    }
    @objc func driverNameDidEndEditing(textField: UITextField)
    {
        let tag = textField.tag
      //  print(textField.text)
        tableViewDataSource?[tag].driverName = textField.text ?? ""
        
    }
    
    @objc func mobileNoDidEndEditing(textField: UITextField)
    {
        let tag = textField.tag
     //   print(textField.text)
        tableViewDataSource?[tag].mobileNo = textField.text ?? ""
    }
    
    @objc func noOfTripsDidEndEditing(textField: UITextField)
    {
        let tag = textField.tag
      //  print(textField.text)
        tableViewDataSource?[tag].noofTrips = textField.text ?? ""
    }
    func validation() -> Bool
    {
        if  noofvehiclesLb.text == "" {
            showAlert(message: "Please enter no of vehicles")
            return false
        }
        else if camImg.isImagePicked == false {
            showAlert(message: "Please capture photo")
            return false
        }
        else {
        guard let dataSource = tableViewDataSource else {return false}
        for (index,item) in dataSource.enumerated()
        {
            if item.vehicleNo.count == 0
            {
                self.showAlert(message: "Please Enter vehicleNo")
                tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: true)
                return false
            } else if item.vehicleType == "Select"
            {
                self.showAlert(message: "Please Enter vehicleType")
                tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: true)
                return false
            }
            else if item.driverName.count == 0 {
                self.showAlert(message: "Please Enter Driver Name")
                tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: true)
                return false
            }
            else if item.mobileNo.count == 0 {
                self.showAlert(message: "Please Enter Mobile no")
                tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: true)
                return false
                
            }
            else if item.mobileNo.count < 10 {
                self.showAlert(message: "Please Enter Mobile no")
                tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: true)
                return false
                
            }
            else if item.noofTrips.count == 0{
                self.showAlert(message: "Please Enter no of trips")
                tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: true)
                return false
            }
        }
    }
        
        return true
    }
    //MARK:- Service Call
    func getVehiclesDataWS()
    {
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message:noInternet);return}
        NetworkRequest.makeRequest(type: GetVehicledataStruct.self, urlRequest: Router.getVehicleData) { [weak self](result) in
            switch result
            {
            case  .success(let vehicledata):
              //  print(vehicledata)
                if vehicledata.statusCode == "200"{
                    self?.vehicledatamodel = vehicledata
                    self?.vehicledatamodel?.vehiclelist?.forEach({self?.vehicledatasourceArry.append($0.vehicleType ?? "")})
                }
                 else{
                 self?.showAlert(message: vehicledata.statusMessage ?? "")
             }
            case .failure(let err):
                print(err)
                self?.showAlert(message: serverNotResponding)
            }
        }
    }
        func calculateAmountWS(){
            let params = ["EST_WT": self.noofTons]
            guard Reachability.isConnectedToNetwork() else {self.showAlert(message:noInternet);return}
            NetworkRequest.makeRequest(type: CalculateAmountStruct.self, urlRequest: Router.calculateAmountbyTons(Parameters: params)) { [weak self](result) in
                switch result
                {
                case  .success(let CalData):
                    if CalData.statusCode == "200"{
                        self?.amount = CalData.cndwAmount ?? ""
                    }
                    else{
                        self?.showAlert(message: CalData.statusMessage ?? "")
                    }
                case .failure(let err):
                    print(err)
                    self?.showAlert(message: serverNotResponding)
                }
            }
        }
    
    func submitWS(){
        imgData = convertImageToBase64String(img: camImg.image!)
        var vehicleDetials : [[String : Any]] = [[:]]
        for item in tableViewDataSource!
        {
           let param = [
            "VEHICLE_NO": item.vehicleNo,
                "DRIVER_NAME": item.vehicleNo,
                "MOBILE_NUMBER":item.vehicleNo,
                "NO_OF_TRIPS":item.vehicleNo,
            "VEHICLE_TYPE_ID": item.vehicleId ,
          ]
            vehicleDetials.append(param)
        }
        vehicleDetials.remove(at: 0)
        let params = [
            "CNDW_GRIEVANCE_ID": grievanceId ?? "",
            "EMPLOYEE_ID": UserDefaultVars.empId,
            "DEVICEID": deviceId,
            "TOKEN_ID": UserDefaultVars.token,
           "IMAGE1_PATH": "",
            "NO_OF_VEHICLES": noofvehiclesLb.text ?? "",
            "EST_WT": String(noofTons),
            "AMOUNT": self.amount ?? "",
            "ISACCEPT":"Y",
            "REASON_FOR_REJECT":"",
           "VEHICLE_DETAILS": vehicleDetials
                    
        ] as [String : Any]
        print(params)
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message:noInternet);return}
        NetworkRequest.makeRequest(type: SUbmitStruct.self, urlRequest: Router.submitConcessionerReq(Parameters: params)) { [weak self](result) in
                switch result {
                case .success(let resp):
                    print(resp)
                    if resp.statusCode == "200"
                    {
                        self?.showAlert(message: resp.statusMessage ?? ""){
                           let vc = storyboards.Concessioner.instance.instantiateViewController(withIdentifier:"ConcessionerTicketsList") as! ConcessionerTicketsList
                            vc.tag = 0
                            self?.navigationController?.pushViewController(vc, animated:true)
                        }
                    }
                    else
                    {
                        self?.showAlert(message: resp.statusMessage ?? "" )
                    }
                case .failure(let err):
                    print(err)
                    self?.showAlert(message: err.localizedDescription)
                }
            }
        }
    //MARK:- Textfield delegate
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if noofvehiclesLb.text != "" {
            guard let vehicleCount = Int(noofvehiclesLb.text!) else {tableViewDataSource = nil;tableView.reloadData();return true}
            tableViewDataSource = [VehicleData](repeating: VehicleData(vehicleNo: "",vehicleType: "Select", driverName: "",mobileNo: "",noofTrips: "",vehicleId: "",tons: 0), count: vehicleCount)
            tableView.isHidden = false
            tableView.reloadData()
        }
        return true
    }

    
    //MARK:- Tableview Delegate & Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataSource?.count ?? 0
     
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VehicledataCell") as! VehicledataCell
        
        let item = tableViewDataSource?[indexPath.row]
        cell.vehicleNoTf.tag = indexPath.row
        cell.vehicleNoTf.addTarget(self, action: #selector(vehicleNoDidEndEditing(textField:)), for: .editingDidEnd)
        cell.driverNameTf.tag = indexPath.row
        cell.driverNameTf.addTarget(self, action: #selector(driverNameDidEndEditing(textField:)), for: .editingDidEnd)
        cell.mobileNameTf.tag = indexPath.row
        cell.mobileNameTf.addTarget(self, action: #selector(mobileNoDidEndEditing(textField:)), for: .editingDidEnd)
        cell.nooftripsTf.tag = indexPath.row
        cell.nooftripsTf.addTarget(self, action: #selector(noOfTripsDidEndEditing(textField:)), for: .editingDidEnd)
        cell.vehicleType.tag = indexPath.row
        cell.vehicleType.addTarget(self, action:#selector(vehicleTypeClick), for: .touchUpInside)
        
        cell.vehicleNoTf.text = item?.vehicleNo
        cell.driverNameTf.text = item?.driverName
       // cell.mobileNameTf.text = item?.mobile
        
        cell.vehicleType.setTitleColor(.black, for: .normal)
        if #available(iOS 13.0, *) {
            cell.vehicleType.layer.borderColor = UIColor.systemGray2.cgColor
        } else {
            // Fallback on earlier versions
            cell.vehicleType.layer.borderColor = UIColor.gray.cgColor
        }
        cell.vehicleType.layer.borderWidth = 0.5
        cell.vehicleType.layer.cornerRadius = 4
        
        cell.selectionStyle = .none
        return cell
        
    }

    @IBAction func submitClick(_ sender: Any) {
        guard validation() else {return}
        self.submitWS()
    }
}
struct VehicleData {
    var vehicleNo : String
    var vehicleType : String
    var driverName : String
    var mobileNo : String
    var noofTrips : String
    var vehicleId :String
    var tons : Int
}
