//
//  FullGrivenceDetails.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 13/09/19.
//  Copyright © 2019 IOSuser3. All rights reserved.
//

import Foundation

struct fullGrivence:Decodable {
    let status:String?
    let ward:String?
    let grievance:[grievance1]?
    
}

struct grievance1:Decodable  {
    let id:String?
    let type:String?
    let timestamp:String?
    let status:String?
    let photo:String?
    
    let photo2:String?
    let photo3:String?
    let coulurcode:String?
}



//"status": "true",
//"ward": "8",
//"grievance": [
//{
//"id": "220719129841",
//"type": "Manhole Cover Open",
//"timestamp": "22-JUL-2019 16:38:370",
//"status": "Open",
//"photo": "http://test.cgg.gov.in:8084/ghmcpt/ghmcgrphotos/20031719.png",
//"photo2": "http://test.cgg.gov.in:8084/ghmcpt/ghmcgrphotos/20031719.png",
//"photo3": "http://test.cgg.gov.in:8084/ghmcpt/ghmcgrphotos/20031719.png",
//"coulurcode": "#000000"
//}

