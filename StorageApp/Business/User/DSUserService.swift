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
    class func requestLogin(identify: Int, delegate: DSDataCenterDelegate, email: String, password: String) -> Void {
        let did = UIDevice.currentDevice().identifierForVendor?.UUIDString ?? ""
        
        var para                    = [String : String]()
        para["email"]               = email
        para["password"]            = password
        para["d_id"]                = did
        para["authorize_login_sys"] = "4"
        
        DSDataCenter.Request(identify,
                              delegate: delegate,
                              path: "/link-site/web/crm_user/crm_login.json",
                              para: ["data_json" : para],
                              userInfo: nil)
    }
    
    class func requestRegister(identify: Int, delegate: DSDataCenterDelegate, email: String, password: String) -> Void {
        var para                    = [String : String]()
        para["email"]               = email
        para["password"]            = password
        
        DSDataCenter.Request(identify,
                             delegate: delegate,
                             path: "/link-site/web/crm_user/register_shipoffline_user.json",
                             para: ["data_json" : para],
                             userInfo: nil)
    }
    
    class func requestFindPWD(identify: Int, delegate: DSDataCenterDelegate, email: String, password: String, confirmPwd: String) -> Void {
        var para                    = [String : String]()
        para["email"]               = email
        para["new_password"]        = password
        para["confirm_password"]    = confirmPwd
        
        DSDataCenter.Request(identify,
                             delegate: delegate,
                             path: "/link-site/web/crm_user/reset_user_password.json",
                             para: ["data_json" : para],
                             userInfo: nil)
    }
}
