//
//  DSSMissionItem.swift
//  StorageApp
//
//  Created by jack on 16/8/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import ObjectMapper

class DSSDeliverProductModel: NSObject, Mappable {

    var itemID          : String?
    var orderID         : String?
    var title           : String?
    var firstPic        : String?
    var specName        : String?
    var price           : Int?
    var quantity        : Int?
    var status          : Int?
    
    override init() {
        super.init()
    }
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        itemID              <- (map["id"], DSSStringTransform())
        orderID             <- (map["order_id"], DSSStringTransform())
        title               <- map["title"]
        firstPic            <- map["first_pic"]
        specName            <- map["spec_name"]
        price               <- map["purchase_price"]
        quantity            <- map["quantity"]
        quantity            <- map["quantity_ratio"]
        status              <- map["status"]
    }
}
