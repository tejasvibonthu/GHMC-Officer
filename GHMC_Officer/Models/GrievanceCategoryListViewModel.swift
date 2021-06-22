//
//  GrievanceCategoryListViewModel.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 06/05/20.
//  Copyright © 2020 IOSuser3. All rights reserved.
//

import Foundation
class GrievanceCategoryListViewModel {
    var name:String?
    var image : String?
    var id : String?
    
    init(_ grievanceDict: GrievanceCategoryListModel?) {
        
        self.name = grievanceDict?.name
        self.image = grievanceDict?.image
        self.id = grievanceDict?.id
    }
}
