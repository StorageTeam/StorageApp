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
    class func requestWaitsaleList(identify: Int, delegate: DSDataCenterDelegate, startRow: String, pageSize: String = DSConst.PageSize) -> Void {
        var para          = [String : String]()
        para["start_row"] = startRow
        para["page_size"] = pageSize
        
        DSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/web/product_shipoffline_json/find_product_shipoffline_stay_submit.json"
            , para: ["product_shipoffline_json" : para]
            , userInfo: nil)
    }
    
    class func requestOnsaleList(identify: Int, delegate: DSDataCenterDelegate, startRow: String, pageSize: String = DSConst.PageSize) -> Void {
        var para          = [String : String]()
        para["status"]    = "2"
        para["start_row"] = startRow
        para["page_size"] = pageSize
        
        DSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/web/product_shipoffline_json/find_product_shipoffline_for_app.json"
            , para: ["product_shipoffline_json" : para]
            , userInfo: nil)
    }
    
    class func deleteList(identify: Int, delegate: DSDataCenterDelegate, ids: [Int], userInfo: [String : Int]) -> Void {
        DSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/web/product_shipoffline_json/remove_product_shipoffline_status_for_app.json"
            , para: ["product_shipoffline_json" : ids]
            , userInfo: userInfo)
    }
    
    class func parseWaitsaleList(json:[String : AnyObject]) -> (total: Int, items: [DSProductWaitsaleModel]) {
        if let data = json["data"] as? [String:AnyObject] {
            if let total = (data["pager"]?["total"] as? Int) {
                if let itemJSON = data["list"] {
                    if let items = Mapper<DSProductWaitsaleModel>().mapArray(itemJSON) {
                        return (total, items)
                    }
                }
            }
        }
        return (0, [])
    }
    
    class func parseOnsaleList(json:[String : AnyObject]) -> (total: Int, items: [DSProductOnsaleModel]) {
        if let data = json["data"] as? [String:AnyObject] {
            if let total = (data["pager"]?["total"] as? Int) {
                if let itemJSON = data["list"] {
                    if let items = Mapper<DSProductOnsaleModel>().mapArray(itemJSON) {
                        return (total, items)
                    }
                }
            }
        }
        return (0, [])
    }
}
