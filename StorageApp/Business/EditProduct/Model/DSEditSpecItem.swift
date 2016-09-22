//
//  DSEditSpecItem.swift
//  StorageApp
//
//  Created by jack on 16/6/29.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import ObjectMapper

class DSEditSpecItem: NSObject, Mappable {

    var upcStr          : String?
    var siteSku         : String?
    var image           : String?
    var stock           : String?
    var weight          : String?
    var price           : Int?
    
    required init?(_ map: Map) {
        
    }
    
    override init() {
        super.init()
    }
    
    func mapping(map: Map) {
        upcStr              <- map["upc"]
        siteSku             <- map["site_sku"]
        image               <- map["image"]
        price               <- map["price"]
        stock               <- (map["stock"], DSStringTransform())
        weight              <- (map["weight"], DSStringTransform())
    }

}
