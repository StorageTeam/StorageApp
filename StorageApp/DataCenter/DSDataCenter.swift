//
//  DSDataCenter.swift
//  StorageApp
//
//  Created by ascii on 16/6/24.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation

enum DSResponseCode: Int {
    case Unknown            = 0
    case Normal             = 1
    case BusinessError      = 42000
    case AccessError        = 46000
}

@objc protocol DSDataCenterDelegate : NSObjectProtocol {
    func networkDidResponseSuccess(identify: Int, header: DSResponseHeader, response: [String : AnyObject], userInfo: [String : AnyObject]?) -> Void
    
    optional func networkDidResponseError(identify: Int, header: DSResponseHeader?, error: String?, userInfo: [String : AnyObject]?) -> Void
}

class DSDataCenter: NSObject {
    class func Request(identify: Int,
                       delegate: DSDataCenterDelegate,
                       path: String,
                       para: [String : AnyObject]?,
                       userInfo: [String : AnyObject]?,
                       fileData: NSData? = nil) {
        
        DSNetwork.Request(identify,
                           delegate: delegate,
                           path: path,
                           para: para,
                           userInfo: userInfo,
                           fileData: fileData)
    }

}
