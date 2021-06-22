//
//  LoginmodelClass.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 23/04/20.
//  Copyright © 2020 IOSuser3. All rights reserved.
//

import Foundation
// MARK: - Temperatures
struct LoginModel: Codable {
    let status, message, empD, empName: String
    let mobileNo, designation, typeID, mpin: String
    let otp: String
    
    enum CodingKeys: String, CodingKey {
        case status, message
        case empD = "EMP_D"
        case empName = "EMP_NAME"
        case mobileNo = "MOBILE_NO"
        case designation = "DESIGNATION"
        case typeID = "TYPE_ID"
        case mpin, otp
    }
}
