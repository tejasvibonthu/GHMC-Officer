//
//  getIdProofs.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 17/09/19.
//  Copyright © 2019 IOSuser3. All rights reserved.
//

import Foundation

struct getIdProofsTpes:Decodable {
    var status:String?
    var tag:String?
    var data:[data3]?
}
struct data3:Decodable {
    var id:String?
    var name:String?
}

struct grivenceUpdate:Codable{
    var compid:String?
    var status:String?
    var Message:String?
    var tag: String?
    var url: String?
}

struct  updateWrd:Codable {
  var  compid:String?
  var tag: String?
  var url: String?
  var status: Bool?
    var Message:String?
   
}
