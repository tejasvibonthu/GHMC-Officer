//
//  PaymentDetailsViewController.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 26/10/19.
//  Copyright © 2019 IOSuser3. All rights reserved.
//

import UIKit

class PaymentDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension PaymentDetailsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier:"PaymentDetailsTableViewCell") as! PaymentDetailsTableViewCell
       
        cell.selectionStyle = .none
        cell.something()
        return cell
    }
    
    
}
