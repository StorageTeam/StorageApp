//
//  DSSRequestHeader.swift
//  StorageApp
//
//  Created by ascii on 16/6/24.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation
import UIKit
import AdSupport

class DSSRequestHeader: NSObject {
    class func requestHeader() -> [String : AnyObject] {
        let did = UIDevice.currentDevice().identifierForVendor?.UUIDString ?? ""
        let aid = ASIdentifierManager.sharedManager().advertisingIdentifier.UUIDString ?? ""
        
        return ["p" : "i",
                "d_id" : did,
                "a_id" : aid,
                "tk" : DSSAccount.getToken(),
                "u_id" : DSSAccount.getUserID(),
                "ts" : String.init(Int64(NSDate().timeIntervalSince1970 * 1000)), // 毫秒
                "ver" : "1.0",
                "c_id" : "1"]
    }
}
