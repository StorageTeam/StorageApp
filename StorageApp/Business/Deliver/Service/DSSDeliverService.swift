//
//  DSSMissionServe.swift
//  StorageApp
//
//  Created by jack on 16/8/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import ObjectMapper

class DSSDeliverService: NSObject {
    class func requestMissionList(identify: Int, delegate: DSSDataCenterDelegate, startRow: String, pageSize: String = DSSConst.PageSize) -> Void {
        var para          = [String : String]()
        para["start_row"] = startRow
        para["page_size"] = pageSize
        
        DSSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/web/shipoffline_purchase_json/find_shipoffline_purchase.json"
            , para: ["shipoffline_json" : para]
            , userInfo: nil)
    }
    
    class func requestRecordList(identify: Int, delegate: DSSDataCenterDelegate, shopId: String) -> Void {
        var para          = [String : String]()
        para["shop_id"]   = shopId
        
        DSSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/web/shipoffline_purchase_json/find_shipoffline_purchase_goods.json"
            , para: ["shipoffline_json" : para]
            , userInfo: nil)
    }
    
    class func parseList(json:[String : AnyObject]) -> [DSSDeliverMissionModel] {
        if let itemJSON = json["data"]?["list"] {
            if let items = Mapper<DSSDeliverMissionModel>().mapArray(itemJSON) {
                return items
            }
        }
        return []
    }

    class func parserImgUrl(json: [String : AnyObject]) -> [DSSMissionItem]? {
        if let dataArray = json["data"]!["list"] as? [[String:AnyObject]] {
            for dataItem in dataArray {
                
            }
        }
        return nil
    }

}
