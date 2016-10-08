//
//  DSSMainViewService.swift
//  StorageApp
//
//  Created by ascii on 16/7/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation
import ObjectMapper

class DSMainService: NSObject {
    
    // MARK: - Shop API
    class func requestShopList(identify: Int, delegate: DSDataCenterDelegate) -> Void {
        DSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/web/shipoffline_user_privilege_json/find_shipoffline_user_privilege.json"
            , para: nil
            , userInfo: nil)
    }
    
    class func parseShopList(json:[String : AnyObject]) -> [DSShopModel] {
        if let data = json["data"] as? [String:AnyObject] {
            if let itemJSON = data["list"] {
                if let items = Mapper<DSShopModel>().mapArray(itemJSON) {
                    
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
        return [DSShopModel]()
    }
    
    class func modifyDefaultShop(identify: Int, shopID: String, delegate: DSDataCenterDelegate) -> Void {
        DSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/web/shipoffline_user_privilege_json/modify_shipoffline_user_privilege_current.json"
            , para: ["shop_id" : shopID]
            , userInfo: nil)
    }
    
    // MARK: - Receive Order API
    class func requestReceiveOrderStatus(identify: Int, delegate: DSDataCenterDelegate) -> Void {
        DSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/web/shipoffline_user_privilege_json/find_accept_order.json"
            , para: nil
            , userInfo: nil)
    }
    
    class func parseOrderStatus(json:[String : AnyObject]) -> Bool {
        if let data = json["data"] as? [String:AnyObject] {
            if let value = data["accept_order"] as? NSNumber {
                if value == 1 {
                    return true
                }
            }
        }
        return false
    }
    
    class func modifyReceiveOrder(identify: Int, isReceive: Bool, delegate: DSDataCenterDelegate) -> Void {
        DSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/web/shipoffline_user_privilege_json/accept_order.json"
            , para: ["accept_order" : (isReceive ? "1" : "2")]
            , userInfo: nil)
    }
    
    // MARK: - 
    
    class func requestPurchaseRecords(identify: Int, delegate: DSDataCenterDelegate) -> Void {
        DSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/web/shipoffline_purchase_json/find_purchase_info.json"
            , para: nil
            , userInfo: nil)
    }
    
    class func parsePurchaseRecords(json:[String : AnyObject]) -> [String]? {
        if let data = json["data"] as? [String:AnyObject] {
            if let records = data["list"] as? [String] {
                return records
            }
        }
        return nil
    }
}
