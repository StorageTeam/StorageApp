//
//  DSSEditProItem.swift
//  StorageApp
//
//  Created by jack on 16/6/29.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
//import ObjectMapper

class DSSEditItem: NSObject {

    var infoItem : DSSEditInfoItem?
    var specItem : DSSEditSpecItem?
    var picItems : [DSSEditImgItem]?
    
    func isDataComplete() -> (complete: Bool, error: String?) {
        
        var complete = true
        var errorStr: String?
        
        if self.infoItem?.name?.characters.count == 0 {
            complete = false
            errorStr = "请输入name"
        } else if self.picItems?.count == 0 {
            complete = false
            errorStr = "请至少选择一张照片"
        } else if self.infoItem?.price == nil || self.infoItem?.price == 0 {
            complete = false
            errorStr = "请输入价格"
        }
        
        return (complete, errorStr)
        
    }
//    required init?(_ map: Map) {
//        
//    }
//    
//    func mapping(map: Map) {
//    
//        infoItem            <- map["product_shipoffline"]
//        picItems            <- map["product_shipoffline_goods.product_shipoffline_pic_list"]
////        specItem            <- map["product_shipoffline_goods.product_shipoffline_goods_list"]
//        //        name            <- map["name"]
//        //        desc            <- map["description"]
//        //        photoURL        <- map["first_pic"]
//        //        brand           <- map["brand"]
//        //        price           <- map["purchase_price"]
//        //        stock           <- map["stock"]
//        //        suppID          <- map["supplier_id"]
//        //        status          <- map["status"]
//        //        createTime      <- map["create_time"]
//        //        updateTime      <- map["update_time"]
//    }
}
