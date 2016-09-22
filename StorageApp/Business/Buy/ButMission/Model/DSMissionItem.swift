//
//  DSMissionItem.swift
//  StorageApp
//
//  Created by jack on 16/8/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import ObjectMapper

enum MissionStatus: Int {
    case MissionStatusUnkown = 0
    case MissionStatusSuccess
    case MissionStatusFail
}

class DSMissionItem: NSObject, Mappable{

    var itemID          : String?
    var goodsID         : String?
    var shopID          : Int?
    var shopName        : String?
    var title           : String?
    var firstPic        : String?
    var specNam         : String?
    var price           : Int?
    var quantity        : String?
    var status          : Int?
    var createTime      : String?

    override init() {
        super.init()
    }
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        itemID              <- (map["id"], DSStringTransform())
        goodsID             <- (map["goods_id"], DSStringTransform())
        shopID              <- map["shop_id"]
        shopName            <- map["shop_name"]
        title               <- map["title"]
        firstPic            <- map["first_pic"]
        specNam             <- map["spec_name"]
        price               <- map["purchase_price"]
        quantity            <- (map["quantity"], DSStringTransform())
        status              <- map["status"]
        createTime          <- map["create_time"]
    }
    
    func statusString() -> String? {
        let missionStatus = self.missionStatus()
        switch (missionStatus) {
        case .MissionStatusSuccess:
            return "采购成功"
        case .MissionStatusFail:
            return "采购失败"
        default:
            break
        }
        return nil
    }
    
    func missionStatus() -> MissionStatus {
        if self.status != nil {
            if self.status == 1 {
                return MissionStatus.MissionStatusSuccess
            } else if self.status == 2 {
                return MissionStatus.MissionStatusFail
            }
        }
        
        return MissionStatus.MissionStatusUnkown
    }
    
    func getRealCreateTime() -> String {
        if self.createTime != nil {
            let newStr = self.createTime?.stringByReplacingOccurrencesOfString("T", withString: " ")
            return newStr!
        }
        return " "
    }

}
