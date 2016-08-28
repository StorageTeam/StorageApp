//
//  DSSMissionServe.swift
//  StorageApp
//
//  Created by jack on 16/8/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSSMissionServe: NSObject {
    class func reqMissionList(identify: Int, delegate: DSSDataCenterDelegate, shopId: String) -> Void {
        var para          = [String : String]()
        
        if shopId != nil {
            para["shop_id"]   = shopId
        }
        
        DSSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/web/shipoffline_purchase_json/find_shipoffline_purchase_goods.json"
            , para: ["shipoffline_json" : para]
            , userInfo: nil)
    }

    class func parserMissionList(json: [String : AnyObject]) -> [DSSMissionItem]? {
        if let dataArray = json["data"]!["list"] as? [[String:AnyObject]] {
            
            if let items = Mapper<DSSMissionItem>().mapArray(dataArray) {
                return items
            }
            
        }
        return nil
    }
    
    class func filterShopListWith(missionList: [DSSMissionItem]) -> [DSSShopItem] {
        
        var dataArray : [DSSShopItem] = []
        for let missionItem in missionList {
            
            let shopId = missionItem.shopID
            let res = dataArray.contains({ (shopItem) -> Bool in
                if shopItem.shopID == shopId {
                    return true
                } else {
                    return false
                }
            })
            if (!res) {
                let newShopItem = DSSShopItem()
                newShopItem.shopID = missionItem.shopID
                newShopItem.shopName = missionItem.shopName
                dataArray.append(newShopItem)
            }
        }
        
        return dataArray
    }

}
