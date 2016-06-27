//
//  DSSAccount.swift
//  StorageApp
//
//  Created by ascii on 16/6/23.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation
import ObjectMapper

class DSSAccount: NSObject, Mappable {
    static private let gAccount = DSSAccount()
    
    private var userid      : String!
    private var token       : String!
    private var mobile      : String!
    private var nickname    : String!
    private var headurl     : String!
    private var level       : String!
    private var status      : String!
    
    static func saveAccount(json: AnyObject?) -> Void {
        let account = Mapper<DSSAccount>().map(json)
        
        DSSAccount.gAccount.userid   = account?.userid
        DSSAccount.gAccount.token    = account?.token
        DSSAccount.gAccount.mobile   = account?.mobile
        DSSAccount.gAccount.nickname = account?.nickname
        DSSAccount.gAccount.headurl  = account?.headurl
        DSSAccount.gAccount.level    = account?.level
        DSSAccount.gAccount.status   = account?.status
    }
    
    static func isLogin() -> Bool {
        if DSSAccount.gAccount.token != nil {
            return true
        }
        return false
    }
    
    override init() {
        super.init()
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        userid      <- map["userid"]
        token       <- map["token"]
        mobile      <- map["mobile"]
        nickname    <- map["nickname"]
        headurl     <- map["headurl"]
        level       <- map["level"]
        status      <- map["status"]
    }
}
