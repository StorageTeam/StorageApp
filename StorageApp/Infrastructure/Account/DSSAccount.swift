//
//  DSSAccount.swift
//  StorageApp
//
//  Created by ascii on 16/6/23.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation

class DSSAccount: NSObject {
    static let accountSingleton = DSSAccount()
    
    private var mobile : String!
    
    func save(mobile: String!) -> Bool {
        DSSAccount.accountSingleton.mobile = mobile
        
        return true
    }
}
