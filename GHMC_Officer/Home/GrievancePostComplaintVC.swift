//
//  GrievancePostComplaintVC.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 07/05/20.
//  Copyright © 2020 IOSuser3. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces
import Alamofire
import PKHUD
import GoogleMaps
import MobileCoreServices
class GrievancePostComplaintVC: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate, CLLocationManagerDelegate,GMSMapViewDelegate, UITextFieldDelegate, UITextViewDelegate,UIDocumentPickerDelegate,UIDocumentMenuDelegate{
    @IBOutlet var backgroundImg: UIImageView!
    var latlongCheck:Bool?
    var latitude:Double!
    var longitude:Double!
    var categoryTypeArray : [GrievanceSubCategoryStruct]?
    var categoryID:String!
    var locationManagerager = CLLocationManager()
    let types: [String] = [kUTTypePDF as String]
    var catrgoryTypePicker: UIPickerView! = UIPickerView()
    var imagesPicker: UIImagePickerController! = UIImagePickerController()
    var locationManager:CLLocationManager!
    @IBOutlet weak var submitAction: UIButton!
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var nameText: UITextField!
    @IBOutlet var categorySelect: UITextField!
    @IBOutlet var landmarkText: UITextField!
    @IBOutlet var mobileText: UITextField!
    @IBOutlet var descriptionText: UITextView!
    @IBOutlet var image1Btn: UIButton!
    @IBOutlet var image2Btn: UIButton!
    @IBOutlet var image3Btn: UIButton!
    @IBOutlet weak var segmentctrlheight: NSLayoutConstraint!
    var imagestr1:String!
    var imagestr2:String!
    var imagestr3:String!
    var modeId:String?
    var tag: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UserDefaults.standard.value(forKey:"bgImagview") as! String
        backgroundImg.image = UIImage.init(named:image)
        self.segmentControl.isHidden = true
        self.segmentctrlheight.constant=0
        mobileText.text = UserDefaults.standard.string(forKey: "MOBILENUMBER")!
        nameText.text = UserDefaults.standard.string(forKey: "EMP_NAME")!
        modeId = UserDefaults.standard.value(forKey:"MODEID") as? String
        mobileText.isUserInteractionEnabled = false
        categorySelect.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 8, height: categorySelect.frame.height))
        categorySelect.leftViewMode = .always
        nameText.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 8, height: nameText.frame.height))
        nameText.leftViewMode = .always
        landmarkText.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 8, height: landmarkText.frame.height))
        landmarkText.leftViewMode = .always
        mobileText.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 8, height: mobileText.frame.height))
        mobileText.leftViewMode = .always
        self.categorySelect.delegate = self
        self.mobileText.delegate = self
        self.nameText.delegate = self
        self.descriptionText.delegate = self
        self.landmarkText.delegate = self
        descriptionText.text = "Description"
        descriptionText.textColor = UIColor.lightGray
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        super.viewDidLoad()
        imagestr1 = " "
        imagestr2 = " "
        imagestr3 = " "
        setupUI()
        if Reachability.isConnectedToNetwork() {
            currentLocation()

        }else {
            showAlert(message:interNetconnection)
        }
        latlongCheck = false
        image1Btn .isSelected = false
        image2Btn .isSelected = false
        image3Btn .isSelected = false
        self.categorySelect.inputView = catrgoryTypePicker
        self.catrgoryTypePicker.delegate = self
        self.catrgoryTypePicker.dataSource = self
        self.imagesPicker.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          guard Reachability.isConnectedToNetwork() else {showAlert(message:"No internet connection");return}
          //check weather the user in ghmc or not
          whereAmIService { [weak self](resp) in
              guard let whereami = resp else {return}
              if whereami.zone == "" || whereami.zone?.count == 0{
                  DispatchQueue.main.async {
                      self?.showAlertWithOkAction(message: "cannot post complaint. it seems like your location is out of GHMC", OkCompletion: { (action) in
                        self?.navigationController?.popViewController(animated: true)
                      })
                  }
              }
          }
      }
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        if textView.textColor == UIColor.lightGray {
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = UIColor.lightGray
        }
    }
    func setupUI(){
        nameText.layer.cornerRadius = 4
        categorySelect.layer.cornerRadius = 4
        landmarkText.layer.cornerRadius = 4
        mobileText.layer.cornerRadius = 4
        descriptionText.layer.cornerRadius = 4
        image1Btn.layer.cornerRadius = 4
        image2Btn.layer.cornerRadius = 4
        image3Btn.layer.cornerRadius = 4
        submitAction.layer.cornerRadius = 4
        nameText.layer.borderWidth = 1
        categorySelect.layer.borderWidth = 1
        landmarkText.layer.borderWidth = 1
        mobileText.layer.borderWidth = 1
        descriptionText.layer.borderWidth = 1
        categorySelect.layer.borderColor = UIColor.white.cgColor
        nameText.layer.borderColor = UIColor.white.cgColor
        descriptionText.layer.borderColor = UIColor.white.cgColor
        landmarkText.layer.borderColor = UIColor.white.cgColor
        mobileText.layer.borderColor = UIColor.white.cgColor
        nameText.clipsToBounds = true
        categorySelect.clipsToBounds = true
        mobileText.clipsToBounds = true
        descriptionText.clipsToBounds = true
        landmarkText.clipsToBounds = true
        image3Btn.clipsToBounds = true
        image2Btn.clipsToBounds = true
        image1Btn.clipsToBounds = true
        submitAction.clipsToBounds = true

    }
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //       print("locations = \(locations)")
        for location in locations {
            print(location)
            //   print(location.coordinate.latitude,  location.coordinate.longitude)

            if latlongCheck == false
            {
             //   print(location.coordinate.latitude,  location.coordinate.longitude)
                latlongCheck = true
            }
        }
    }

    func determineCurrentLocation()
    {
        locationManagerager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            //locationManager.startUpdatingHeading()
            locationManagerager.startUpdatingLocation()
        }
    }
    func currentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
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
    func openDocument(){
       let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
       documentPicker.delegate = self
       documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
    }
    @IBAction func didTaponPhoto(_ sender: UIButton) {
    
    switch sender.tag {
        case 0:
            tag = 0
            break
        case 1:
            tag = 1
            break
        case 2:
            tag = 2
            break
        default:
            break
        }
        let controller = UIAlertController(title: "Select a picture which properly describes the issue!", message: nil, preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (action) in
          //  print("Choosed Camera")
            self.camera()
        }))
        controller.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { (action) in
          //  print("Choosed Gallery")

        self.photoLibrary()

        }))
        controller.addAction(UIAlertAction(title: "Choose Document", style: .default, handler: { (action) in
                 //  print("Choosed Document")
        self.openDocument()

               }))

        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
         //   print("Cancelled")

        }))
        if let popoverController = controller.popoverPresentationController {
          popoverController.sourceView = self.view
          popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
          popoverController.permittedArrowDirections = []
        }
        self.present(controller, animated: true, completion: nil)

    }
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {

        if tag == 0
               {
                let data = try! Data(contentsOf: urls[0])
                image1Btn.setImage(UIImage(named: "pdfnew"), for:.normal)
                image1Btn .isSelected = true
                imagestr1  = data.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
                // print(fileStream)
              }

         else if tag == 1
        {
            let data = try! Data(contentsOf: urls[0])
            image2Btn.setImage(UIImage(named: "pdfnew"), for:.normal)
            image2Btn .isSelected = true
             imagestr2  = data.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        }
        else if tag == 2
        {
             let data = try! Data(contentsOf: urls[0])
             image3Btn .isSelected = true
             image3Btn.setImage(UIImage(named: "pdfnew"), for:.normal)
             imagestr3  = data.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        }


            }

       public func documentMenu(_ picker:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
           documentPicker.delegate = self
           self.present(documentPicker, animated: true, completion: nil)
       }


       func documentPickerWasCancelled(_ picker: UIDocumentPickerViewController) {
             print("view was cancelled")
           picker.dismiss(animated: true, completion: nil)
       }


    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }



   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        NSLog("\(info)")

        if tag == 0
        {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                image1Btn.setImage(image, for: .normal)
                dismiss(animated: true, completion: nil)
                image1Btn .isSelected = true
                    let image1 : UIImage = image
                    let imageData:NSData = image1.jpeg1(.lowest)! as NSData
                    imagestr1 = imageData.base64EncodedString(options: .lineLength64Characters)
                           }
        }
     else if tag == 1{
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            image2Btn.setImage(image, for: .normal)
            dismiss(animated: true, completion: nil)
            image2Btn .isSelected = true
            let image2 : UIImage = image
            let imageData:NSData = image2.jpeg1(.lowest)! as NSData
            imagestr2 = imageData.base64EncodedString(options: .lineLength64Characters)
        }
        }else if tag == 2{
   if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            image3Btn.setImage(image, for: .normal)
            dismiss(animated: true, completion: nil)
            image3Btn .isSelected = true
        let image3 : UIImage = image
        // let imageData:NSData = image1.pngData()! as NSData
        let imageData:NSData = image3.jpeg1(.lowest)! as NSData
        imagestr3 = imageData.base64EncodedString(options: .lineLength64Characters)
            }
    }
    }
    @IBAction func didTaponSubmit(_ sender: Any) {

        if IsdataValid () {
            guard Reachability.isConnectedToNetwork()
                else {showAlert(message:"No internet connection");return}
                      self.insertGrievanceService()
        }
    }
    func IsdataValid() -> Bool{
        if nameText.text!.count == 0 {
            showAlert(message:"Please Enter Name")
            return false
        } else if categorySelect.text!.count == 0 ||
            categorySelect.text == "Select type" ||
            categorySelect.text == "Please select" {
            showAlert(message:"Please select category")
            return false
        } else if mobileText.text!.count == 0{
            showAlert(message:"please enter mobile number")
            return false
        } else if mobileText.text!.isValidMobileNumber() == false{
            showAlert(message:"please enter valid mobile number")
            return false
        } else if imagestr1 == " "  &&
            imagestr2 == " " &&
            imagestr3 == " " {
            showAlert(message:"please select atlease one photo")
            return false
        } else {
            return true
        }
    }

    func whereAmIService( completion : @escaping((WhereAmIStruct?) -> ()))
        {
        print("\(latitude)","\(longitude)")
           guard let lat = latitude , let long = longitude else {self.showAlert(message: "Unable to Fetch Location Information Please try again later");return}
            let parameters : [String : Any] = [
            "userid": "cgg@ghmc",
            "password": "ghmc@cgg@2018",
            "latitude" : String(lat),
            "longitude" : String(long)
           ]
            NetworkRequest.makeRequest(type: WhereAmIStruct.self, urlRequest: Router.whereIam(Parameters: parameters)) { (result) in
                switch result
                {
                case .success(let resp):
                    completion(resp)
                case .failure(let err):
                    print(err)
                    completion(nil)
                }
            }
        }
    func insertGrievanceService(){
        guard let lat = latitude , let long = longitude else {return}
        if imagestr1 == "" {
            imagestr1 = "photo"
        }else  if imagestr2 == "" {
            imagestr2 = "photo2"
        }
        else  if imagestr3 == "" {
            imagestr3 = "photo3"
        }
        let mobilenumber = "\(mobileText.text!)-\(mobileText.text!)"
            
            let username = nameText.text!
        let latitude = String(lat)
        let longitude = String(long)
            let dict:Parameters = ["userid":"cgg@ghmc",
                                   "password":"ghmc@cgg@2018",
                                   "compType":categoryID ?? "",
                                   "landmark":landmarkText.text!,
                                   "remarks":descriptionText.text!,
                                   "photo":imagestr1!,
                                   "photo2":imagestr2!,
                                   "photo3":imagestr3!,
                                   "latlon":"\(latitude),\(longitude)",
                                   "mobileno":mobilenumber,
                                   "deviceid":deviceId,
                                   "username":username,
                                   "ward":"0",
                                   "source":"20",
                                   "empid":"",
                                   "agentid":""
            ]
            NetworkRequest.makeRequest(type: InsertGrievanceStruct.self, urlRequest: Router.insertGrievance(Parameters: dict)) { [unowned self](result) in
                          switch result
                          {
                          case .success(let resp) :
                              print(resp)
                              guard let status = resp.status , status == "True" else {DispatchQueue.main.async {
                                  self.showAlert(message: resp.compid ?? "Failed to register Complaint")
                                  }; return}
                              DispatchQueue.main.async {
                                  self.showAlertWithOkAction(message: resp.compid!) { (action) in
                                    self.navigationController?.popViewController(animated: true)

                                    //  self.homeButtonClicked()
                                  }
                              }
                          case .failure( _) :
                              DispatchQueue.main.async {
                                  self.showAlert(message: "Server not responding")
                              }
                          }
                      }
    }
}



extension GrievancePostComplaintVC : UIPickerViewDelegate, UIPickerViewDataSource, GMSAutocompleteViewControllerDelegate
{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)

    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1

    }
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return categoryTypeArray?.count ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryTypeArray?[row].type
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        categorySelect.text = categoryTypeArray?[row].type
        categoryID = categoryTypeArray?[row].id

    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel;

        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()

            pickerLabel?.font = UIFont(name: "Montserrat", size: 16)
            pickerLabel?.textAlignment = NSTextAlignment.center
        }

        pickerLabel?.text = categoryTypeArray?[row].type

        return pickerLabel!;
    }

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        catrgoryTypePicker.isHidden = false
        return false
    }

    func convertImageToBase64(image: UIImage) -> String {
        return image.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    
    }
}



extension String{
    public func isValidMobileNumber() -> Bool {
        let numberRegEx = "^((\\+91)|0)?[6789][0-9]{9}$"
        let numberTest = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
        return numberTest.evaluate(with: self)
}
}
// MARK: - WhereAmIStruct
struct WhereAmIStruct: Decodable {
    let wardID, wardName, circlename, zone: String?
    let status: Bool?

    enum CodingKeys: String, CodingKey {
        case wardID = "ward_id"
        case wardName = "ward_name"
        case circlename
        case zone = "Zone"
        case status
    }
}

struct InsertGrievanceStruct : Decodable {
    let status : String?
    let compid : String?
}
extension UIImage {
    enum JPEGQuality1: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg1(_ jpegQuality: JPEGQuality1) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
