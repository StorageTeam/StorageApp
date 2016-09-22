//
//  DSMissionItem.swift
//  StorageApp
//
//  Created by jack on 16/8/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import ObjectMapper

class DSDeliverProductModel: NSObject, Mappable {

    var itemID          : String?
    var orderID         : String?
    var title           : String?
    var firstPic        : String?
    var specName        : String?
    var price           : Int?
    var quantity        : String?
    var status          : Int?
    
    override init() {
        super.init()
    }
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        itemID              <- (map["id"], DSStringTransform())
        orderID             <- (map["order_id"], DSStringTransform())
        title               <- map["title"]
        firstPic            <- map["first_pic"]
        specName            <- map["spec_name"]
        price               <- map["purchase_price"]
        quantity            <- (map["quantity"], DSStringTransform())
        status              <- map["status"]
    }
    
    func statusDesc() -> String? {
        if let st = self.status {
            switch st {
            case 1:
                return "待采购"
            case 2:
                return "待发货"
            case 3:
                return "已发货"
            default:
                break
            }
        }
        return nil
    }
}
