//
//  ViewCommentsVC.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 21/05/20.
//  Copyright © 2020 IOSuser3. All rights reserved.
//

import UIKit
//protocol imageTapped122 {
//    func image1TappingAction22(string:Int?)
//     
//}
class ViewCommentsVC: UIViewController {

      @IBOutlet var backgroundImg: UIImageView!
        @IBOutlet var tableView: UITableView!
        var recieveCommentArrays:[Comment] = []
        var imageGesture1 :UITapGestureRecognizer?
        var pdfGesture1 :UITapGestureRecognizer?
        var imageString1:String?
      
       
       var PdfString1:String?
        
        override func viewDidLoad() {
            super.viewDidLoad()

            self.tableView.delegate = self
            self.tableView.dataSource = self
            
          //   imageGesture1 = UITapGestureRecognizer.init(target:self, action:#selector(FirstImageTapped))
             pdfGesture1 = UITapGestureRecognizer.init(target:nil, action:#selector(firstpdfTapped))


           let image = UserDefaults.standard.value(forKey:"bgImagview") as! String
           backgroundImg.image = UIImage.init(named:image)
            
        }

      @objc func firstpdfTapped(){
          let vc = storyboards.photoDisplay.instance.instantiateViewController(withIdentifier:"PdfViewController") as! PdfViewController
          vc.pdfString = PdfString1
          vc.modalPresentationStyle = .overCurrentContext
          vc.modalTransitionStyle = .crossDissolve
          self.navigationController?.present(vc, animated:false, completion:nil)
      }
    @objc func FirstImageTapped(){
        let vc = storyboards.photoDisplay.instance.instantiateViewController(withIdentifier:"photViewController") as! photViewController
           vc.imageString = imageString1
           vc.modalPresentationStyle = .overCurrentContext
           vc.modalTransitionStyle = .crossDissolve
           self.navigationController?.present(vc, animated:false, completion:nil)
       }
        @IBAction func backClicked(_ sender: Any) {
            self.navigationController?.popViewController(animated: true)
        }
    @objc func cellTappedMethod(_ sender:AnyObject){
                print("you tap image number: \(sender.view.tag)")
          let str = recieveCommentArrays[sender.view.tag].cphoto
            if ((str?.hasSuffix("g"))!){
                let vc = storyboards.photoDisplay.instance.instantiateViewController(withIdentifier:"photViewController") as! photViewController
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .overCurrentContext
                vc.imageString = recieveCommentArrays[sender.view.tag].cphoto
                self.present(vc, animated:false, completion:nil)
            }else if (str!.hasSuffix("f")){
                let vc = storyboards.photoDisplay.instance.instantiateViewController(withIdentifier:"PdfViewController") as! PdfViewController
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .overCurrentContext
                vc.pdfString = recieveCommentArrays[sender.view.tag].cphoto
                self.present(vc, animated:false, completion:nil)
            }
           }
    }
    extension ViewCommentsVC: UITableViewDelegate, UITableViewDataSource
    {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            if recieveCommentArrays.count != 0
            {
                return recieveCommentArrays.count
            }
            
            return 0
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ViewCommentsCell
          //  cell.delegate22 = self as? imageTappedOne2
            
            cell.selectionStyle = .none
            tableView.separatorStyle = .none
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTappedMethod(_:)))

            cell.img.isUserInteractionEnabled = true
            cell.img.tag = indexPath.row
            cell.img.addGestureRecognizer(tapGestureRecognizer)
            
            cell.mainView.layer.cornerRadius = 5.0
            cell.mainView.clipsToBounds = true
            
            let dict = recieveCommentArrays[indexPath.row]
            cell.postedBY.text = dict.cuserName
            cell.mobileNo.text = dict.cmobileno
            cell.complaintID.text = dict.cid
           // print(dict.cremarks)
            cell.remarks.text = dict.cremarks
            cell.status.text = dict.cstatus
            cell.timeStamp.text = dict.ctimeStamp
            
            let imagestr1 = dict.cphoto
                  
                  
                  if (imagestr1?.hasSuffix("g"))!{
                      cell.img.image = UIImage.init(named:"viewimage")
                      
                  }else if (imagestr1?.hasSuffix("f"))!{
                       cell.img.image = UIImage.init(named:"pdfnew")

                  }

            return cell
    }
       

        
    }
//extension ViewCommentsVC:imageTapped122{
//    
//    
//func image1TappingAction22(string: Int?) {
//    let str = recieveCommentArrays[0].cphoto
//    if ((str?.hasSuffix("g"))!){
//        let vc = storyboards.photoDisplay.instance.instantiateViewController(withIdentifier:"photViewController") as! photViewController
//        vc.modalTransitionStyle = .coverVertical
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.imageString = recieveCommentArrays[0].cphoto
//        self.present(vc, animated:false, completion:nil)
//    }else if (str!.hasSuffix("f")){
//        let vc = storyboards.photoDisplay.instance.instantiateViewController(withIdentifier:"PdfViewController") as! PdfViewController
//        vc.modalTransitionStyle = .coverVertical
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.pdfString = recieveCommentArrays[0].cphoto
//        self.present(vc, animated:false, completion:nil)
//    }
//}
//}
