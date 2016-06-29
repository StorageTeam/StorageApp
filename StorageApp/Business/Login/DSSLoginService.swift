//
//  DSSLoginService.swift
//  StorageApp
//
//  Created by ascii on 16/6/24.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation

class DSSLoginService: NSObject {
    class func requestLogin(identify: Int, delegate: DSSDataCenterDelegate, mobile: String, password: String) -> Void {
        var para = [String : String]()
        para["mobile"]   = mobile
        para["password"] = password
        
        DSSDataCenter.Request(identify,
                              delegate: delegate,
                              path: "/link-site/api/crm_user/offline_login.json",
                              para: ["data_json" : para],
                              userInfo: nil)
    }
}
