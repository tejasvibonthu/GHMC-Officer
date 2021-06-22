//
//  GrievanceCategoryListVC.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 06/05/20.
//  Copyright © 2020 IOSuser3. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import MapKit
import GoogleMaps
import PKHUD


class GrievanceCategoryListVC: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    var locationManagerager = CLLocationManager()
    var lat:Double!
    var long:Double!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var arrayresponse:NSArray?
    var grievanceCategorylist : [GrievanceCategoryListStruct]?
    var categoryTypeArray: NSArray?
    @IBOutlet var backgroundImg: UIImageView!
    @IBOutlet weak var collectioview: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UserDefaults.standard.value(forKey:"bgImagview") as! String
        backgroundImg.image = UIImage.init(named:image)
        self.collectioview.delegate = self
        self.collectioview.dataSource = self
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
       // locationManager.distanceFilter = 50
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        if Reachability.isConnectedToNetwork(){
           // getGrievancetypelisf()
            getGrievanceCategoryList()
        }else {
            showAlert(message:interNetconnection)
        }
    }
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated:true)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if Reachability.isConnectedToNetwork() {
            let location =  locations[0] as CLLocation
            locationManagerager.stopUpdatingLocation()
            lat  = location.coordinate.latitude
            long = location.coordinate.longitude
            print(lat)
            print(long)
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
    //: to check valid response
    public func isValidResponse(response: DataResponse<Any>) -> Bool {
        if !(response.result.value is NSNull) {
            return true
        } else {
            return false
        }
    }
    func getGrievanceCategoryList()
       {
           let parameters: [String : Any] = ["userid" : "cgg@ghmc","password" : "ghmc@cgg@2018"]
           NetworkRequest.makeRequest(type: GrievanceCategoryStruct.self, urlRequest: Router.getGrievanceTypeList(parameters: parameters)) { [unowned self](result) in
               switch result{
                   
               case .success(let resp):
                   if resp.status == "true" || resp.status.contains("t")
                   {
                       self.grievanceCategorylist = resp.ROW
                       DispatchQueue.main.async {
                           self.collectioview.reloadData()
                       }
                   }
               case .failure(let err):
                   print(err)
                   DispatchQueue.main.async {
                       self.showAlert(message: "Server not responding")
                   }
               }
           }
       }
    func getSubCategoryType(grievanceID : String)
    {
        //add Lat long
        guard let latitude = lat , let longitude = long else {self.showAlertWithOkAction(message: "Unable to Fetch Locations, Please enable location services") { (action) in
            if let bundleId = Bundle.main.bundleIdentifier,
               let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            }
        }
        return
        }
        let parameters: [String : Any] = ["userid" : "cgg@ghmc","password" : "ghmc@cgg@2018" , "gid" : grievanceID, "latitude":latitude ,"longitude":longitude]
        NetworkRequest.makeRequestArray(type: GrievanceSubCategoryStruct.self, urlRequest: Router.getCategoryTypeList(parameters: parameters)) { [unowned self](result) in
            switch result{
                
            case .success(let resp):
                
                DispatchQueue.main.async {
                    let pushVC = storyboards.HomeStoryBoard.instance.instantiateViewController(withIdentifier: "GrievancePostComplaintVC") as! GrievancePostComplaintVC
                    pushVC.latitude = self.lat
                    pushVC.longitude = self.long
                    pushVC.categoryTypeArray = resp
                    self.navigationController?.pushViewController(pushVC, animated: true)
                }
            case .failure(let err):
                print(err)
                DispatchQueue.main.async {
                    self.showAlert(message: "Server not responding")
                }
            }
        }
    }
}
extension GrievanceCategoryListVC:UICollectionViewDelegate, UICollectionViewDataSource
{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
               return grievanceCategorylist?.count ?? 0

    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! GrievanceCategoryListCell
        cell.displayName.text = grievanceCategorylist?[indexPath.row].cName
        cell.displayImage.sd_setImage(with: URL(string : grievanceCategorylist?[indexPath.row].iURL ?? ""), placeholderImage: UIImage(named: "Sample"), options: [], completed: nil)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let categoryID = self.grievanceCategorylist?[indexPath.row].grievanceID else {return}
        if Reachability.isConnectedToNetwork(){
            getSubCategoryType(grievanceID: categoryID)
           
        }else {
            showAlert(message: "No internet connection")
        }
    }
}
//        let id = self.listOfData[indexPath.row]
//        let details = GrievanceCategoryListViewModel(id)
//        DispatchQueue.main.async {
//            self.loading(text:"Loading Details..")
//            PKHUD.sharedHUD.show()
//        }
//        if Reachability.isConnectedToNetwork(){
////             let urlString1 = "https://ptghmconlinepayment.cgg.gov.in/GHMCIntegratedCitizen/services/Grievance/getSubCategoty"
//             let urlString1 = "http://testghmc.cgg.gov.in/GhmcMobileApp//Grievance/getSubCategoty"
//
//         //   http://testghmc.cgg.gov.in/GhmcMobileApp/
//
//            let parameters: Parameters = ["userid" : "cgg@ghmc","password" : "ghmc@cgg@2018", "gid" : details.id!]
//
//            Alamofire.request(urlString1, method: .post, parameters:parameters,encoding: JSONEncoding.default, headers: nil).responseJSON {
//                response in
//                DispatchQueue.main.async {
//                    PKHUD.sharedHUD.hide()
//                }
//                if self.isValidResponse(response:response){
//
//                    switch response.result{
//                    case .success:
//
//                        let responseDict = response.result.value as! NSArray
//
//
//                     //   print(responseDict.value(forKey: "type"))
//
//                        self.categoryTypeArray = responseDict.value(forKey: "type") as? NSArray
//
//                        let pushVC = storyboards.HomeStoryBoard.instance.instantiateViewController(withIdentifier: "GrievancePostComplaintVC") as! GrievancePostComplaintVC
//                        pushVC.lat = self.lat
//                        pushVC.long = self.long
//                        pushVC.reciveId = responseDict.value(forKey: "id") as? NSArray
//
//                        pushVC.recieveData = self.categoryTypeArray
//                        self.navigationController?.pushViewController(pushVC, animated: true)
//
//                        break
//
//                    case .failure(let error):
//                        DispatchQueue.main.async {
//                            PKHUD.sharedHUD.hide()
//                        }
//
//                        // self.displayAlertMessage(body:"Error occured.please try agin later", theme:.error)
//                        break
//                    default:
//                        DispatchQueue.main.async {
//                            PKHUD.sharedHUD.hide()
//                        }
//                        break
//                    }
//                }
//            }
//        }else {
//            showAlert(message:interNetconnection)
//        }
//    }

//MARK:- Structs
struct GrievanceCategoryStruct : Decodable {
    let status : String
    let ROW : [GrievanceCategoryListStruct]?
}
// MARK: - GrievanceCategoryListStruct
struct GrievanceCategoryListStruct: Decodable {
    let roworder, grievanceID, cName: String
    let iURL: String
    let order: String

    enum CodingKeys: String, CodingKey {
        case roworder = "ROWORDER"
        case grievanceID = "GRIEVANCE_ID"
        case cName = "C_NAME"
        case iURL = "I_URL"
        case order = "ORDER"
    }
}


struct GrievanceSubCategoryStruct : Decodable
{
    let id : String
    let type : String
    let status : String
}
