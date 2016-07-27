//
//  DSSDataCenter.swift
//  StorageApp
//
//  Created by ascii on 16/6/24.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation

enum DSSResponseCode: Int {
    case Unknown            = 0
    case Normal             = 1
    case BusinessError      = 42000
    case AccessError        = 46000
}

@objc protocol DSSDataCenterDelegate : NSObjectProtocol {
    func networkDidResponseSuccess(identify: Int, header: DSSResponseHeader, response: [String : AnyObject], userInfo: [String : AnyObject]?) -> Void
    
    optional func networkDidResponseError(identify: Int, header: DSSResponseHeader?, error: String?, userInfo: [String : AnyObject]?) -> Void
}

class DSSDataCenter: NSObject {
    class func Request(identify: Int,
                       delegate: DSSDataCenterDelegate,
                       path: String,
                       para: [String : AnyObject]?,
                       userInfo: [String : AnyObject]?,
                       fileData: NSData? = nil) {
        
        DSSNetwork.Request(identify,
                           delegate: delegate,
                           path: path,
                           para: para,
                           userInfo: userInfo,
                           fileData: fileData)
    }

}
