//
//  DSMissionServe.swift
//  StorageApp
//
//  Created by jack on 16/8/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import ObjectMapper

class DSDeliverService: NSObject {
    class func requestMissionList(identify: Int, delegate: DSDataCenterDelegate, startRow: String, pageSize: String = DSConst.PageSize) -> Void {
        var para          = [String : String]()
        para["start_row"] = startRow
        para["page_size"] = pageSize
        
        DSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/web/shipoffline_purchase_json/find_shipoffline_purchase.json"
            , para: ["shipoffline_json" : para]
            , userInfo: nil)
    }
    
    class func deliverWithID(identify: Int, itemID: String?, delegate: DSDataCenterDelegate) -> Void {
        if let missionID = itemID {
            var para   = [String : String]()
            para["id"] = missionID
            
            DSDataCenter.Request(identify
                , delegate: delegate
                , path: "/link-site/web/shipoffline_purchase_json/confirm_shipment.json"
                , para: ["shipoffline_json" : para]
                , userInfo: nil)
        }
    }
    
    class func requestRecordList(identify: Int, delegate: DSDataCenterDelegate, startRow: String, pageSize: String = DSConst.PageSize) -> Void {
        var para          = [String : String]()
        para["start_row"] = startRow
        para["page_size"] = pageSize
        
        DSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/web/shipoffline_purchase_json/find_shipoffline_ship_record.json"
            , para: ["shipoffline_json" : para]
            , userInfo: nil)
    }
    
    class func parseList(json:[String : AnyObject]) -> [DSDeliverMissionModel] {
        if let itemJSON = json["data"]?["list"] {
            if let items = Mapper<DSDeliverMissionModel>().mapArray(itemJSON) {
                return items
            }
        }
        return []
    }

}
