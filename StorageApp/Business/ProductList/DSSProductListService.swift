//
//  DSSProductListService.swift
//  StorageApp
//
//  Created by ascii on 16/6/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation

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
}
