//
//  DSSProductOfflineModel.swift
//  StorageApp
//
//  Created by ascii on 16/8/1.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation
import ObjectMapper

class DSSProductWaitsaleModel: NSObject, Mappable {
    var itemID          : Int!
    var createTime      : String?
    var photoURL        : String?
    var name            : String?
    var upc             : String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        itemID          <- map["id"]
        createTime      <- map["create_time"]
        photoURL        <- map["first_pic"]
        name            <- map["shop_name"]
        upc             <- map["upc"]
    }
}
