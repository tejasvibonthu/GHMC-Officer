//
//  userList.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 11/09/19.
//  Copyright © 2019 IOSuser3. All rights reserved.
//

import Foundation


struct userList:Decodable {
    let  ROW:[row1]?
    let status:String?
    let tag:String?
    
    
}
struct  row1:Decodable {
    let C_NAME :String?
    let EMPID  :String?
    let I_URL:String?
    let MCOUNT:String?
    let MODE_ID:String?
    let ORDER:String?
    let ROWORDER:String?
    
}
