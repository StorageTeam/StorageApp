//
//  DSEditInfoItem.swift
//  StorageApp
//
//  Created by jack on 16/6/29.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import ObjectMapper

class DSEditInfoItem: NSObject, Mappable{

    var itemID          : String?
    var productID       : String?
    var name            : String?
    var chinaName       : String?
    var desc            : String?
    var brand           : String?
    var currency        : String?
    var price           : Int?
    var status          : Int?
    
    override init() {
        super.init()
    }
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        itemID          <- (map["id"], DSStringTransform())
        productID       <- (map["product_id"], DSStringTransform())
        name            <- map["name"]
        chinaName       <- map["name_cn"]
        desc            <- map["description"]
        brand           <- map["brand"]
        currency        <- map["currency"]
        price           <- map["purchase_price"]
        status          <- map["status"]
    }

}
