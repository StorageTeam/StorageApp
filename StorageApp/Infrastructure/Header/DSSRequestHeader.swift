//
//  DSSRequestHeader.swift
//  StorageApp
//
//  Created by ascii on 16/6/24.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation

class DSSRequestHeader: NSObject {
    class func requestHeader() -> [String : AnyObject] {
        
        return ["p" : "i",
                "d_id" : "eMiniCapsuleMicrophon",
                "tk" : DSSAccount.getToken(),
                "u_id" : "15001",
                "ts" : "15001000",
                "ver" : "1.2.1",
                "c_id" : "eMiniCapsuleMicrophon"]
    }
}
