//
//  PdfVC.swift
//  GHMC_Officer
//
//  Created by deep chandan on 26/03/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//

import UIKit
import WebKit

class PdfVC: UIViewController {
    var pdfString:String?
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("done")
        self.navigationController?.navigationBar.isHidden = true
        let url: URL! = URL(string: pdfString!)
        let req = URLRequest.init(url:url)
        webView.load(req)
        navigationController?.navigationBar.isHidden = true
    }

    @IBAction func backbtnClick(_ sender: Any) {
        navigationController?.popViewController(animated:true)
    }
    
}
