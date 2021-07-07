//
//  ConcessionerCloseTicketDetailsVc.swift
//  GHMC_Officer
//
//  Created by deep chandan on 29/06/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//

import UIKit

class ConcessionerCloseTicketDetailsVc: UIViewController {
    //MARK:- Properties
    @IBOutlet weak var lb_TickedID: UILabel!
    @IBOutlet weak var lb_TickedRaisedDate: UILabel!
    @IBOutlet weak var lb_TickedClosedDate: UILabel!
    @IBOutlet weak var lb_zone: UILabel!
    @IBOutlet weak var lb_circle: UILabel!
    @IBOutlet weak var lb_ward: UILabel!
    @IBOutlet weak var lb_location: UILabel!
    @IBOutlet weak var lb_ramkysupervisorname: UILabel!
    @IBOutlet weak var remarksTxt: UITextField!
    @IBOutlet weak var reAssignBtn: UIButton!
    @IBOutlet weak var lb_typeOfWaste: UILabel!
    @IBOutlet weak var closeRadioBtn: UIButton!
    var ticketDetails:AmohconcessionerClosedListStruct.TicketList?
    var amohDetails:AmohClosedListStruct.TicketList?
    var isreassign:String?
    var tag :Int?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if tag == 0 {
            lb_TickedID.text = ticketDetails?.ticketID
            lb_TickedClosedDate.text = ticketDetails?.ticketClosedDate
            lb_TickedRaisedDate.text = ticketDetails?.ticketRaisedDate
            lb_zone.text = ticketDetails?.zoneName
            lb_circle.text = ticketDetails?.circleName
            lb_ward.text = ticketDetails?.wardName
            lb_ramkysupervisorname.text = ticketDetails?.concessionerName
            lb_location.text = ticketDetails?.location
            lb_typeOfWaste.text = ticketDetails?.typeOfWaste
        } else if tag == 1 {
            lb_TickedID.text = amohDetails?.ticketID
            lb_TickedClosedDate.text = amohDetails?.ticketClosedDate
            lb_TickedRaisedDate.text = amohDetails?.ticketRaisedDate
            lb_zone.text = amohDetails?.zoneName
            lb_circle.text = amohDetails?.circleName
            lb_ward.text = amohDetails?.wardName
            lb_ramkysupervisorname.text = amohDetails?.concessionerName
            lb_location.text = amohDetails?.location
            lb_typeOfWaste.text = amohDetails?.typeOfWaste
        }
      
        tableView.delegate = self
        tableView.dataSource = self

    }
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtnClicked(_ sender: UIButton) {
        if validation(){
            if tag == 0{
                amohClosingmarkedbyConcessionerWS()
            } else if tag == 1 {
                amohCloseTicketsWS()
            }
        }
    }
    func amohClosingmarkedbyConcessionerWS(){
        let params = [
            "CNDW_GRIEVANCE_ID": ticketDetails?.ticketID ?? "",
            "EMPLOYEE_ID": UserDefaultVars.empId,
            "DEVICEID": deviceId,
            "TOKEN_ID": UserDefaultVars.token ?? "",
            "IS_REASSIGN": isreassign ?? "" ,
            "REMARKS":remarksTxt.text ?? ""
            
            
        ] as [String : Any]
            print(params)
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message:noInternet);return}
        NetworkRequest.makeRequest(type: AmohConcessionerClosedtStruct.self, urlRequest: Router.amohconcessionerClosedSubmit(Parameters: params)) { [weak self](result) in
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
                        self?.showAlert(message: resp.statusMessage ?? "" ){
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
    func amohCloseTicketsWS(){
        let params = [
            "CNDW_GRIEVANCE_ID": amohDetails?.ticketID ?? "",
            "EMPLOYEE_ID": UserDefaultVars.empId,
            "DEVICEID": deviceId,
            "TOKEN_ID": UserDefaultVars.token ?? "",
            "IS_REASSIGN": isreassign ?? "" ,
            "REMARKS":remarksTxt.text ?? ""
            
            
        ] as [String : Any]
            print(params)
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message:noInternet);return}
        NetworkRequest.makeRequest(type: AmohConcessionerClosedtStruct.self, urlRequest: Router.amohCloseticketSubmit(Parameters: params)) { [weak self](result) in
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
                        self?.showAlert(message: resp.statusMessage ?? "" ){
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
    if closeRadioBtn.isSelected == false && reAssignBtn.isSelected == false{
       showAlert(message: "please select Re assign or Close ")
        return false
    } else  if remarksTxt.text == ""{
         showAlert(message: "please enter remarks")
         return false
     }
    return true
    }
    @IBAction func radiosBtnClicked(_ sender: UIButton) {
        switch sender.tag {
        case 0: // reAssignBtn
            print("reassignradiobtn")
            sender.isSelected.toggle()
            closeRadioBtn.isSelected = false
            isreassign = "Y"

        default: //closebtn
            print("closebtnclicked")
            sender.isSelected.toggle()
            reAssignBtn.isSelected = false
            isreassign = "N"
        }
    }
}
extension ConcessionerCloseTicketDetailsVc : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tag == 0 {
            return  ticketDetails?.listVehicles?.count ?? 0
        } else if tag == 1 {
            return amohDetails?.listVehicles?.count ?? 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConcessionerCloseTicketTBCell") as! ConcessionerCloseTicketTBCell

        if tag == 0 {
            let vehicledetails = ticketDetails?.listVehicles?[indexPath.row]
            cell.lb_tripno.text = vehicledetails?.vehicleID
            cell.lb_vehicleno.text = vehicledetails?.vehicleNo
            cell.lb_drivername.text = vehicledetails?.driverName
            cell.lb_mobileNo.text = vehicledetails?.mobileNumber
            cell.img1.sd_setImage(with: URL(string:vehicledetails?.beforeTripImage  ?? ""), placeholderImage: UIImage(named: "noi"))
            cell.img2.sd_setImage(with: URL(string:vehicledetails?.afterTripImage  ?? ""), placeholderImage: UIImage(named: "noi"))
        } else if tag == 1 {
            let details = amohDetails?.listVehicles?[indexPath.row]
            cell.lb_tripno.text = details?.vehicleID
            cell.lb_vehicleno.text = details?.vehicleNo
            cell.lb_drivername.text = details?.driverName
            cell.lb_mobileNo.text = details?.mobileNumber
            cell.img1.sd_setImage(with: URL(string:details?.beforeTripImage  ?? ""), placeholderImage: UIImage(named: "noi"))
            cell.img2.sd_setImage(with: URL(string:details?.afterTripImage  ?? ""), placeholderImage: UIImage(named: "noi"))
        }
        
        return cell
    }
}
// MARK: - AmohConcessionerClosedtStruct
struct AmohConcessionerClosedtStruct: Codable {
    let statusCode, statusMessage, cndwGrievanceID: String?

    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
        case cndwGrievanceID = "CNDW_GRIEVANCE_ID"
    }
}
