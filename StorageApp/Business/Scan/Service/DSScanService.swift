//
//  DSScanService.swift
//  StorageApp
//
//  Created by ascii on 16/7/29.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSScanService: NSObject {
    class func requestUPCExist(identify: Int, delegate: DSDataCenterDelegate, upc: String, supplierID: String, userInfo: [String : AnyObject]?) -> Void {
        var para        = [String : String]()
        para["upc"]     = upc
        para["shop_id"] = supplierID
        para["upc"]         = upc
        para["shop_id"] = supplierID
        
        DSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/web/product_shipoffline_json/find_upc.json"
            , para: ["product_shipoffline_json" : para]
            , userInfo: userInfo)
    }
}
