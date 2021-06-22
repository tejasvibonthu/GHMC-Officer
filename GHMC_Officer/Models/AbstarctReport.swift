//
//  AbstarctReport.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 23/09/19.
//  Copyright © 2019 IOSuser3. All rights reserved.
//

import Foundation

struct abstractRport:Codable{
    var status:String?
    var flag:String?
    var TOTAL_RECEIVED:String?
    var TOTAL_PENDING:String?
    var TOTAL_UNDER_PROCESS:String?
    var TOTAL_CLOSED:String?
    var TOTAL_NON_GHMC:String?
    var TOTAL_FUND_RELATED:String?
    
}
