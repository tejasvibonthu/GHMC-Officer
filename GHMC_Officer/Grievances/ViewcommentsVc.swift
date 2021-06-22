//
//  ViewCommentsViewController.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 20/09/19.
//  Copyright © 2019 IOSuser3. All rights reserved.
//

import UIKit

class ViewcommentsVc: UIViewController {

    @IBOutlet weak var bgImagev: UIImageView!
    @IBOutlet weak var tableview: UITableView!
    var array:GrievancehistoryStruct?
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UserDefaults.standard.value(forKey:"bgImagview") as! String
         bgImagev.image = UIImage.init(named:image)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated:true)
    }

}
extension ViewcommentsVc:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int //
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return array?.comments?.count  ?? 0
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier:"ViewCommentsTableViewCell") as! ViewCommentsTableViewCell
        cell.callBtn.tag = indexPath.row
        cell.callBtn.addTarget(self, action: #selector(callBtnClicked(_:)), for: .touchUpInside)
        cell.setup(array:array!,row:indexPath.row)
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
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    @objc func callBtnClicked(_ sender : UIButton)
    {
        let item = array?.comments?[sender.tag]
        guard let phoneNo = item?.cmobileno else {return}
        let url: NSURL = URL(string: "TEL://\(phoneNo)")! as NSURL
        if UIApplication.shared.canOpenURL(url as URL)
        {
             UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }else {
            print("unable to open")
        }
        
        
    }
    
    
}
