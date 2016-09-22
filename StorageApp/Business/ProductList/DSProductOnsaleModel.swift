//
//  DSSProductListModel.swift
//  StorageApp
//
//  Created by ascii on 16/6/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation
import ObjectMapper

class DSProductOnsaleModel: NSObject, Mappable {
    var itemID          : Int!
    var prodID          : Int!
    var createTime      : String?
    var photoURL        : String?

    var name            : String?
    
    var price           : Int?
    var stock           : Int?
//    var suppID          : Int?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        itemID          <- map["id"]
        prodID          <- map["product_id"]
        createTime      <- map["create_time"]
        photoURL        <- map["first_pic"]
        name            <- map["name"]
        price           <- map["purchase_price"]
        stock           <- map["stock"]
//        suppID          <- map["supplier_id"]
    }
}
