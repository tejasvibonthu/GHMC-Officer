//
//  RaiseRequest.swift
//  GHMC_Officer
//
//  Created by deep chandan on 29/06/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//

import UIKit
import SDWebImage

class ForwordtoConcessioner: UIViewController {
    @IBOutlet weak var dateLb: UILabel!
    @IBOutlet weak var zoneLb: UILabel!
    @IBOutlet weak var circleLb: UILabel!
    @IBOutlet weak var wardLb: UILabel!
    @IBOutlet weak var locationLb: UILabel!
    @IBOutlet weak var typeofWasteLb: UILabel!
    @IBOutlet weak var typeofvehiclesLb: UILabel!
    @IBOutlet weak var noofvehiclesLb: UILabel!
    @IBOutlet weak var camImg: UIImageView!
    @IBOutlet weak var estimationLb: UILabel!
    var numberFromString:String?
    var ticketDetails:GetPaidListStruct.PaidList?
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLb.text = ticketDetails?.createdDate
        zoneLb.text = ticketDetails?.zoneName
        circleLb.text = ticketDetails?.circleID
        wardLb.text = ticketDetails?.wardName
        locationLb.text = ticketDetails?.location
        typeofWasteLb.text = "Unclaimed"
        typeofvehiclesLb.text = ticketDetails?.vehicleType
        noofvehiclesLb.text = ticketDetails?.noOfVehicles
        estimationLb.text = ticketDetails?.estWt
        let tonsWeight = Int(ticketDetails?.estWt ?? "")
        self.numberFromString = String(tonsWeight ?? 0)
        camImg.sd_setImage(with: URL(string:ticketDetails?.image1Path ?? ""), placeholderImage: UIImage(named: "noi"))
    }
    
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func fwdtoconcessionerSubmitClick(_ sender: Any) {
        self.forwordtoConcessionerSubmitWS()
    }
    func forwordtoConcessionerSubmitWS(){
        let params = [
            "CNDW_GRIEVANCE_ID":ticketDetails?.ticketID ?? "",
            "EMPLOYEE_ID": UserDefaultVars.empId,
            "DEVICEID": deviceId,
            "TOKEN_ID": UserDefaultVars.token ?? "",
            "IMAGE1_PATH": ticketDetails?.image1Path ?? "",
            "VEHICLE_TYPE_ID":  ticketDetails?.vehicletypeId ?? "",
            "NO_OF_VEHICLES": ticketDetails?.noOfVehicles ?? "",
            "EST_WT": numberFromString ?? "",
            "WARD_ID": ticketDetails?.wardID ?? ""
        ]as [String : Any]
        print(params)
    guard Reachability.isConnectedToNetwork() else {self.showAlert(message:noInternet);return}
    NetworkRequest.makeRequest(type: PaymentPendingSubmitStruct.self, urlRequest: Router.forwordtoConcessioner(Parameters: params)) { [weak self](result) in
            switch result {
            case .success(let resp):
                print(resp)
                if resp.statusCode == "600"{
                        self?.showAlert(message: resp.statusMessage ?? ""){
                            let vc = storyboards.Main.instance.instantiateViewController(withIdentifier: "LoginViewControllerViewController") as! LoginViewControllerViewController
                            self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                if resp.statusCode == "200"
                {
                    self?.showAlert(message: resp.statusMessage ?? ""){
                        
                            let viewControllers: [UIViewController] = (self?.navigationController!.viewControllers)!
                            for aViewController in viewControllers {
                                if aViewController is AMOHDashoboardVC {
                                    NotificationCenter.default.post(name:NSNotification.Name("refreshDashboardCounts"), object: nil)
                                    self?.navigationController!.popToViewController(aViewController, animated: true)
                                }
                            }
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


}
