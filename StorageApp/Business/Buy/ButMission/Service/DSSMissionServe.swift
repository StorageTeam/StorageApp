//
//  DSSMissionServe.swift
//  StorageApp
//
//  Created by jack on 16/8/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSSMissionServe: NSObject {
    class func reqMissionList(identify: Int, delegate: DSSDataCenterDelegate, shopId: String) -> Void {
        var para          = [String : String]()
        para["shop_id"]   = shopId
        
        DSSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/web/shipoffline_purchase_json/find_shipoffline_purchase_goods.json"
            , para: ["shipoffline_json" : para]
            , userInfo: nil)
    }

    class func parserImgUrl(json: [String : AnyObject]) -> [DSSMissionItem]? {
        if let dataArray = json["data"]!["list"] as? [[String:AnyObject]] {
            for dataItem in dataArray {
                
            }
        }
        return nil
    }

}
