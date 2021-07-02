//
//  Utility.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 04/09/19.
//  Copyright © 2019 IOSuser3. All rights reserved.
//

import Foundation
import  UIKit
import PKHUD

extension UIViewController {
    func showAlert(message: String , okcompletion : (()->())? = nil)
{
    let alert = UIAlertController(title: "GHMC Officer", message:message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
        okcompletion?()
        
    }))
    self.present(alert, animated: true, completion: nil)
    
}
  func showAlertWithYesNoCompletions(message: String ,noCompletion : (()->())? = nil,Yescompletion : (()->())? = nil)
{
  let alert = UIAlertController(title: "GHMC Officer", message:message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.destructive, handler: { (action) in
        noCompletion?()
        
    }))
  alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action) in
      Yescompletion?()
      
  }))
    
    
  self.present(alert, animated: true, completion: nil)
  
}
  
  
    func loading(text: String)
    {
        PKHUD.sharedHUD.contentView = PKHUDTextView(text: text)
        PKHUD.sharedHUD.show()
        
    }
   func loading1(text:String){
      PKHUD.sharedHUD.contentView = PKHUDTextView(text: text)
    }
    
    public  func showAlertWithOkAction(message : String , OkCompletion : @escaping (UIAlertAction)->Void)  {
            let alert = UIAlertController(title: "GHMC Officer", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
                OkCompletion(alertAction)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    
    
    
}
class myclas{
    class func something(){
        print("my class")
    }
    
}
func isValidPhone(testStr:String) -> Bool {
    let phoneRegEx = "^[6-9]\\d{9}$"
    var phoneNumber = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
    return phoneNumber.evaluate(with: testStr)
}
func convertImageToBase64String (img: UIImage) -> String {
    return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
}
class CustomImagePicker: UIImageView , UIImagePickerControllerDelegate , UINavigationControllerDelegate  {

    var parentViewController : UIViewController!
    var isImagePicked : Bool = false


    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)

        let tapGuesture = UITapGestureRecognizer()
        tapGuesture.numberOfTapsRequired = 1
        tapGuesture.addTarget(self, action: #selector(handleClickOnImageview(_:)))
        self.isUserInteractionEnabled = true
            // self.image = self.changeImageColor(color: UIColor(named: "PrimaryColor")!)
        self.addGestureRecognizer(tapGuesture)

    }



    @objc func handleClickOnImageview(_ sender : Any)

    {

        self.openActionSheet(options: ["Take a Photo", "Choose from Gallery"], imagePicker: UIImagePickerController())

    }



    func openActionSheet(options:[String],imagePicker:UIImagePickerController) -> Void {

        let actionSheet = UIAlertController(title: "Please Choose an Option", message: nil, preferredStyle: .actionSheet)

        let takePhotoAction = UIAlertAction(title: options[0], style: .default) { (takePhotoAction) in

            self.openCamera(imagePicker: imagePicker)

        }

        let photoGalleryAction = UIAlertAction(title: options[1], style: .default) { (photoGalleryAction) in

            self.openGallery(imagePicker: imagePicker)

        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        actionSheet.addAction(takePhotoAction)

        actionSheet.addAction(photoGalleryAction)

        actionSheet.addAction(cancelAction)

        DispatchQueue.main.async {
            self.parentViewController.present(actionSheet, animated: true, completion: nil)
        }


    }



    func openCamera(imagePicker:UIImagePickerController) -> Void {

        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){

            imagePicker.delegate = self

            imagePicker.allowsEditing = true

            imagePicker.sourceType = .camera

            parentViewController.present(imagePicker, animated: true, completion: nil)

        }

        else{

            let alert = UIAlertController(title: "RedCross,", message: "You don't have permissions to access camera", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

            parentViewController.present(alert, animated: true, completion: nil)

        }

    }



    func openGallery(imagePicker:UIImagePickerController) -> Void {



        imagePicker.delegate = self

        imagePicker.allowsEditing = true

        imagePicker.sourceType = .photoLibrary



        parentViewController.present(imagePicker, animated: true, completion: nil)

    }



    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        isImagePicked = true
        let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        self.contentMode = .scaleToFill
        self.image = pickedImage
        picker.dismiss(animated: true, completion: nil)





    }





}


