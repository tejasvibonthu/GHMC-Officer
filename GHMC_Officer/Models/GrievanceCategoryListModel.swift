//
//  GrievanceCategoryListModel.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 06/05/20.
//  Copyright © 2020 IOSuser3. All rights reserved.
//

import Foundation
class GrievanceCategoryListModel {
    
    var image: String
    var name:String
    var id:String
    
    init(_ grievanceDict: NSDictionary?) {
        
        self.name = (grievanceDict?.value(forKey: "C_NAME") as? String)!
        self.image = (grievanceDict?.value(forKey: "I_URL") as? String)!
        self.id = (grievanceDict?.value(forKey: "GRIEVANCE_ID") as? String)!
        
    }
}
