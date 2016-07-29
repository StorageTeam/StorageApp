//
//  DSSScanService.swift
//  StorageApp
//
//  Created by ascii on 16/7/29.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSSScanService: NSObject {
    class func requestUPCExist(identify: Int, delegate: DSSDataCenterDelegate, upc: String, supplierID: String, userInfo: [String : AnyObject]?) -> Void {
        var para        = [String : String]()
        para["upc"]         = upc
        para["supplier_id"] = supplierID
        
        DSSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/web/product_shipoffline_json/find_upc.json"
            , para: ["product_shipoffline_json" : para]
            , userInfo: userInfo)
    }
}
