//
//  DSBuyRecordServe.swift
//  StorageApp
//
//  Created by jack on 16/8/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import ObjectMapper

class DSBuyRecordServe: NSObject {
    class func reqRecordList(identify: Int, delegate: DSDataCenterDelegate) -> Void {
        var para          = [String : String]()
        para["start_row"] = "0"
        para["page_size"] = "100"
        
        DSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/web/shipoffline_purchase_json/find_shipoffline_purchase_record.json"
            , para: ["shipoffline_json" : para]
            , userInfo: nil)
    }
    
    class func parserRecordList(json: [String : AnyObject]) -> [DSMissionItem]? {
        if let dataArray = json["data"]!["list"] as? [[String:AnyObject]] {
            
            if let items = Mapper<DSMissionItem>().mapArray(dataArray) {
                return items
            }
            
        }
        return nil
    }

}
