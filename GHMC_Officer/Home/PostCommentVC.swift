//
//  PostCommentVC.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 19/05/20.
//  Copyright © 2020 IOSuser3. All rights reserved.
//

import UIKit
import CoreLocation
import PKHUD
import Alamofire

class PostCommentVC: UIViewController, CLLocationManagerDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate{

    
    @IBOutlet var backgroundImg: UIImageView!
    
    var recieveArray: [Grievance] = []
    @IBOutlet var selectSegment: UISegmentedControl!
    @IBOutlet var remarks: UITextView!
    @IBOutlet var submitBtn: UIButton!
    @IBOutlet var heightManageConstraint: NSLayoutConstraint!
    @IBOutlet var selctPhoto: UIButton!
    
    var userCurrentLoaction = CLLocation()
    

    
    var photo: UIImage?
    var statusID: String?

    var isSelectedPhoto: Bool?
    
    var latlongCheck:Bool?
    var latlongStr: String?
    var locationManager = CLLocationManager()


//    var catrgoryTypePicker: UIPickerView! = UIPickerView()
    var imagesPicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
          let image = UserDefaults.standard.value(forKey:"bgImagview") as! String
            backgroundImg.image = UIImage.init(named:image)
        latlongCheck = false
        self.remarks.delegate = self
      //  remarks.text = "Remarks"

        
        currentLocation()
        setupUI()

         isSelectedPhoto = true
      

            }
    func textViewDidBeginEditing(_ textView: UITextView) {
         textView.text = ""
         
     }

   


    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func setupUI()
  {
    remarks.layer.cornerRadius = 5.0
    remarks.layer.borderColor = UIColor.white.cgColor
    remarks.layer.borderWidth = 1.0
    submitBtn.layer.cornerRadius = 5.0
    remarks.clipsToBounds = true
    submitBtn.clipsToBounds = true
    }
    func currentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {

            if latlongCheck == false
            {
                latlongStr = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
             //   latlongStr = "17.4428238,78.4052732"
                
               
             //   print(latlongStr!)
            //    latlongStr = "\(location.coordinate.latitude,  location.coordinate.longitude)"
                latlongCheck = true
            }
        }
    }


    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagesPicker.delegate = self
            imagesPicker.sourceType = .camera
            self.present(imagesPicker, animated: true, completion: nil)
        }

    }
    func photoLibrary()
    {

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagesPicker.delegate = self
            imagesPicker.sourceType = .photoLibrary
            self.present(imagesPicker, animated: true, completion: nil)
        }
    }

    @IBAction func didTaponType(_ sender: Any) {
        
        if selectSegment.selectedSegmentIndex == 0
        {
            selctPhoto.isHidden = false
            heightManageConstraint.constant = 30
            isSelectedPhoto = true;

          //  selctPhoto.setImage(nil, for: .normal)

            
        }else
        {
            selctPhoto.isHidden = true
            heightManageConstraint.constant = -50
            isSelectedPhoto = false;

          //  selctPhoto.setImage(nil, for: .normal)
        }
        
    }
    
   
    
    @IBAction func didTaponSubmit(_ sender: Any) {
        
        
        var photoInBase64 = ""
        if isSelectedPhoto == true {
            
            
            if photo == nil
            {
                self.showAlert(message: "Please select photo and try again.")
                return
            }
                  // let imageData:NSData = image1.pngData()! as NSData
                       let imageData:NSData = photo!.jpeg(.lowest)! as NSData


            photoInBase64 = (imageData.base64EncodedString(options: .lineLength64Characters))
            
        }
        else
        {
            photoInBase64 = ""
        }
        
        if (remarks.text == "Remarks") || remarks.text.count == 0 {
            self.showAlert(message: "Please enter remarks.")
            return
        }
        else
        {
        
        
          //  print(latlongStr!)
            let deviceID = UIDevice.current.identifierForVendor?.uuidString
         //   print(deviceID!)
            let compId = recieveArray[0].id
            let username = recieveArray[0].userName
            let phone = recieveArray[0].mobileno
            let coccate = username + "-" + phone
          //  print(coccate)
      //      let phonename = "\((recieveArray?.value(forKey: "mobileno") as AnyObject).object(at: 0) as? String)"+"-" + "\((recieveArray?.value(forKey: "user_name") as AnyObject).object(at: 0) as? String)"
            let status = recieveArray[0].gstatus
            
            
            if (status == "Under Process") {
                statusID = "3"
            } else if (status == "Open") {
                statusID = "2"
            } else if (status == "Closed") {
                statusID = "1"
            } else if (status == "Forward to another ward") {
                statusID = "4"
            } else if (status == "Closed - Funds Related Issue") {
                statusID = "5"
            } else if (status == "Closed - Non-GHMC") {
                statusID = "6"
            }
      //   var remarksStr = replacings
            let remarksStr = remarks.text.replacingOccurrences(of: "&", with: "and")
        
                
                self.loading(text:"Loading Details..")
                PKHUD.sharedHUD.show(onView: self.view)
                
                
            let parameters: Parameters = ["userid" : "cgg@ghmc","password" : "ghmc@cgg@2018", "remarks" : remarksStr,    "photo" : photoInBase64, "latlon": latlongStr!, "mobileno" : coccate, "deviceid" : deviceID!, "updatedstatus" : statusID!, "compId" : compId]
          //  print(parameters);
                
                Alamofire.request(Router.postcommentService(parameters: parameters)).responseJSON { response in
                    PKHUD.sharedHUD.hide()
                    
                    
                    switch response.result{
                    case .success:
                        
                        let responsesdict = response.result.value as! NSDictionary
                        
                      //  print(responsesdict)
                        
                        
                        if responsesdict.value(forKey: "status") as? String == "True"
                        {
                            
                         //   self.showAlert(message: (responsesdict.value(forKey: "compid") as? String)!)
                            
                            let alertController = UIAlertController(title: "GHMC", message: responsesdict.value(forKey: "compid") as? String, preferredStyle: .alert)
                            
                            alertController.addAction(UIAlertAction.init(title:"OK", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                                                       let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                                       appDelegate.openDashboard()
                                                   }))
                                                   self.present(alertController, animated: true, completion: nil)
                                                       
                            
                            

                        }
                        else
                        {
                            DispatchQueue.main.async {

                            self.showAlert(message: "server not responding, please try again later!")
                            }
                        }
//
                        
                        break
                        
                    case .failure:
                        
                        DispatchQueue.main.async {

                        self.showAlert(message:"Error occured.please try agin later")
                        PKHUD.sharedHUD.hide()
                        }
                        
                        break
//                    default:
//                        print("error")
//
//                        DispatchQueue.main.async {
//
//                        PKHUD.sharedHUD.hide()
//                        self.showAlert(message:"Error occured.please try agin later")
//                        }

                        
                  //      break
                        
               }
            }
        }
    }
        

        
    @IBAction func didTaponImage(_ sender: Any) {
        
        
        let controller = UIAlertController(title: "Select a picture which properly describes the issue!", message: nil, preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (action) in
         //   print("Choosed Camera")
            self.camera()


        }))

        controller.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { (action) in
          //  print("Choosed gallery")



            self.photoLibrary()

        }))

        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
          //  print("Cancelled")

        }))

        self.present(controller, animated: true, completion: nil)

        
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }



   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        NSLog("\(info)")


             photo = info[.originalImage] as? UIImage
            selctPhoto.setImage(photo, for: .normal)
            dismiss(animated: true, completion: nil)
            selctPhoto .isSelected = true


    }
}
extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
