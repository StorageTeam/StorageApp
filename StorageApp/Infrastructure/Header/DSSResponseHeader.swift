//
//  DSSResponseHeader.swift
//  StorageApp
//
//  Created by ascii on 16/6/23.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation

class DSSResponseHeader: NSObject {
    var code     : DSSResponseCode!
    var msg      : String!
    
    override init() {
        code    = DSSResponseCode.Normal
        msg     = nil;
    }
}
