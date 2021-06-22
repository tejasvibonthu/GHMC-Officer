//
//  PdfViewController.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 20/09/19.
//  Copyright © 2019 IOSuser3. All rights reserved.
//

import UIKit
import WebKit

class PdfViewController: UIViewController {
    var pdfString:String?
    @IBOutlet weak var webview: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
       let url = URL.init(string:pdfString ?? "")!
        // wholeView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//        let url: URL! = URL(string: "http://developer.apple.com/iphone/library/documentation/UIKit/Reference/UIWebView_Class/UIWebView_Class.pdf")
//
////       let tap = UITapGestureRecognizer.init(target:self, action:#selector(showSomething))
////        wholeView.addGestureRecognizer(tap)
        let req = URLRequest.init(url:url)
        webview.load(req)
//
        

    }
//    @objc func showSomething(){
//        self.dismiss(animated:true, completion:nil)
//    }
}

