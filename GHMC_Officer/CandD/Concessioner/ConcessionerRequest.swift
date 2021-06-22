//
//  ConcessionerRequest.swift
//  GHMC_Officer
//
//  Created by Haritej on 27/05/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//

import UIKit
import DropDown

class ConcessionerRequest: UIViewController,UITextFieldDelegate {
    var date:String?
    var zone:String?
    var ward:String?
    var circle:String?
    var location:String?
    var grievanceId:String?
    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var dtaeLB: UILabel!
    @IBOutlet weak var zoneLB: UILabel!
    @IBOutlet weak var circleLB: UILabel!
    @IBOutlet weak var wardLB: UILabel!
    @IBOutlet weak var reqTypeBtn: UIButton!
    @IBOutlet weak var locationLB: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var radioBtn1: UIButton!
    @IBOutlet weak var radioBtn2: UIButton!
    @IBOutlet weak var vehicletypeBtn: UIButton!
    @IBOutlet weak var estimationWasteTf: UITextField!
    @IBOutlet weak var nofVehiclesTf: UITextField!
    @IBOutlet weak var vehicleNoTf: UITextField!
    @IBOutlet weak var driverNameTF: UITextField!
    @IBOutlet weak var mobileNoTF: UITextField!
    @IBOutlet weak var noofTripsTf: UITextField!
    @IBOutlet weak var cameraBtn: CustomImagePicker!
    {
        didSet
        {
            cameraBtn.parentViewController = self
        }
    }
    @IBOutlet weak var amountTF: UITextField!
    var vehicledatamodel:GetVehicledataStruct?
    var dropdown = DropDown()
    var vehicledatasourceArry:[String] = []
    var vehicleId:String?
    var noofTons:Int?
    var weight:String?
    var vehiclesCount:String?
    var IsAccept:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        dtaeLB.text = date
        zoneLB.text = zone
        circleLB.text = circle
        wardLB.text = ward
        locationLB.text = location
        nofVehiclesTf.delegate = self
        estimationWasteTf.isHidden = true
        amountTF.isHidden = true
        self.getVehiclesDataWS()
    }
    
    @IBAction func acceptClick(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            radioBtn2.isSelected = false
                } else {
                    
                    sender.isSelected = true
                    radioBtn2.isSelected = false
                    self.IsAccept = "Y"
                }
    }
    @IBAction func rejectClick(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            radioBtn1.isSelected = false
                } else {
                    sender.isSelected = true
                    radioBtn1.isSelected = false
                    self.IsAccept = "N"
                }
    }
        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if nofVehiclesTf.text != "" {
            vehiclesCount = nofVehiclesTf.text
        let noofVehicles = Int(nofVehiclesTf.text ?? "")
        let totalCost: Int = noofTons! * noofVehicles!
        self.weight = String(totalCost)
            estimationWasteTf.isHidden = false
            estimationWasteTf.text = ("\(weight ?? "0") TONS")
            if estimationWasteTf.text != "" {
                self.calculateAmountWS()
                self.amountTF.isHidden = false
            }
    }
        return true
    }
    
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func submitWS() {
        let imgData = convertImageToBase64String(img: cameraBtn.image!)
    let params = [
        "CNDW_GRIEVANCE_ID": grievanceId ?? "",
        "EMPLOYEE_ID": "868",
        "DEVICEID": deviceId,
        "TOKEN_ID": UserDefaultVars.token,
       "IMAGE1_PATH": "",
        "VEHICLE_TYPE_ID": vehicleId ?? "",
        "NO_OF_VEHICLES": nofVehiclesTf.text ?? "",
        "EST_WT": estimationWasteTf.text ?? "",
        "AMOUNT": amountTF.text ?? "",
        "ISACCEPT":self.IsAccept ?? "",
       "VEHICLE_DETAILS": [
                [
                    "VEHICLE_NO": vehicleNoTf.text,
                    "DRIVER_NAME": driverNameTF.text,
                    "MOBILE_NUMBER":mobileNoTF.text,
                    "NO_OF_TRIPS":noofTripsTf.text
              ]
                ]
    ] as [String : Any]
    guard Reachability.isConnectedToNetwork() else {self.showAlert(message:noInternet);return}
    NetworkRequest.makeRequest(type: SUbmitStruct.self, urlRequest: Router.submitConcessionerReq(Parameters: params)) { [weak self](result) in
            switch result {
            case .success(let resp):
                print(resp)
                if resp.statusCode == "200"
                {
                    self?.showAlert(message: resp.statusMessage ?? "")
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
        let params = ["EST_WT": self.weight]
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message:noInternet);return}
        NetworkRequest.makeRequest(type: CalculateAmountStruct.self, urlRequest: Router.calculateAmountbyTons(Parameters: params)) { [weak self](result) in
            switch result
            {
            case  .success(let CalData):
                if CalData.statusCode == "200"{
                    self?.amountTF.text = CalData.cndwAmount ?? ""
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
    func validation() -> Bool{
        if  radioBtn1.isSelected == false && radioBtn2.isSelected == false{
            showAlert(message: "Please select accept or reject")
            return false
        } else if vehicletypeBtn.currentTitle == "Vehicle type"{
            showAlert(message: "Please select vehicle type")
            return false
        } else if nofVehiclesTf.text == "" {
            showAlert(message: "Please enter no of vehicles")
            return false
        } else if vehicleNoTf.text == ""{
            showAlert(message: "Please enter vehicleNumber")
            return false
        } else if driverNameTF.text == ""{
            showAlert(message: "Please enter driverName")
            return false
        } else if mobileNoTF.text == ""{
            showAlert(message: "Please enter mobileNumber")
            return false
        }  else if (mobileNoTF?.text?.count)! != 10 {
            showAlert(message: "Please enter 10 digit mobileNumber")
            return false
        }else if noofTripsTf.text == ""{
            showAlert(message: "Please enter no of trips")
            return false
        } else if  cameraBtn.isImagePicked == false{
            showAlert(message: "Please capture photo")
            return false
        }
        return true
    }
    @IBAction func vehicletypeBtnClick(_ sender: UIButton) {
       // print(vehicledatasourceArry)
        dropdown.dataSource = vehicledatasourceArry
        dropdown.anchorView = sender
        dropdown.show()
        dropdown.selectionAction = {[unowned self] (index : Int , item : String) in
            //  print("selected index \(index) item \(item)")
            
            sender.setTitle(item, for: .normal)
            vehicletypeBtn.setTitleColor(.black, for: .normal)
            self.vehicleId = self.vehicledatamodel?.vehiclelist?[index].vehicleTypeID
            self.dropdown.hide()
            self.noofTons = Int((vehicletypeBtn.currentTitle?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())! )
                }
    }
    @IBAction func proceedtoBtnClick(_ sender: Any) {
        if validation(){
            self.submitWS()
        }
    }
}
// MARK: - Claimlist
struct SUbmitStruct: Codable {
    let statusCode, statusMessage , cndwGrievanceId: String?
    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
        case cndwGrievanceId = "CNDW_GRIEVANCE_ID"
    }
}
