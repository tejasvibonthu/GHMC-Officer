//
//  HoldingsNearMeViewController.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 24/10/19.
//  Copyright © 2019 IOSuser3. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import MapKit
import PKHUD
import CoreLocation
import GooglePlaces
import GoogleMaps

class HoldingsNearMeViewController: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate, GMSMapViewDelegate{
    @IBOutlet weak var holdingNearMeButton: UIButton!
    var locationManager:CLLocationManager?
     var location:CLLocationCoordinate2D?
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var fourthButton: SkyFloatingLabelTextField!
    @IBOutlet weak var thirdButton: SkyFloatingLabelTextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var enterAgencyName: SkyFloatingLabelTextField!
    @IBOutlet weak var enterAgencyNumber: SkyFloatingLabelTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        getTinDetails()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        mapView.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    

    @IBAction func holdingNearMe(_ sender: Any) {
        
        let vc = storyboards.HoardingInfo.instance.instantiateViewController(withIdentifier:"HodlingDeatilsViewController") as! HodlingDeatilsViewController
        self.navigationController?.pushViewController(vc, animated:true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//        location = locValue
//        let position = CLLocationCoordinate2D(latitude:17.3568, longitude:78.2566)
//        let marker = GMSMarker(position: position)
////        let camera = GMSCameraPosition.camera(withLatitude:17.45345,
////                                              longitude:74.6556,
////                                              zoom:15.0)
////        //                        marker.title = "Ward:\(self.wardName)"
////        //                        marker.snippet = "circlename:\(self.circleName),Zone:\(self.zone)"
////        //                         marker.icon = UIImage.init(named:"cameraicon.png")
////        self.mapView.camera = camera
////        self.mapView.animate(to:camera )
//
//        marker.map = self.mapView
        
     //   self.mapView.clear()
        let position = CLLocationCoordinate2D(latitude:17.3568, longitude:78.2566)
        let marker = GMSMarker(position: position)
        
        let camera = GMSCameraPosition.camera(withLatitude: 17.5555,
                                              longitude:74.5558,
                                              zoom: 5)
        //marker.title = "Ward:\(self.wardName)"
        //marker.snippet = "circlename:\(self.circleName),Zone:\(self.zone)"
        // marker.icon = UIImage.init(named:"cameraicon.png")
        mapView.camera = camera
        
        self.mapView.animate(to:camera )
        
        marker.map = self.mapView
        
        
        
        
    }
    func getTinDetails() {
        
        DispatchQueue.main.async {
            
            self.loading(text:"Loading...")
            
            PKHUD.sharedHUD.show()
            
        }
        //, longitude:78.2566
        
//        let is_SoapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:Search_NEAR_AINNO><tem:LOATITUDE>\(String(describing: location?.latitude))</tem:LOATITUDE><tem:LOGITUDE>\(String(describing: location?.longitude))</tem:LOGITUDE></tem:Search_NEAR_AINNO></soapenv:Body></soapenv:Envelope>"
        let is_SoapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:Search_NEAR_AINNO><tem:LOATITUDE>17.3568</tem:LOATITUDE><tem:LOGITUDE>78.2566</tem:LOGITUDE></tem:Search_NEAR_AINNO></soapenv:Body></soapenv:Envelope>"
        //let is_SoapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cgg=\"http://cgg.com/\"><soapenv:Header/><soapenv:Body><cgg:circles><arg0>GHMC@CGG@2020</arg0></cgg:circles></soapenv:Body></soapenv:Envelope>"
        
        let is_URL: String = "https://advt.ghmc.gov.in/advtwebservice/Advt_service.asmx?wsdl"
        
        let url = URL(string: is_URL)
        
        var urlRequest = URLRequest(url: url!)
        
        let session = URLSession.shared
        
        var _: NSError?
        
        
        
        urlRequest.httpMethod = "POST"
        
        urlRequest.httpBody = is_SoapMessage.data(using: String.Encoding.utf8)
        
        urlRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        //Search_NEAR_AINNO
        
        urlRequest.addValue("http://tempuri.org/Search_NEAR_AINNO", forHTTPHeaderField: "SOAPAction")
        
        
        
        let task = session.dataTask(with: urlRequest) { data, response, error -> Void in
            
            
            
            if let data = data, let utf8Text = String(data: data, encoding: .utf8) {
                
             //   print(data.count)
                
                if data.count != 0 {
                    
                    
                    
                    let parse = XMLDictionaryParser()
                    
                    
                    
                    _ = parse.dictionary(with: utf8Text)! as NSDictionary
                  //   print(dictionaryConverting)
                    
                    
                   // let data1 = dictionaryConverting.value(forKeyPath: "S:Body.ns2:circlesResponse.return") as! String
                    
                   // let dictionaryConverting2 = parse.dictionary(with: data1)! as NSDictionary
                    
                   // self.circleDetails = dictionaryConverting2.value(forKeyPath: "records.record") as! [[String : Any]]
                    
                    DispatchQueue.main.async {
                        
                        
                        
                        PKHUD.sharedHUD.hide()
                        
                        //self.gotoKnowYourTinVC()
                        
                    }
                    
                }
                
                
                
                
                
                if error != nil
                    
                {
                    
                    print("Error: " + (error?.localizedDescription)!)
                    
                }
                
                
                
            }
            
            
            
        }
        
        task.resume()
        
    }
}
