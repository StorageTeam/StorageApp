//
//  DSSProductListService.swift
//  StorageApp
//
//  Created by ascii on 16/6/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation
import ObjectMapper

class DSSProductListService: NSObject {
    class func requestList(identify: Int, delegate: DSSDataCenterDelegate, status: String, startRow: String, pageSize: String = DSSConst.PageSize) -> Void {
        var para          = [String : String]()
        para["status"]    = status
        para["start_row"] = startRow
        para["page_size"] = pageSize
        
        DSSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/api/product_shipoffline_json/find_product_shipoffline.json"
            , para: ["product_shipoffline_json" : para]
            , userInfo: nil)
    }
    
    class func parseList(json:[String : AnyObject]) -> (total: Int, items: [DSSProductListModel]) {
        if let data = json["data"] as? [String:AnyObject] {
            if let total = (data["pager"]?["total"] as? Int) {
                if let itemJSON = data["list"] {
                    if let items = Mapper<DSSProductListModel>().mapArray(itemJSON) {
                        return (total, items)
                    }
                }
            }
        }
        return (0, [])
    }
}
