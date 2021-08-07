//
//  VehicledataEntryVC.swift
//  GHMC_Officer
//
//  Created by deep chandan on 07/08/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//

import UIKit
import DropDown
protocol VehicleDataProtocol {
    func vehicleDetails(vehicletype : String , vehicleId: String , noofVehicles : String , amount : String)
}
class VehicledataEntryVC: UIViewController {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tf_noofvehicles: UITextField!
    @IBOutlet weak var btn_vehicleType: UIButton!
    var vehicledatasourceArry:[String] = []
    var vehicledatamodel:GetVehicledataStruct?
    var dropdown = DropDown()
    var vehicleDatadelegate:VehicleDataProtocol?
    var vehicleId:String?
    var amount:String?
    override func viewWillAppear(_ animated: Bool) {
        btn_vehicleType.layer.cornerRadius = 5
        btn_vehicleType.layer.borderWidth = 0.5
        btn_vehicleType.layer.backgroundColor = UIColor.white.cgColor
        if #available(iOS 13.0, *) {
            btn_vehicleType.layer.borderColor = UIColor.systemGray2.cgColor
        } else {
            // Fallback on earlier versions
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.dropShadow()
        self.getVehiclesDataWS()
    }
    

    @IBAction func btn_cancelclick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btn_vehicletypeClick(_ sender: UIButton) {
        dropdown.dataSource = vehicledatasourceArry
        dropdown.anchorView = sender
        dropdown.show()
        dropdown.selectionAction = {[unowned self] (index : Int , item : String) in
          print("selected index \(index) item \(item)")
            
            sender.setTitle(item, for: .normal)
            btn_vehicleType.setTitleColor(.black, for: .normal)
            self.vehicleId = self.vehicledatamodel?.vehiclelist?[index].vehicleTypeID
            self.amount = self.vehicledatamodel?.vehiclelist?[index].amount
            self.dropdown.hide()
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
    func validation() -> Bool{
        if btn_vehicleType.currentTitle == "Select vehicle type" {
            self.showAlert(message: "Please select vehicle type")
            return false
        } else if tf_noofvehicles.text == "" {
            self.showAlert(message: "Please enter no of vehicles")
            return false
        }
        return true
    }
    @IBAction func btn_addClick(_ sender: Any) {
        if validation() {
            vehicleDatadelegate?.vehicleDetails(vehicletype: btn_vehicleType.currentTitle ?? "", vehicleId: vehicleId ?? "", noofVehicles: tf_noofvehicles.text ?? "",amount: amount ?? "")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
// MARK: - GetVehicledataStruct
struct GetVehicledataStruct: Codable {
    let statusCode, statusMessage: String?
    let vehiclelist: [Vehiclelist]?

    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
        case vehiclelist = "VEHICLELIST"
    }
    // MARK: - Vehiclelist
    struct Vehiclelist: Codable {
        let vehicleTypeID, vehicleType ,amount: String?

        enum CodingKeys: String, CodingKey {
            case vehicleTypeID = "VEHICLE_TYPE_ID"
            case vehicleType = "VEHICLE_TYPE"
            case amount = "AMOUNT"
        }
    }

}
extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.cornerRadius = 5
        if #available(iOS 13.0, *) {
            layer.backgroundColor = UIColor.systemGray6.cgColor
        } else {
            // Fallback on earlier versions
        }
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
