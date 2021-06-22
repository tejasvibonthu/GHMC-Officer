//
//  DetailCheckStatusVC.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 15/05/20.
//  Copyright © 2020 IOSuser3. All rights reserved.
//

import UIKit
import PKHUD
import Alamofire
import SDWebImage

class DetailCheckStatusVC: UIViewController {

    var recieveDict : NSDictionary = [:]
    var grievanceArray: [Grievance] = []
    var commentsArray: [Comment] = []
    
    
    @IBOutlet var backgroundImg: UIImageView!
    
    @IBOutlet var complaintID: UILabel!
    @IBOutlet var complaintType: UILabel!
    @IBOutlet var status: UILabel!
    @IBOutlet var mobileNo: UILabel!
    @IBOutlet var remarks: UILabel!
    @IBOutlet var postedBy: UILabel!
    @IBOutlet var assignedTo: UILabel!
    @IBOutlet var landmark: UILabel!
    @IBOutlet var myScroll: UIScrollView!
    @IBOutlet var image1: UIImageView!
    @IBOutlet var image2: UIImageView!
    @IBOutlet var image3: UIImageView!
    @IBOutlet var viewComments: UIButton!
    @IBOutlet var postComments: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
           let image = UserDefaults.standard.value(forKey:"bgImagview") as! String
             backgroundImg.image = UIImage.init(named:image)
            setupUI()
        
        
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func backClicked(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
    }
    func setupUI()
    {
        myScroll.layer.cornerRadius = 4.0
        image1.layer.cornerRadius = 4.0
        image2.layer.cornerRadius = 4.0
        image3.layer.cornerRadius = 4.0
        viewComments.layer.cornerRadius = 4.0
        postComments.layer.cornerRadius = 4.0
        
        
        if grievanceArray[0].gstatus == "Open"
        {
            postComments.setTitle("Post Comments", for: .normal)
            postComments.tag = 1
        }
        else if grievanceArray[0].gstatus == "Closed" || grievanceArray[0].gstatus == "Closed - Funds Related Issue" || grievanceArray[0].gstatus == "Closed - Non-GHMC"
        {
            if grievanceArray[0].feedback == "yes"
            {
                postComments.setTitle("ReOpen", for: .normal)
                postComments.tag = 3
            }
            else
            {
                postComments.setTitle("Post Feedback", for: .normal)
                postComments.tag = 2
            }
        }
        
        
        complaintID.text = grievanceArray[0].id
        complaintType.text = grievanceArray[0].type
        landmark.text = grievanceArray[0].landmark
        mobileNo.text = grievanceArray[0].mobileno
        status.text = grievanceArray[0].gstatus
        postedBy.text = grievanceArray[0].userName
        remarks.text =  grievanceArray[0].remarks
        assignedTo.text =  grievanceArray[0].assignedto
        image1.sd_setImage(with: URL(string: grievanceArray[0].photo), placeholderImage: UIImage(named: "placeholder.png"))
        image2.sd_setImage(with: URL(string: grievanceArray[0].photo2), placeholderImage: UIImage(named: "placeholder.png"))
        image3.sd_setImage(with: URL(string: grievanceArray[0].photo3), placeholderImage: UIImage(named: "placeholder.png"))
        
        
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        image1.isUserInteractionEnabled = true
        image2.isUserInteractionEnabled = true
        image3.isUserInteractionEnabled = true
        
        image1.addGestureRecognizer(tapRecognizer)
        image2.addGestureRecognizer(tapRecognizer)
        image2.addGestureRecognizer(tapRecognizer)
        
        
        
        
        
    }
    
    
    @objc func imageTapped(gestureRecognizer: UITapGestureRecognizer) {
        
        //        var img1: UIImage? = image1.image
        //        var img2: UIImage? = image2.image
        //        var img3: UIImage? = image3.image
        //
        //
        //       // var arrImages:Array<Any>?
        //        var arrImages = [String]()
        //
        //        if img1 != nil {
        //            if let img1 = img1 {
        //                arrImages.append(image1.image)
        //            }
        //        }
        //        if img2 != nil {
        //            if let img2 = img2 {
        //                arrImages.append(img2)
        //            }
        //        }
        //        if img3 != nil {
        //            if let img3 = img3 {
        //                arrImages.append(img3)
        //            }
        //        }
        //        if arrImages != nil && arrImages.count != 0 {
        //            performSegue(withIdentifier: "ShowScrollImageViewController", sender: arrImages)
        //        } else {
        //         //   showAlert(withMessage: "Images not available!")
        //        }
    }
    
    @IBAction func postCommentsClicked(_ sender: Any) {
        
        if postComments.tag == 1 {
            
            let VC = storyboards.HomeStoryBoard.instance.instantiateViewController(withIdentifier: "PostCommentVC") as! PostCommentVC
            VC.recieveArray = grievanceArray
            self.navigationController?.pushViewController(VC, animated: true)
            
            
//            let VC = storyboards.HomeStoryBoard.instance.instantiateViewController(withIdentifier: "PostFeedBackVC") as! PostFeedBackVC
//            VC.recieveArray = grievanceArray
//            self.navigationController?.pushViewController(VC, animated: true)
            
          //  print("post comment")
        }
        else if postComments.tag == 2 {
          //  print("post feedback")
            
            let VC = storyboards.HomeStoryBoard.instance.instantiateViewController(withIdentifier: "PostFeedBackVC") as! PostFeedBackVC
            VC.recieveArray = grievanceArray
            self.navigationController?.pushViewController(VC, animated: true)
//
        }
        else if postComments.tag == 3 {
          //  print("Reopen")
            
            reopenService()
        }
        
        
    }
    
    @IBAction func viewCommentsClicked(_ sender: Any) {
        
        if commentsArray[0].flag == "fail"
        {
          //  print("No Comments available")
            DispatchQueue.main.async {
                
                self.showAlert(message: "No Comments available")
            }
        }
        else
        {
            let VC = storyboards.HomeStoryBoard.instance.instantiateViewController(withIdentifier: "ViewCommentsVC") as! ViewCommentsVC
            VC.recieveCommentArrays = commentsArray
            self.navigationController?.pushViewController(VC, animated: true)
        }
        
        
        
    }
    
    func reopenService()
    {
        let id:String = complaintID.text!
      //  print(id)
        
        self.loading(text:"Loading Details..")
        PKHUD.sharedHUD.show(onView: self.view)
        
        let parameters: Parameters = ["userid" : "cgg@ghmc","password" : "ghmc@cgg@2018", "compId" : id]
        
        Alamofire.request(Router.reopenserviceCall(parameters: parameters)).responseJSON { response in
            PKHUD.sharedHUD.hide()
            
            
            switch response.result{
            case .success:
                
                let responsesdict = response.result.value as! NSDictionary
                //      self.responseArray = responsesdict.value(forKey: "viewGrievances") as! NSArray
                
                //  print(responsesdict .value(forKey: "compid")!)
                DispatchQueue.main.async {
                    
                    self.showAlert(message: responsesdict .value(forKey: "compid")! as! String)
                }
                
                
                break
                
            case .failure(let error):
                print(error)
                
                DispatchQueue.main.async {
                    
                    PKHUD.sharedHUD.hide()
                    
                    
                    self.showAlert(message: "Server not found. please try agin later")
                }
                
                // self.displayAlertMessage(body:"Error occured.please try agin later", theme:.error)
                break
//            default:
//                print("error")
//                DispatchQueue.main.async {
//                    
//                    PKHUD.sharedHUD.hide()
//                    self.showAlert(message: "Server not found, Please try agin later")
//                }
//                
//                
//                break
                
            }
        }
        
        
    }
    
  
    
}
