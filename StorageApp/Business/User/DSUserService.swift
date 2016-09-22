//
//  DSSLoginService.swift
//  StorageApp
//
//  Created by ascii on 16/6/24.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation
import UIKit

class DSUserService: NSObject {
    class func requestLogin(identify: Int, delegate: DSDataCenterDelegate, mobile: String, password: String) -> Void {
        let did = UIDevice.currentDevice().identifierForVendor?.UUIDString ?? ""
        
        var para                    = [String : String]()
        para["mobile"]              = mobile
        para["password"]            = password
        para["d_id"]                = did
        para["authorize_login_sys"] = "4"
        
        DSDataCenter.Request(identify,
                              delegate: delegate,
                              path: "/link-site/web/crm_user/crm_login.json",
                              para: ["data_json" : para],
                              userInfo: nil)
    }
}
