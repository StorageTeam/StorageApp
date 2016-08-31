//
//  DSSDeliverMissionModel.swift
//  StorageApp
//
//  Created by ascii on 16/8/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import ObjectMapper

class DSSDeliverMissionModel: NSObject, Mappable {
    var itemID          : String?
    var expressNO       : String?
    var createTime      : String?
    var products        : [DSSDeliverProductModel]?
    
    override init() {
        super.init()
    }
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        itemID              <- (map["id"], DSSStringTransform())
        expressNO           <- (map["express_no"], DSSStringTransform())
        createTime          <- map["create_time"]
        products            <- map["goods_list"]
    }
    
    func productItemAtIndex(idx : Int) -> DSSDeliverProductModel? {
        if idx >= 0 && idx < self.products?.count {
            return self.products?[idx]
        }
        return nil
    }
}
