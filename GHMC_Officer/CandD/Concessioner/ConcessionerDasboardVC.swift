//
//  ConcessionerDasboardVC.swift
//  GHMC_Officer
//
//  Created by deep chandan on 24/06/21.
//  Copyright © 2021 IOSuser3. All rights reserved.
//

import UIKit

class ConcessionerDasboardVC: UIViewController {
  var dashboardCountsModel:ConcessionerdashboardStruct?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//   func getConcessionerDashboardWS() A
}
// MARK: - ConcessionerdashboardStruct
struct ConcessionerdashboardStruct: Codable {
    let statusCode, statusMessage: String?
    let amohList: [AMOHList]?

    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
        case amohList = "AMOHList"
    }
}

// MARK: - AMOHList
struct AMOHList: Codable {
    let concessionerTicketsCount, concessionerPickupCaptureCount, concessionerRejectedCount, concessionerClosedCount: String?

    enum CodingKeys: String, CodingKey {
        case concessionerTicketsCount = "CONCESSIONER_TICKETS_COUNT"
        case concessionerPickupCaptureCount = "CONCESSIONER_PICKUP_CAPTURE_COUNT"
        case concessionerRejectedCount = "CONCESSIONER_REJECTED_COUNT"
        case concessionerClosedCount = "CONCESSIONER_CLOSED_COUNT"
    }
}
