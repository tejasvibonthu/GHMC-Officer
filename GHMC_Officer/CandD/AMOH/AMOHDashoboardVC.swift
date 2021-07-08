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
    @IBOutlet weak var raiseEstimationView: UIView!
    @IBOutlet weak var amohclosedView: UIView!
    @IBOutlet weak var usernameLB: UILabel!
    @IBOutlet weak var designationLB: UILabel!
    @IBOutlet weak var mobileNumberLB: UILabel!
    @IBOutlet weak var backButton: UIButton!
    var dashboardCountsModel:AmohDashoardCountsStruct?
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleCountsObserver), name: NSNotification.Name("refreshDashboardCounts"), object: nil)
        
        self.usernameLB.text = UserDefaultVars.empName
        self.designationLB.text = UserDefaultVars.designation
        self.mobileNumberLB.text = UserDefaultVars.mobileNumber
        self.hideViews()
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
        
        let raiseRequset = UITapGestureRecognizer(target: self, action:#selector(self.tapOnraiseEstimation))
        raiseEstimationView.addGestureRecognizer(raiseRequset)
    }
    
    @objc func handleCountsObserver(){
        self.GetAmohDashboardcounts()
    }
    func hideViews(){
        noofReqView.isHidden = true
        paymentConformationView.isHidden = true
        conessionerRejectedView.isHidden = true
        concessionerClosedView.isHidden = true
        amohclosedView.isHidden = true
        raiseEstimationView.isHidden = true
    }
    func showViews(){
        noofReqView.isHidden = false
        paymentConformationView.isHidden = false
        conessionerRejectedView.isHidden = false
        concessionerClosedView.isHidden = false
        amohclosedView.isHidden = false
        raiseEstimationView.isHidden = false
    }
    
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //total no of requests list
    @objc func taponnoofReq(){
        let vc = storyboards.AMOH.instance.instantiateViewController(withIdentifier: "ConcessionerRejectListVC") as! RequestLists
        vc.tag = 0
        navigationController?.pushViewController(vc, animated: true)
     }
    //payment conformed list
    @objc func taponpaymentConformation(){
        let vc = storyboards.AMOH.instance.instantiateViewController(withIdentifier: "ConcessionerRejectListVC") as! RequestLists
        vc.tag = 1
        navigationController?.pushViewController(vc, animated: true)
     }
    //concessionerrejected list
    @objc func taponconsessionerRejected(){
        let vc = storyboards.AMOH.instance.instantiateViewController(withIdentifier: "ConcessionerRejectListVC") as! RequestLists
        vc.tag = 2
        navigationController?.pushViewController(vc, animated: true)
     }
    //concessioner closed tickets(Amoh login)
    @objc func taponconnsessionerclosedTickets(){
        let vc = storyboards.AMOH.instance.instantiateViewController(withIdentifier: "ConcessionerRejectListVC") as! RequestLists
        vc.tag = 3
        navigationController?.pushViewController(vc, animated: true)
     }
    @objc func taponAmohClosedTickets(){
        let vc = storyboards.AMOH.instance.instantiateViewController(withIdentifier: "ConcessionerRejectListVC") as! RequestLists
        vc.tag = 4
        navigationController?.pushViewController(vc, animated: true)
     }
    //Raise request
    @objc func tapOnraiseEstimation(){
        let vc = storyboards.AMOH.instance.instantiateViewController(withIdentifier: "RequestEstimationVC")as! RequestEstimationVC
//        vc.ticketDetails = details
       vc.tag = 5
       // print(ticketIdLb)
        self.navigationController?.pushViewController(vc, animated:true)
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
                        self?.showViews()
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
deinit
{
    NotificationCenter.default.removeObserver(self)
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



