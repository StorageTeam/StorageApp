                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       //
//  DSSAccount.swift
//  StorageApp
//
//  Created by ascii on 16/6/23.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation
import ObjectMapper

class DSSAccount: NSObject, Mappable, NSCoding {
    static private let gAccount = DSSAccount.loadFromFile()
    
    private var userid      : String!
    private var token       : String!
    private var mobile      : String!
    private var nickname    : String!
    private var headurl     : String!
    private var level       : String!
    private var status      : String!
    
    
    private override init() { }
    required init?(_ map: Map) { }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        self.userid   = aDecoder.decodeObjectForKey("userid") as? String
        self.token    = aDecoder.decodeObjectForKey("token") as? String
        self.mobile   = aDecoder.decodeObjectForKey("mobile") as? String
        self.nickname = aDecoder.decodeObjectForKey("nickname") as? String
        self.headurl  = aDecoder.decodeObjectForKey("headurl") as? String
        self.level    = aDecoder.decodeObjectForKey("level") as? String
        self.status   = aDecoder.decodeObjectForKey("status") as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.userid, forKey: "userid")
        aCoder.encodeObject(self.token, forKey: "token")
        aCoder.encodeObject(self.mobile, forKey: "mobile")
        aCoder.encodeObject(self.nickname, forKey: "nickname")
        aCoder.encodeObject(self.headurl, forKey: "headurl")
        aCoder.encodeObject(self.level, forKey: "level")
        aCoder.encodeObject(self.status, forKey: "status")
    }
    
    private class func loadFromFile() -> DSSAccount {
        if let account: DSSAccount = NSKeyedUnarchiver.unarchiveObjectWithFile(DSSAccount.archivePath()) as? DSSAccount {
            return account
        }
        return DSSAccount()
    }
    
    // MARK: - Method
    
    private class func archivePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let homePath: NSString = paths[0]
        return homePath.stringByAppendingPathComponent("DSSAccount.archive")
    }
    
    private class func setGAccount(account: DSSAccount?) {
        DSSAccount.gAccount.userid   = account?.userid
        DSSAccount.gAccount.token    = account?.token
        DSSAccount.gAccount.mobile   = account?.mobile
        DSSAccount.gAccount.nickname = account?.nickname
        DSSAccount.gAccount.headurl  = account?.headurl
        DSSAccount.gAccount.level    = account?.level
        DSSAccount.gAccount.status   = account?.status
    }
    
    // MARK:- Api
    
    class func saveAccount(json: AnyObject?) -> Void {
        let account = Mapper<DSSAccount>().map(json)
        DSSAccount.setGAccount(account)
        
        NSKeyedArchiver.archiveRootObject(DSSAccount.gAccount, toFile: DSSAccount.archivePath())
    }
    
    class func isLogin() -> Bool {
        if DSSAccount.gAccount.token != nil {
            return true
        }
        return false
    }
    
    class func getToken() -> String {
        if let token = DSSAccount.gAccount.token {
            return token
        }
        return ""
    }
    
    class func getUserID() -> String {
        if let userid = DSSAccount.gAccount.userid {
            return userid
        }
        return ""
    }
    
    func mapping(map: Map) {
        userid      <- (map["userid"], DSSStringTransform())
        token       <- map["token"]
        mobile      <- (map["mobile"], DSSStringTransform())
        nickname    <- map["nickname"]
        headurl     <- map["headurl"]
        level       <- (map["level"], DSSStringTransform())
        status      <- (map["status"], DSSStringTransform())
    }
}
