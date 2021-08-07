//
//  CustomImageView.swift
//  GHMC_Officer
//
//  Created by naresh banavath on 02/07/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//

import UIKit
import Photos
class CustomImageView: UIImageView , UIImagePickerControllerDelegate , UINavigationControllerDelegate{
  var parentViewController : UIViewController!
  var isImagePicked : Bool = false
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    let tapGuesture = UITapGestureRecognizer()
    
    tapGuesture.numberOfTapsRequired = 1
    tapGuesture.addTarget(self, action: #selector(handleClickOnImageview(_:)))
    self.isUserInteractionEnabled = true
    self.addGestureRecognizer(tapGuesture)
  }
  
  @objc func handleClickOnImageview(_ sender : Any)
  {
    openActionSheet(options: ["Take a Photo"], imagePicker: UIImagePickerController())
  }
  
  func openActionSheet(options:[String],imagePicker:UIImagePickerController) -> Void {
    let actionSheet = UIAlertController(title: "Please Choose an Option", message: nil, preferredStyle: .actionSheet)
    let takePhotoAction = UIAlertAction(title: options[0], style: .default) { (takePhotoAction) in
      
      self.openCamera(imagePicker: imagePicker)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    actionSheet.addAction(takePhotoAction)
    actionSheet.addAction(cancelAction)
    parentViewController.present(actionSheet, animated: true, completion: nil)
  }
  
  func openCamera(imagePicker:UIImagePickerController) -> Void {
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
      imagePicker.delegate = self
      imagePicker.allowsEditing = false
      imagePicker.sourceType = .camera
      parentViewController.present(imagePicker, animated: true, completion: nil)
    }
    else{
      let alert = UIAlertController(title: "Hello,", message: "You do not have permissions to access camera", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
      parentViewController.present(alert, animated: true, completion: nil)
    }
  }
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
    self.contentMode = .scaleAspectFit
    self.image = pickedImage
    isImagePicked = true
    let vc = storyboards.AMOH.instance.instantiateViewController(withIdentifier: "ScreenshotVC")as! ScreenshotVC
    vc.imgstring = pickedImage
    vc.imgView = self
    vc.delegate = parentViewController! as! TimeStampProtocol
    parentViewController.navigationController?.pushViewController(vc, animated: true)
    picker.dismiss(animated: true, completion: nil)
  }
}


extension String {
    func convertBase64StringToImage() -> UIImage? {
        let imageData = Data.init(base64Encoded: self, options: .ignoreUnknownCharacters)
        let image = UIImage(data: imageData!)
        return image
    }
}
extension UIImage
{
    func convertImageToBase64String () -> String {
        return self.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
}
