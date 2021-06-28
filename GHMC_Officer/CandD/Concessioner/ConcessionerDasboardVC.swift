//
//  ConcessionerDasboardVC.swift
//  GHMC_Officer
//
//  Created by deep chandan on 24/06/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//

import UIKit

class ConcessionerDasboardVC: UIViewController {
    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var ticketListView: UIView!
    @IBOutlet weak var captureListView: UIView!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var designationLb: UILabel!
    @IBOutlet weak var mobileNumberLb: UILabel!
    @IBOutlet weak var closedListView: UIView!
    @IBOutlet weak var cocessionerTicketCountLb: UILabel!
    @IBOutlet weak var rejectListView: UIView!
    @IBOutlet weak var concessionerPickupCaptureCountLb: UILabel!
    @IBOutlet weak var concessionerRejectCountLb: UILabel!
    @IBOutlet weak var concessionerClosedCountLb: UILabel!
    var ConcessionerdashboardCountsModel:ConcessionerdashboardStruct?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLb.text = UserDefaultVars.empName
        self.designationLb.text = UserDefaultVars.designation
        self.mobileNumberLb.text = UserDefaultVars.mobileNumber
        self.getConcessionerDashboardWS()
        let noofTickets = UITapGestureRecognizer.init(target: self, action: #selector(taponticketListView))
        ticketListView.addGestureRecognizer(noofTickets)
        
        let captureList = UITapGestureRecognizer.init(target: self, action: #selector(taponcaptureListView))
        captureListView.addGestureRecognizer(captureList)
        
        let rejectedList = UITapGestureRecognizer.init(target: self, action: #selector(taponrejectListView))
        rejectListView.addGestureRecognizer(rejectedList)
        
        
        let closedTickets = UITapGestureRecognizer(target: self, action:#selector(self.taponclosedListView))
        closedListView.addGestureRecognizer(closedTickets)
    }
    //tickets List
    @objc func taponticketListView(){
        let vc = storyboards.Concessioner.instance.instantiateViewController(withIdentifier: "ConcessionerTicketsList") as! ConcessionerTicketsList
        vc.tag = 0
        navigationController?.pushViewController(vc, animated: true)
     }
    //pickupCapture list
    @objc func taponcaptureListView(){
        let vc = storyboards.Concessioner.instance.instantiateViewController(withIdentifier: "ConcessionerTicketsList") as! ConcessionerTicketsList
     vc.tag = 1
    navigationController?.pushViewController(vc, animated: true)
     }
    //concessionerrejected list
    @objc func taponrejectListView(){
//        let vc = storyboards.Concessioner.instance.instantiateViewController(withIdentifier: "ConcessionerRejectListVC") as! RequestLists
//       // vc.tag = 2
//        navigationController?.pushViewController(vc, animated: true)
     }
    //concessioner closed tickets
    @objc func taponclosedListView(){
//        let vc = storyboards.Concessioner.instance.instantiateViewController(withIdentifier: "ConcessionerRejectListVC") as! RequestLists
//     //   vc.tag = 3
//        navigationController?.pushViewController(vc, animated: true)
     }
   func getConcessionerDashboardWS() {
    let params = ["EMPLOYEE_ID" : UserDefaultVars.empId,
                  "DEVICEID" :deviceId,
                  "TOKEN_ID" :UserDefaultVars.token,]
       print(params)
    guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
    NetworkRequest.makeRequest(type: ConcessionerdashboardStruct.self, urlRequest: Router.getConcessionerDashboardList(Parameters: params)) { [weak self](result) in
        switch result
        {
        case .success(let getCounts):
            print(getCounts)
            self?.ConcessionerdashboardCountsModel = getCounts
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
                    self?.cocessionerTicketCountLb.text = getCounts.amohList?[0].concessionerTicketsCount
                    self?.concessionerPickupCaptureCountLb.text =  getCounts.amohList?[0].concessionerPickupCaptureCount
                    self?.concessionerRejectCountLb.text =  getCounts.amohList?[0].concessionerRejectedCount
                    self?.concessionerClosedCountLb.text =  getCounts.amohList?[0].concessionerClosedCount
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
// MARK: - ConcessionerdashboardStruct
struct ConcessionerdashboardStruct: Codable {
    let statusCode, statusMessage: String?
    let amohList: [AMOHList]?

    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
        case amohList = "AMOHList"
    }
}

// MARK: - AMOHList
struct AMOHList: Codable {
    let concessionerTicketsCount, concessionerPickupCaptureCount, concessionerRejectedCount, concessionerClosedCount: String?

    enum CodingKeys: String, CodingKey {
        case concessionerTicketsCount = "CONCESSIONER_TICKETS_COUNT"
        case concessionerPickupCaptureCount = "CONCESSIONER_PICKUP_CAPTURE_COUNT"
        case concessionerRejectedCount = "CONCESSIONER_REJECTED_COUNT"
        case concessionerClosedCount = "CONCESSIONER_CLOSED_COUNT"
    }
}
