//
//  AMOHDashoboard.swift
//  GHMC_Officer
//
//  Created by deep chandan on 17/04/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//

import UIKit

class AMOHDashoboardVC: UIViewController {
    @IBOutlet weak var bgImg: UIImageView!
    @IBOutlet weak var noofReqLB: UILabel!
    @IBOutlet weak var noofReqLBCount: UILabel!
    @IBOutlet weak var paymentConformationLB: UILabel!
    @IBOutlet weak var paymentConformationLBCount: UILabel!
    @IBOutlet weak var consessionerRejectedLB: UILabel!
    @IBOutlet weak var consessionerRejectedLBCount: UILabel!
    @IBOutlet weak var connsessionerclosedTicketsLB: UILabel!
    @IBOutlet weak var connsessionerclosedTicketsLBCount: UILabel!
    @IBOutlet weak var AmohClosedTicketsLB: UILabel!
    @IBOutlet weak var AmohClosedTicketsLBCount: UILabel!
    @IBOutlet weak var noofReqView: UIView!
    @IBOutlet weak var paymentConformationView: UIView!
    @IBOutlet weak var conessionerRejectedView: UIView!
    @IBOutlet weak var concessionerClosedView: UIView!
    @IBOutlet weak var amohclosedView: UIView!
    @IBOutlet weak var usernameLB: UILabel!
    @IBOutlet weak var designationLB: UILabel!
    @IBOutlet weak var mobileNumberLB: UILabel!
    var dashboardCountsModel:AmohDashoardCountsStruct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameLB.text = UserDefaultVars.empName
        self.designationLB.text = UserDefaultVars.designation
        self.mobileNumberLB.text = UserDefaultVars.mobileNumber
        self.GetAmohDashboardcounts()
        let noofReq = UITapGestureRecognizer.init(target: self, action: #selector(taponnoofReq))
        noofReqView.addGestureRecognizer(noofReq)
        
        let paymentConformation = UITapGestureRecognizer.init(target: self, action: #selector(taponpaymentConformation))
        paymentConformationView.addGestureRecognizer(paymentConformation)
        
        let consessionerRejected = UITapGestureRecognizer.init(target: self, action: #selector(taponconsessionerRejected))
        conessionerRejectedView.addGestureRecognizer(consessionerRejected)
        
        
        let connsessionerclosedTickets = UITapGestureRecognizer(target: self, action:#selector(self.taponconnsessionerclosedTickets))
        concessionerClosedView.addGestureRecognizer(connsessionerclosedTickets)
        
        let AmohClosedTickets = UITapGestureRecognizer(target: self, action:#selector(self.taponAmohClosedTickets))
        amohclosedView.addGestureRecognizer(AmohClosedTickets)
    }
    
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func taponnoofReq(){
        let vc = storyboards.AMOH.instance.instantiateViewController(withIdentifier: "RequestListVC") as! RequestListVC
        navigationController?.pushViewController(vc, animated: true)
     }
    @objc func taponpaymentConformation(){
     
     }
    @objc func taponconsessionerRejected(){
     
     }
    @objc func taponconnsessionerclosedTickets(){
     
     }
    @objc func taponAmohClosedTickets(){
     
     }
    func GetAmohDashboardcounts(){
        let params = ["EMPLOYEE_ID" : UserDefaultVars.empId,
                      "DEVICEID" :deviceId,
                      "TOKEN_ID" :UserDefaultVars.token,]
           print(params)
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
        NetworkRequest.makeRequest(type: AmohDashoardCountsStruct.self, urlRequest: Router.getAmohDashboardList(Parameters: params)) { [weak self](result) in
            switch result
            {
            case .success(let getCounts):
                print(getCounts)
                self?.dashboardCountsModel = getCounts
                if  getCounts.statusCode == "600"{
                    self?.showAlert(message: getCounts.statusMessage ?? ""){
                        let vc = storyboards.Main.instance.instantiateViewController(withIdentifier: "LoginViewControllerViewController") as! LoginViewControllerViewController
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                if getCounts.statusCode == "200"{
                    if getCounts.amohList?.isEmpty == true {
                        self?.showAlert(message: "No Records found")
                    } else {
                        let noOfRequests = getCounts.amohList?[0].noOfRequests
                        let paymentConfirmation =  getCounts.amohList?[0].paymentConfirmation
                        let concessionerRejected =  getCounts.amohList?[0].concessionerRejected
                        let concessionerCloseTickets =  getCounts.amohList?[0].concessionerCloseTickets
                        let amohCloseTickets =  getCounts.amohList?[0].amohCloseTickets
                        
                        self?.noofReqLBCount.text = noOfRequests
                        self?.paymentConformationLBCount.text = paymentConfirmation
                        self?.consessionerRejectedLBCount.text = concessionerRejected
                        self?.connsessionerclosedTicketsLBCount.text = concessionerCloseTickets
                        self?.AmohClosedTicketsLBCount.text = amohCloseTickets
                        self?.AmohClosedTicketsLBCount.text = noOfRequests
                        
                        
  
                    }
                } else {
                    self?.showAlert(message: getCounts.statusMessage ?? "")
                       
                    
                }
          
            case .failure(let err):
                print(err)
                DispatchQueue.main.async {
                    self?.showAlert(message: serverNotResponding)
                }
            }
        }
        
    }

}
import Foundation

// MARK: - AmohDashoardCountsStruct
struct AmohDashoardCountsStruct: Codable {
    let statusCode, statusMessage: String?
        let amohList: [AMOHList]?

        enum CodingKeys: String, CodingKey {
            case statusCode = "STATUS_CODE"
            case statusMessage = "STATUS_MESSAGE"
            case amohList = "AMOHList"
        }
    // MARK: - AMOHList
    struct AMOHList: Codable {
        let noOfRequests, paymentConfirmation, concessionerRejected, concessionerCloseTickets: String?
        let amohCloseTickets: String?

        enum CodingKeys: String, CodingKey {
            case noOfRequests = "NO_OF_REQUESTS"
            case paymentConfirmation = "PAYMENT_CONFIRMATION"
            case concessionerRejected = "CONCESSIONER_REJECTED"
            case concessionerCloseTickets = "CONCESSIONER_CLOSE_TICKETS"
            case amohCloseTickets = "AMOH_CLOSE_TICKETS"
        }
    }

 
}



