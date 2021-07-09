//
//  PickupSlipDetailsVC.swift
//  GHMC_Officer
//
//  Created by Haritej on 27/06/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//

import UIKit

class PickupSlipDetailsVC: UIViewController {
    @IBOutlet var bg: UIView!
    @IBOutlet weak var vehicleNumLb: UILabel!
    @IBOutlet weak var slipNoLb: UILabel!
    @IBOutlet weak var zoneLb: UILabel!
    @IBOutlet weak var circleLb: UILabel!
    @IBOutlet weak var wardLb: UILabel!
    @IBOutlet weak var localityLb: UILabel!
    @IBOutlet weak var driverNameLb: UILabel!
    @IBOutlet weak var wastetypeLb: UILabel!
    @IBOutlet weak var grosswtTF: UITextField!
    @IBOutlet weak var tarewtTF: UITextField!
    @IBOutlet weak var netwtLb: UITextField!
    var tripDetails:GetTripsatPlantStruct.OperatorVehicleList?
    override func viewDidLoad() {
        super.viewDidLoad()
        driverNameLb.text = tripDetails?.driverName
        vehicleNumLb.text = tripDetails?.vehicleNumber
        zoneLb.text = tripDetails?.zone
        circleLb.text = tripDetails?.circle
        wardLb.text = tripDetails?.ward
        slipNoLb.text = tripDetails?.cndwGrievancesID
        wastetypeLb.text = "UnClaimed"
    }
    
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func submitClick(_ sender: Any) {
        if validation(){
            tripdetailsSubmitWS()
        }
    }
    func tripdetailsSubmitWS(){
        let params = [
            "CNDW_GRIEVANCE_ID": tripDetails?.cndwGrievancesID ?? "" ,
            "DEVICEID": deviceId,
            "TOKEN_ID": UserDefaultVars.token,
            "EMPLOYEE_ID": UserDefaultVars.empId,
            "VEHICLE_NUMBER": tripDetails?.vehicleNumber ?? "",
            "GROSS_WT": grosswtTF.text ?? "",
            "TARE_WT": tarewtTF.text ?? "",
            "NET_WT": netwtLb.text ?? ""
        ]as [String : Any]
        print(params)
    guard Reachability.isConnectedToNetwork() else {self.showAlert(message:noInternet);return}
    NetworkRequest.makeRequest(type: TripSubmitStruct.self, urlRequest: Router.tripSubmit(Parameters: params)) { [weak self](result) in
            switch result {
            case .success(let resp):
                print(resp)
                if resp.statusCode == "600"{
                    self?.showCustomAlert(message: resp.statusMessage ?? ""){
                        let vc = storyboards.Main.instance.instantiateViewController(withIdentifier: "LoginViewControllerViewController") as! LoginViewControllerViewController
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                if resp.statusCode == "200"
                {
                    self?.showAlert(message: resp.statusMessage ?? ""){
                        self?.navigationController?.popViewController(animated: true)
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

    func validation() -> Bool{
        if grosswtTF.text == "" {
            showAlert(message: "Please enter gross weight")
            return false
        }else if tarewtTF.text == "" {
            showAlert(message: "Please enter tare weight")
            return false
        }else if netwtLb.text == "" {
            showAlert(message: "Please enter net weight")
            return false
        }
        return true
    }
}
// MARK: - TripSubmitStruct
struct TripSubmitStruct: Codable {
    let statusCode, statusMessage, cndwGrievanceID: String?

    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
        case cndwGrievanceID = "CNDW_GRIEVANCE_ID"
    }
}
