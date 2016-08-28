//
//  EditSourceItem.swift
//  StorageApp
//
//  Created by jack on 16/7/29.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import ObjectMapper

class EditSourceItem: NSObject, Mappable {
    
    var shopId              : String?
    var address             : String?
    var upc                 : String?
    
    override init() {
        super.init()
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        shopId                  <- map["shop_id"]
        address                 <- map["shop_name"]
        upc                     <- map["upc"]
    }

}
