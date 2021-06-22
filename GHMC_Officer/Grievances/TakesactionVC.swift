//
//  TakesactionVC.swift
//  GHMC_Officer
//
//  Created by deep chandan on 19/04/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//

import UIKit
import DropDown
import CoreLocation
import GoogleMaps
import GooglePlaces
import MobileCoreServices

class TakesactionVC: UIViewController,UIImagePickerControllerDelegate,CLLocationManagerDelegate,UIPickerViewDelegate, UIPickerViewDataSource ,UITextViewDelegate,UIDocumentPickerDelegate,UIDocumentMenuDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var complaintBtn: UIButton!
    @IBOutlet weak var wardnameBtn: UIButton!
    @IBOutlet weak var vehicleTypeBtn: UIButton!
    @IBOutlet weak var nofTripsTF: UITextField!
    @IBOutlet weak var totalnetWtTF: UITextField!
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var cameraImg: UIImageView!
    var imagestr1:String!
    let types: [String] = [kUTTypePDF as String]
    var imagesPicker: UIImagePickerController! = UIImagePickerController()
    var locationManager:CLLocationManager?
    var vehicleDataModel:[vehiclesFullData]?
    var vehicleId:String?
    var vehicledatasourceArry:[String] = []
    var location:String? = nil
    var myComplaintId:String?
    let complaintId:String? = nil
    let dropdown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UserDefaults.standard.value(forKey:"bgImagview") as! String
       let modeId = UserDefaultVars.modeID
        let subcatId = UserDefaultVars.subcatId
        let designation = UserDefaultVars.designation
        self.descriptionTV.text = "Enter Reramrks"
        descriptionTV.textColor = UIColor.darkGray
        self.imagesPicker.delegate = self
        self.imagestr1 = ""
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = UIColor.init(patternImage:UIImage.init(named:image)!)
        
        getVehicleIds()


       // subcatId = "34"

      //  modeId = "15"
      //  print("modeidresponse",modeId ?? "")

        self.navigationController?.navigationBar.isHidden = true
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
    }
    @IBAction func complaintBtnClick(_ sender: UIButton) {
       
    }
    
    @IBAction func wardnameBtnClick(_ sender: UIButton) {
    }
    
    @IBAction func vehicleTypeBtnClick(_ sender: UIButton) {
        print(vehicledatasourceArry)
        dropdown.dataSource = vehicledatasourceArry 
        dropdown.anchorView = sender
        dropdown.show()
        dropdown.selectionAction = {[unowned self] (index : Int , item : String) in
            //  print("selected index \(index) item \(item)")
            
            sender.setTitle(item, for: .normal)
            vehicleTypeBtn.setTitleColor(.black, for: .normal)
            self.vehicleId = self.vehicleDataModel?[index].slno
            self.dropdown.hide()
//            self.noofTons = Int((vehicletypeBtn.currentTitle?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())! )
            //  self.noofTons = String(Tons ?? 0)
                    }
    }
    func getVehicleIds(){
        
        let params  = ["userid":userid,
                        "password":password]
        
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message:noInternet);return}
        NetworkRequest.makeRequestArray(type: vehiclesFullData.self, urlRequest: Router.getRamkeyVehicles(Parameters: params)) { [weak self](result) in
            switch result
            {
            case  .success(let
                            vehicleData):
                print(vehicleData)
                if vehicleData != nil {
                    self?.vehicleDataModel = vehicleData
                    self?.vehicleDataModel?.forEach({self?.vehicledatasourceArry.append($0.vehicleNumber ?? "")})
                  //  print(self?.vehicledatasourceArry)
                    
                   
                } else {
                    self?.showAlert(message:serverNotResponding)
                }
                
            case .failure(let err):
                print(err)
                self?.showAlert(message: serverNotResponding)
            }
        }
     
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        location = "\(locValue.latitude),\(locValue.longitude)"
        UserDefaults.standard.set(location, forKey:"locationl")
      //  print(location)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.vehicleDataModel?.count ?? 0
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

       // self.present(importMenu, animated: true, completion: nil)
    }
    @objc func imagegestureAction(){

        let controller = UIAlertController(title: "Select a picture which properly describes the issue!", message: nil, preferredStyle: .actionSheet)


            controller.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (action) in
             //   print("Choosed Camera")
                self.camera()


            }))

            controller.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { (action) in
              //  print("Choosed Gallery")

            self.photoLibrary()

            }))
            controller.addAction(UIAlertAction(title: "Choose Document", style: .default, handler: { (action) in
                    //   print("Choosed Document")
            self.openDocument()

                   }))

            controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                print("Cancelled")

            }))
        
        if let popoverController = controller.popoverPresentationController {
          popoverController.sourceView = self.view
          popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
          popoverController.permittedArrowDirections = []
        }
            self.present(controller, animated: true, completion: nil)

        }
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let data = try! Data(contentsOf: urls[0])
        self.cameraImg.image = UIImage(named:"pdfnew")
        imagestr1  = data.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
    }
    public func documentMenu(_ picker:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    
    func documentPickerWasCancelled(_ picker: UIDocumentPickerViewController) {
        //   print("view was cancelled")
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }


    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        NSLog("\(info)")
        
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            dismiss(animated: true, completion: nil)
            self.cameraImg.image = image
            let image1 : UIImage = image
            let imageData:NSData = image1.jpeg(.lowest)! as NSData
            imagestr1 = imageData.base64EncodedString(options: .lineLength64Characters)
                    }
           

       }
    @IBAction func submitClick(_ sender: Any) {
    }


}
//struct vehiclesFullData : Decodable {
//    let sLNO : String?
//    let vEHICLE_NUMBER : String?
//    
//    enum CodingKeys: String, CodingKey {
//        
//        case sLNO = "SLNO"
//        case vEHICLE_NUMBER = "VEHICLE_NUMBER"
//    }
//}
// MARK: - LoginStructElement
struct vehiclesFullData: Codable {
    let slno, vehicleNumber: String?

    enum CodingKeys: String, CodingKey {
        case slno = "SLNO"
        case vehicleNumber = "VEHICLE_NUMBER"
    }
}
