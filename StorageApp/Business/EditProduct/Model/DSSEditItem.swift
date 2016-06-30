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
        
        if self.picItems?.count == 0 {
            complete = false
            errorStr = "请至少选择一张照片"
        } else if self.infoItem?.price == nil || self.infoItem?.price == 0 {
            complete = false
            errorStr = "请输入价格"
        } else if self.specItem?.stock == nil || (self.specItem?.stock)! == 0 {
            complete = false
            errorStr = "请输入库存"
        } else if self.specItem?.upcStr == nil || self.specItem?.upcStr?.characters.count == 0 {
            complete = false
            errorStr = "请输入条码"
        } else if self.specItem?.siteSku == nil || self.specItem?.siteSku?.characters.count == 0 {
            complete = false
            errorStr = "请输入Item no"
        }
        
        if self.infoItem?.name != nil && self.infoItem?.name?.characters.count > 255 {
            complete = false
            errorStr = "名称不能超过255个字符"
        }
        
        if self.infoItem?.chinaName != nil && self.infoItem?.chinaName?.characters.count > 255 {
            complete = false
            errorStr = "中文名称不能超过255个字符"
        }
        
        if self.infoItem?.brand != nil && self.infoItem?.brand?.characters.count > 126 {
            complete = false
            errorStr = "品牌名称不能超过126个字符"
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
