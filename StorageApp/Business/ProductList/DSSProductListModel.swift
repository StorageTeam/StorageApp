//
//  DSSProductListModel.swift
//  StorageApp
//
//  Created by ascii on 16/6/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation
import ObjectMapper

class DSSProductListModel: NSObject, Mappable {
    var itemID          : Int!
    var prodID          : Int!
    var name            : String!
    var desc            : String!
    var photoURL        : String!
    var brand           : String!
    var price           : Int!
    var stock           : Int!
    var suppID          : Int!
    var status          : Int!
    var createTime      : String!
    var updateTime      : String!
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        itemID          <- map["id"]
        prodID          <- map["product_id"]
        name            <- map["name"]
        desc            <- map["description"]
        photoURL        <- map["first_pic"]
        brand           <- map["brand"]
        price           <- map["purchase_price"]
        stock           <- map["stock"]
        suppID          <- map["supplier_id"]
        status          <- map["status"]
        createTime      <- map["create_time"]
        updateTime      <- map["update_time"]
    }
}
