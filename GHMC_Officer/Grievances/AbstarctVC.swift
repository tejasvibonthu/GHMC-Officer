//
//  AbstarctViewController.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 18/09/19.
//  Copyright © 2019 IOSuser3. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD

class AbstarctVC: UIViewController {
    var abstractReportModel:abstractRport?
    var abstarctArray:Array = [String]()
    var colourArray:Array = [String]()
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UserDefaults.standard.value(forKey:"bgImagview") as! String
       // bgImagev.image = UIImage.init(named:image)
   self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = UIColor.init(patternImage:UIImage.init(named:image)!)
        colourArray = ["#73C6B6","#7FB3D5","#E6B0AA","#F5CBA7","#D6DBDF","#D7BDE2"]
        if Reachability.isConnectedToNetwork(){
         absractReportWS()
        }else{
            showAlert(message:interNetconnection)
        }
        // Do any additional setup after loading the view.
    }
    

    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func absractReportWS(){
        
        let dict :Parameters  = ["userid":userid,
                                 "password":password,
                                 "type_id":UserDefaults.standard.value(forKey:"TYPE_ID") ?? " ",
                                 "uid":UserDefaults.standard.value(forKey:"EMP_D") ?? ""
                                 
        ]
        
        DispatchQueue.main.async {
            self.loading(text:progressMsgWhenLOginClicked)
            PKHUD.sharedHUD.show()
        }
        
        Alamofire.request(Router.abstarctReport(params:dict)).responseJSON {response in
            
        //    print(response)
            
            DispatchQueue.main.async {
                PKHUD.sharedHUD.hide()
            }
            switch response.result{
            case .success:
                do{
                    let decoder = JSONDecoder()
                    self.abstractReportModel = try decoder.decode(abstractRport.self, from: response.data!)
                    DispatchQueue.main.async {
                        if  self.abstractReportModel?.status == "true"{
                            if self.abstractReportModel?.flag == "Y"{
                                self.abstarctArray .append(self.abstractReportModel?.TOTAL_CLOSED ?? "-")
                                self.abstarctArray.append(self.abstractReportModel?.TOTAL_CLOSED ?? "-")
                                self.abstarctArray.append(self.abstractReportModel?.TOTAL_PENDING ?? "-")
                                self.abstarctArray.append(self.abstractReportModel?.TOTAL_UNDER_PROCESS ?? "-")
                                self.abstarctArray.append(self.abstractReportModel?.TOTAL_NON_GHMC ?? "-")
                                self.abstarctArray.append(self.abstractReportModel?.TOTAL_FUND_RELATED ?? "-")
                               
                                
                                self.tableview.reloadData()
                                if self.tableview.contentSize.height < self.tableview.frame.size.height{
                                    self.tableview.isScrollEnabled = false
                                }else{
                                    self.tableview.isScrollEnabled = true
                                }
                            
                            }else {
                            if self.abstractReportModel?.flag != "Y" { self.showAlert(message:(self.abstractReportModel?.status! ?? ""))
                            }
                        }
                        }else {
                            self.showAlert(message:"No Records Found")
                        }
                }
                }catch {
                    print(error.localizedDescription)
                }
                break
            case .failure(let error):
                print(error)
                
                break
                
                
            }
            
        }
    }
    @IBOutlet weak var back_buttonAction: UINavigationItem!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AbstarctVC:UITableViewDataSource,UITableViewDelegate 
{
    
    func numberOfSections(in tableView: UITableView) -> Int //
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if abstractReportModel?.flag == "Y"{
             return 6
        }
       return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let vc = storyboards.Complaints.instance.instantiateViewController(withIdentifier:"GrievanceHistoryViewController") as! GrievanceHistoryViewController
        //        vc.compliant_id = model?.grievance?[indexPath.row].id!
        //        self.navigationController?.pushViewController(vc, animated:true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier:"AbstarctTableViewCell") as! AbstarctTableViewCell
        // cell.imgae1.sd_setImage(with: URL(string:"imagestr1"), placeholderImage: UIImage(named: "ghmc_layer"))
        // cell.image2.sd_setImage(with: URL(string:imagestr1!), placeholderImage: UIImage(named: "ghmc_layer"))
        // cell.image3.sd_setImage(with: URL(string:imagestr1!), placeholderImage: UIImage(named: "ghmc_layer"))
        //        cell.setup(indexpath:indexPath)
        //        cell.delegate1 = self
        
        //        if (imagestr1?.hasSuffix("g"))!{
        //            cell.imgae1.image = UIImage.init(named:"viewimage")
        //
        //        }else if (imagestr1?.hasSuffix("f"))!{
        //            cell.imgae1.image = UIImage.init(named:"pdfnew")
        //
        //        }
        //        if (imagestr3?.hasSuffix("g"))!{
        //            cell.image3.image = UIImage.init(named:"viewimage")
        //
        //        }else if (imagestr3?.hasSuffix("f"))!{
        //            cell.image3.image = UIImage.init(named:"pdfnew")
        //
        //        }
        //        if (imagestr2?.hasSuffix("g"))!{
        //            cell.image2.image = UIImage.init(named:"viewimage")
        //
        //        }else if (imagestr2?.hasSuffix("f"))!{
        //            cell.image2.image = UIImage.init(named:"pdfnew")
        //
        //        }
        cell.setup(array:abstarctArray, row:indexPath.row, colourArray:self.colourArray,model:abstractReportModel!)
        if indexPath.row == 1{
            cell.wholeView.backgroundColor = firstColour
        }else if indexPath.row == 2{
            cell.wholeView.backgroundColor = secondColour
        }else if indexPath.row == 3{
           cell.wholeView.backgroundColor = thirdColour
        }else if indexPath.row == 4{
           cell.wholeView.backgroundColor = fourthColour
        }else if indexPath.row == 5{
            cell.wholeView.backgroundColor = fifthColour
        }else if indexPath.row == 6{
           cell.wholeView.backgroundColor = sixthColour
        }
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    
}
