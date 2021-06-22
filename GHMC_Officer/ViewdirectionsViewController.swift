//
//  ViewdirectionsViewController.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 29/04/20.
//  Copyright © 2020 IOSuser3. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ViewdirectionsViewController: UIViewController {

    @IBOutlet var viewMap: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 48.857165, longitude: 2.354613, zoom: 8.0)
        viewMap.camera = camera
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
