//
//  DSMissionServe.swift
//  StorageApp
//
//  Created by jack on 16/8/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import ObjectMapper

class DSMissionServe: NSObject {
    class func reqMissionList(identify: Int, delegate: DSDataCenterDelegate) -> Void {
//        var para          = [String : String]()
//        
//        if shopId != nil {
//            para["shop_id"]   = shopId
//        }
        
        DSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/web/shipoffline_purchase_json/find_shipoffline_purchase_goods.json"
            , para: nil
            , userInfo: nil)
    }

    class func parserMissionList(json: [String : AnyObject]) -> [DSMissionItem]? {
        if let dataArray = json["data"]!["list"] as? [[String:AnyObject]] {
            
            if let items = Mapper<DSMissionItem>().mapArray(dataArray) {
                return items
            }
            
        }
        return nil
    }
    
    class func filterShopListWith(missionList: [DSMissionItem]?) -> [DSShopModel]? {
        
        if (missionList != nil) {
            
            var dataArray : [DSShopModel] = [
            ]
            for missionItem in missionList! {
                let shopId = missionItem.shopID
                let res = dataArray.contains({ (shopItem) -> Bool in
                    if shopItem.itemID == shopId {
                        return true
                    } else {
                        return false
                    }
                })
                if (!res) {
                    let newShopItem = DSShopModel()
                    newShopItem.itemID = missionItem.shopID
                    newShopItem.name = missionItem.shopName
                    dataArray.append(newShopItem)
                }
            }
            return dataArray
        }
        return nil
    }

}
