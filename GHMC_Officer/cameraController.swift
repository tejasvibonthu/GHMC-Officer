//
//  cameraController.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 17/09/19.
//  Copyright © 2019 IOSuser3. All rights reserved.
//


import Foundation
import UIKit
import MobileCoreServices


class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIDocumentMenuDelegate,UIDocumentPickerDelegate {
    
    var picker = UIImagePickerController();
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback :((UIImage) -> ())?;
  //  var pickDocumentCallback:((String) -> ())?
   // var checkedImg:String?
    
    override init(){
        super.init()
    }
    
    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> () )){
        pickImageCallback = callback
      //  pickDocumentCallback  = callbackType;

        self.viewController = viewController;
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default){
            UIAlertAction in
            self.openCamera()


        }
        let galleryAction = UIAlertAction(title: "Gallery", style: .default){
            UIAlertAction in
           // self.checkedImg == "image"

            self.openGallery()
        }
        let documentAction = UIAlertAction(title: "Choose Document", style: .default){
            UIAlertAction in
         //self.checkedImg == "pdf"
            self.openDocument()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }
        
        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(documentAction)
        alert.addAction(cancelAction)

        alert.popoverPresentationController?.sourceView = self.viewController!.view
        viewController.present(alert, animated: true, completion: nil)
    }
    func openCamera(){
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            self.viewController!.present(picker, animated: true, completion: nil)
        } else {
            let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"")
            alertWarning.show()
        }
    }
    func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        self.viewController!.present(picker, animated: true, completion: nil)
    }
    func openDocument(){
      let types: [String] = [kUTTypePDF as String]
       let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
       documentPicker.delegate = self
       documentPicker.modalPresentationStyle = .formSheet
        self.viewController!.present(documentPicker, animated: true, completion: nil)

       // self.present(importMenu, animated: true, completion: nil)
    }
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let data = try! Data(contentsOf: urls[0])
        print( try! Data(contentsOf: urls[0]))
        let _:String = data.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
       // print(fileStream)
        pickImageCallback!(UIImage(named:"pdfnew")!)
      //  pickDocumentCallback!("pdf")


    }
    
    
    public func documentMenu(_ picker:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        self.viewController!.present(documentPicker, animated: true, completion: nil)
    }
    
    
    func documentPickerWasCancelled(_ picker: UIDocumentPickerViewController) {
        //  print("view was cancelled")
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //print(pickedImage)
            pickImageCallback!(pickedImage)
          //  pickDocumentCallback!("img")

        }
        
         picker.dismiss(animated: true, completion: nil)
    }
        
   
    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
}
}
