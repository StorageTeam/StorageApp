//
//  DSSResponseHeader.swift
//  StorageApp
//
//  Created by ascii on 16/6/23.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation

class DSResponseHeader: NSObject {
    var code     : DSResponseCode!
    var msg      : String!
    
    override init() {
        code    = DSResponseCode.Normal
        msg     = nil;
    }
}
