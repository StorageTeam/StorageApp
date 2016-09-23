//
//  DSShopModel.swift
//  StorageApp
//
//  Created by ascii on 16/7/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation
import ObjectMapper

class DSShopModel: NSObject, Mappable {
    var itemID          : Int!
    var name            : String!
    var isSelected      : Bool!
    
    override init() {
        super.init()
        
        self.itemID     = nil
        self.name       = nil
        self.isSelected = false
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        itemID          <- map["shop_id"]
        name            <- map["shop_name"]
        isSelected      <- map["current"]
    }
}
