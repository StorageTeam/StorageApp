//
//  DSSMissionItem.swift
//  StorageApp
//
//  Created by jack on 16/8/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import ObjectMapper

class DSSMissionItem: NSObject {

    var goodsID         : String?
    var shopID          : String?
    var shopName        : String?
    var title           : String?
    var firstPic        : String?
    var specNam         : String?
    var price           : Int?
    var quantity        : Int?

    
    override init() {
        super.init()
    }
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        goodsID             <- (map["goods_id"], DSSStringTransform())
        shopID              <- (map["shop_id"], DSSStringTransform())
        shopName            <- map["shop_name"]
        title               <- map["title"]
        firstPic            <- map["first_pic"]
        specNam             <- map["spec_name"]
        price               <- map["purchase_price"]
        quantity            <- map["quantity"]
    }

}
