//
//  DSSMainViewService.swift
//  StorageApp
//
//  Created by ascii on 16/7/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation
import ObjectMapper

class DSSMainViewService: NSObject {
    // MARK: - Request List
    class func requestList(identify: Int, delegate: DSSDataCenterDelegate) -> Void {
        DSSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/web/shipoffline_user_privilege_json/find_shipoffline_user_privilege.json"
            , para: nil
            , userInfo: nil)
    }
    
    class func parseList(json:[String : AnyObject]) -> [DSSSupplierModel] {
        if let data = json["data"] as? [String:AnyObject] {
            if let itemJSON = data["list"] {
                if let items = Mapper<DSSSupplierModel>().mapArray(itemJSON) {
                    
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
        return [DSSSupplierModel]()
    }
    
    // MARK: - Set Default Supplier
    class func modifyDefaultSupplier(identify: Int, supplierID: String, delegate: DSSDataCenterDelegate) -> Void {
        DSSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/web/shipoffline_user_privilege_json/modify_shipoffline_user_privilege_current.json"
            , para: ["supplier_id" : supplierID]
            , userInfo: nil)
    }
    
    
}
