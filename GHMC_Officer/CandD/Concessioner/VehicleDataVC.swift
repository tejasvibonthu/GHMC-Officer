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
    @IBOutlet weak var vehicleType: UIButton!
    @IBOutlet weak var noofvehiclesLb: UITextField!
    @IBOutlet weak var estimationWasteLb: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var vehicledatamodel:GetVehicledataStruct?
    var dropdown = DropDown()
    var vehicledatasourceArry:[String] = []
    var vehicleId:String?
    var noofTons:Int?
    var weight:String?
    var vehiclesCount:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        noofvehiclesLb.delegate = self
        estimationWasteLb.isHidden = true
        tableView.isHidden = true
        tableView.separatorStyle =  .none
        self.getVehiclesDataWS()
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if noofvehiclesLb.text != "" {
            vehiclesCount = noofvehiclesLb.text
        let noofVehicles = Int(noofvehiclesLb.text ?? "")
        let totalCost: Int = noofTons! * noofVehicles!
        self.weight = String(totalCost)
            estimationWasteLb.isHidden = false
            tableView.isHidden = false
            tableView.reloadData()
            estimationWasteLb.text = ("\(weight ?? "0") TONS")
    }
        return true
    }
    @IBAction func vehicleTypeClick(_ sender: UIButton) {
        dropdown.dataSource = vehicledatasourceArry
        dropdown.anchorView = sender
        dropdown.show()
        dropdown.selectionAction = {[unowned self] (index : Int , item : String) in
            //  print("selected index \(index) item \(item)")
            
            sender.setTitle(item, for: .normal)
            vehicleType.setTitleColor(.black, for: .normal)
            self.vehicleId = self.vehicledatamodel?.vehiclelist?[index].vehicleTypeID
            self.dropdown.hide()
            self.noofTons = Int((vehicleType.currentTitle?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())! )
                }
    }

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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return noofvehiclesLb.text?.count ?? 2
      //  print(vehiclesCount?.coun)
         let count = Int(vehiclesCount ?? "")
        return count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VehicledataCell") as! VehicledataCell
    
//        let details = tableviewDatasource?[indexPath.row]
//        cell.ticketIdLb.text = details?.ticketID
//        cell.locationLb.text = details?.location
//        cell.dateLB.text = details?.createdDate
//        cell.estimatedWtLB.text = details?.estWt
//        cell.img?.image = UIImage.init(named:details?.image1Path ?? "")
        
        cell.selectionStyle = .none
        return cell    }
    
}
