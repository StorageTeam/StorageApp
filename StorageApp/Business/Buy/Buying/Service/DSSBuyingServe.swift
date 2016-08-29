//
//  DSSBuyingServe.swift
//  StorageApp
//
//  Created by jack on 16/8/29.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSSBuyingServe: NSObject {

    class func reqMissionSuccess(identify: Int,
                                 goodsID: String,
                                 quality: Int,
                                 delegate: DSSDataCenterDelegate) -> Void{
        
        var para          = [String : String]()
        para["goods_id"] = goodsID
        para["current_purchase_quantity"] = String(quality)
        
        DSSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/web/shipoffline_purchase_json/purchase_success.json"
            , para: ["shipoffline_json" : para]
            , userInfo: nil)
    }
    
    class func reqMissionFail(identify: Int,
                                goodsID: String,
                                delegate: DSSDataCenterDelegate) -> Void{
        
        var para          = [String : String]()
        para["goods_id"] = goodsID
        
        DSSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/web/shipoffline_purchase_json/purchase_fail.json"
            , para: ["shipoffline_json" : para]
            , userInfo: nil)
    }
}
