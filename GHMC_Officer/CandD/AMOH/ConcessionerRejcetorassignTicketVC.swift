//
//  ConcessionerRejcetorassignTicketVC.swift
//  GHMC_Officer
//
//  Created by deep chandan on 26/06/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//

import UIKit
import GrowingTextView
class ConcessionerRejcetorassignTicketVC: UIViewController {
    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var ticketLb: UILabel!
    @IBOutlet weak var reasonLb: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var rb1: UIButton!
    @IBOutlet weak var rb2: UIButton!
    @IBOutlet weak var textView: GrowingTextView!
    var isReassaign:String?
    var ticketDetails:ConcessionerRejectListStruct.TicketList?
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.isHidden = true
        self.ticketLb.text = ticketDetails?.tokenID
        self.reasonLb.text = ticketDetails?.status
        self.img.sd_setImage(with: URL(string:ticketDetails?.imagePath  ?? ""), placeholderImage: UIImage(named: "noi"))
    }
    @IBAction func backbtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1.0;
    }
    @IBAction func reassignClick(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            rb2.isSelected = false
                } else {
                    sender.isSelected = true
                    rb2.isSelected = false
                    textView.isHidden = false
                    isReassaign = "Y"
                }
    }
    @IBAction func closeClick(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            rb1.isSelected = false
                } else {
                    sender.isSelected = true
                    rb1.isSelected = false
                    textView.isHidden = true
                    isReassaign = "N"
                }
    }
    @IBAction func submitClick(_ sender: Any) {
        self.ConcessionerRejectSubmitWS()
    }
    func ConcessionerRejectSubmitWS(){
        let params = [
            "TICKET_ID": self.ticketLb.text ?? "",
            "DEVICEID": deviceId,
            "TOKEN_ID": UserDefaultVars.token,
            "AMOH_EMPID": UserDefaultVars.empId,
            "IS_REASSIGN": isReassaign ?? "",
            "REMARKS_FOR_REASSIGN": textView.text ?? ""
        ]as [String : Any]
        print(params)
    guard Reachability.isConnectedToNetwork() else {self.showAlert(message:noInternet);return}
    NetworkRequest.makeRequest(type: ConcessionerReassignStruct.self, urlRequest: Router.concessionerReassignstatus(Parameters: params)) { [weak self](result) in
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
}
// MARK: - ConcessionerReassignStruct
struct ConcessionerReassignStruct: Codable {
    let statusCode, statusMessage, ticketID: String?

    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
        case ticketID = "TICKET_ID"
    }
}
