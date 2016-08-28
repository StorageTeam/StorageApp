//
//  DSSMainViewService.swift
//  StorageApp
//
//  Created by ascii on 16/7/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation
import ObjectMapper

class DSSShopService: NSObject {
    // MARK: - Request List
    class func requestList(identify: Int, delegate: DSSDataCenterDelegate) -> Void {
        DSSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/web/shipoffline_user_privilege_json/find_shipoffline_user_privilege.json"
            , para: nil
            , userInfo: nil)
    }
    
    class func parseList(json:[String : AnyObject]) -> [DSSShopModel] {
        if let data = json["data"] as? [String:AnyObject] {
            if let itemJSON = data["list"] {
                if let items = Mapper<DSSShopModel>().mapArray(itemJSON) {
                    
                    // if no selected model, set first model as selected
                    for model in items {
                        if model.isSelected == true {
                            return items
                        }
                    }
                    if let item = items.first {
                        item.isSelected = true
                    }
                    return items
                }
            }
        }
        return [DSSShopModel]()
    }
    
    // MARK: - Set Default Shop
    class func modifyDefaultShop(identify: Int, shopID: String, delegate: DSSDataCenterDelegate) -> Void {
        DSSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/web/shipoffline_user_privilege_json/modify_shipoffline_user_privilege_current.json"
            , para: ["shop_id" : shopID]
            , userInfo: nil)
    }
    
    
}
