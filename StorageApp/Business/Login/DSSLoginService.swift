//
//  DSSLoginService.swift
//  StorageApp
//
//  Created by ascii on 16/6/24.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation

class DSSLoginService: NSObject {
    static func login(identify: Int, delegate: DSSDataCenterDelegate, mobile: String, password: String) -> Void {
        var para = [String : String]()
        para["mobile"]   = mobile
        para["password"] = password
        para["p"]        = "i"
        
        DSSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/api/crm_user/offline_login2.json"
            , para: ["data_json" : para.description]
            , userInfo: nil)
    }
}
