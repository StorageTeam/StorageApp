//
//  DSSRequestHeader.swift
//  StorageApp
//
//  Created by ascii on 16/6/24.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation

class DSSRequestHeader: NSObject {
    static func requestHeader() -> [String : AnyObject] {
        
        return ["p" : "i",
                "d_id" : "e Mini Capsule Microphon"]
    }
}
