//
//  PostFeedBackVC.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 21/05/20.
//  Copyright © 2020 IOSuser3. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD
import Cosmos



class PostFeedBackVC:  UIViewController, UITextViewDelegate {

    var recieveArray: [Grievance] = []

    @IBOutlet var backgroundImg: UIImageView!
    @IBOutlet var statusImage: UIImageView!
    @IBOutlet var reopen: UIButton!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var feedbackText: UITextView!
    @IBOutlet var cosmosView: CosmosView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       let image = UserDefaults.standard.value(forKey:"bgImagview") as! String
        backgroundImg.image = UIImage.init(named:image)
        
        cosmosView.settings.fillMode = .full

        cosmosView.rating = 5
        
        cosmosView.settings.starMargin = 10
        
        feedbackText.text = "Feedback"
        feedbackText.textColor = UIColor.lightGray
        
        self.feedbackText.delegate = self
        
        feedbackText.layer.cornerRadius = 5.0
        feedbackText.layer.borderColor = UIColor.white.cgColor
        feedbackText.layer.borderWidth = 2
       // feedbackText.clipsToBounds = true

        
        // Change the text
        
        // Called when user finishes changing the rating by lifting the finger from the view.
        // This may be a good place to save the rating in the database or send to the server.
        cosmosView.didFinishTouchingCosmos = { rating in
            
         //   print(rating)
            

            if rating == 1.0
            {
                self.statusImage.image = UIImage(named: "feedback1")
                self.statusLabel.text = "Extremely Not Satisfied"
            }else if rating == 2.0
            {
                self.statusImage.image = UIImage(named: "feedback2")
                self.statusLabel.text = "Not Satisfied"

            }
            else if rating == 3.0
            {
                self.statusImage.image = UIImage(named: "feedback3")
                self.statusLabel.text = "Partially Satisfied"

            }
            else if rating == 4.0
            {
                self.statusImage.image = UIImage(named: "feedback4")
                self.statusLabel.text = "Satisfied"

            }else if rating == 5.0
            {
                self.statusImage.image = UIImage(named: "feedback5")
                self.statusLabel.text = "Extremely Satisfied"

            }
            
            
            
        }
        
        // A closure that is called when user changes the rating by touching the view.
        // This can be used to update UI as the rating is being changed by moving a finger.
        cosmosView.didTouchCosmos = { rating in
            
            
          //  print(rating)
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func reopenClicked(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected

        
    }
    
         func textViewDidBeginEditing(_ textView: UITextView) {
            //    textView.text = ""
                
            }
    
    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = "Feedback"
//            textView.textColor = UIColor.lightGray
//        }
//    }
    
    @IBAction func submitClicked(_ sender: Any) {
        
        if feedbackText.text as String ==  ""
        {
            self.showAlert(message: "Please enter your feedback!")
        }
        else
        {
        
        let replaceFeedback = feedbackText.text .replacingOccurrences(of: "&", with: "and")
        
 
        self.loading(text:"Loading Details..")
        PKHUD.sharedHUD.show(onView: self.view)

        
                let compId = recieveArray[0].id
            

        
        
        let parameters: Parameters = ["userid" : "cgg@ghmc","password" : "ghmc@cgg@2018", "mobileno" : UserDefaults.standard.string(forKey: "MOBILENUMBER")!,    "compId" : compId, "remarks": statusLabel.text!, "feedback" : replaceFeedback, "openclose" : reopen.isSelected ? "2" : "1"]
        
        
        Alamofire.request(Router.postFeedback(Parameters: parameters)).responseJSON { response in
            PKHUD.sharedHUD.hide()
            
            
            switch response.result{
            case .success:
                
                let responsesdict = response.result.value as! NSDictionary
                
//print(responsesdict)
                
                
                if responsesdict.value(forKey: "status") as?  String == "True"
                {
                    
                 //   self.showAlert(message: (responsesdict.value(forKey: "tag") as? String)!)
                    
                    DispatchQueue.main.async {

                    let alertController = UIAlertController(title: "GHMC", message: responsesdict.value(forKey: "compid") as? String, preferredStyle: .alert)
                    
                     alertController.addAction(UIAlertAction.init(title:"OK", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                                                                         let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                                                         appDelegate.openDashboard()
                                                                     }))
                    self.present(alertController, animated: true, completion: nil)
                                                                         
                    }
                    
                    
                }
                else
                {
                    self.showAlert(message: "server not responding, please try again later!")
                }
                //
                
                break
                
            case .failure:
                
                DispatchQueue.main.async {

                self.showAlert(message:"Error occured.please try agin later")
                PKHUD.sharedHUD.hide()
                }
                
                break
//            default:
//              //  print("error")
//                DispatchQueue.main.async {
//
//                PKHUD.sharedHUD.hide()
//                self.showAlert(message:"Error occured.please try agin later")
//                }
//                
//                
//                break
                
            }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
