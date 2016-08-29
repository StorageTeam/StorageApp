//
//  DSSBuyRecordServe.swift
//  StorageApp
//
//  Created by jack on 16/8/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import ObjectMapper

class DSSBuyRecordServe: NSObject {
    class func reqRecordList(identify: Int, delegate: DSSDataCenterDelegate) -> Void {
        var para          = [String : String]()
        para["start_row"] = "0"
        para["page_size"] = "100"
        
        DSSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/web/shipoffline_purchase_json/find_shipoffline_purchase_record.json"
            , para: ["shipoffline_json" : para]
            , userInfo: nil)
    }
    
    class func parserRecordList(json: [String : AnyObject]) -> [DSSMissionItem]? {
        if let dataArray = json["data"]!["list"] as? [[String:AnyObject]] {
            
            if let items = Mapper<DSSMissionItem>().mapArray(dataArray) {
                return items
            }
            
        }
        return nil
    }

}
