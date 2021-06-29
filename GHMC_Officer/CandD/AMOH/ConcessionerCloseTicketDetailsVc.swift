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
    
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtnClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func radiosBtnClicked(_ sender: UIButton) {
        switch sender.tag {
        case 0: // reAssignBtn
            print("reassignradiobtn")
            sender.isSelected.toggle()
            closeRadioBtn.isSelected = false
//            if sender.isSelected == true
//            {
//                closeRadioBtn.isSelected = false
//                sender.isSelected = false
//            }else{
//                sender.isSelected = true
//                closeRadioBtn.isSelected = false
//            }
            
            
            //reAssignBtn.isSelected = closeRadioBtn.isSelected == true ?
        default: //closebtn
            print("closebtnclicked")
            sender.isSelected.toggle()
            reAssignBtn.isSelected = false
        }
    }
}
extension ConcessionerCloseTicketDetailsVc : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConcessionerCloseTicketTBCell") as! ConcessionerCloseTicketTBCell
        return cell
    }
}
