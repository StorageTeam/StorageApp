//
//  DSSAccount.swift
//  StorageApp
//
//  Created by ascii on 16/6/23.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 采购角色类型
 
 - RoleTypeBuyer:   采购员
 - RoleTypeDeliver: 发货员
 - RoleTypeAdmin:   管理员
 */
enum RoleType: Int {
    case RoleTypeBuyer
    case RoleTypeDeliver
    case RoleTypeAdmin
    
    func isBuyerAble() -> Bool {
        if self == .RoleTypeBuyer || self == .RoleTypeAdmin {
            return true
        }
        return false
    }
    
    func isDeliverAble() -> Bool {
        if self == .RoleTypeDeliver || self == .RoleTypeAdmin {
            return true
        }
        return false
    }
}

class DSSAccountRole: NSObject, Mappable, NSCoding {
    private var role    : String?
    private var name    : String?
    
    override init() {
        super.init()
        
        self.role = nil
        self.name = nil
    }
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        role        <- (map["id"], DSSStringTransform())
        name        <- map["name"]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        self.role = aDecoder.decodeObjectForKey("role") as? String
        self.name = aDecoder.decodeObjectForKey("name") as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.role, forKey: "role")
        aCoder.encodeObject(self.name, forKey: "name")
    }
}

class DSSAccount: NSObject, Mappable, NSCoding {
    static private let gAccount = DSSAccount.loadFromFile()
    
    private var userid      : String?
    private var token       : String?
    private var mobile      : String?
    private var nickname    : String?
    private var headurl     : String?
//    private var roles       : [DSSAccountRole]?
    
    private override init() { }
    required init?(_ map: Map) { }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        self.userid   = aDecoder.decodeObjectForKey("userid") as? String
        self.token    = aDecoder.decodeObjectForKey("token") as? String
        self.mobile   = aDecoder.decodeObjectForKey("mobile") as? String
        self.nickname = aDecoder.decodeObjectForKey("nickname") as? String
        self.headurl  = aDecoder.decodeObjectForKey("headurl") as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.userid,    forKey: "userid")
        aCoder.encodeObject(self.token,     forKey: "token")
        aCoder.encodeObject(self.mobile,    forKey: "mobile")
        aCoder.encodeObject(self.nickname,  forKey: "nickname")
        aCoder.encodeObject(self.headurl,   forKey: "headurl")
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
    }
    
    // MARK:- Api
    
    class func getAccount() -> DSSAccount {
        return DSSAccount.gAccount;
    }
    
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
    
    class func logout() -> Void {
        DSSAccount.gAccount.userid   = nil
        DSSAccount.gAccount.token    = nil
        DSSAccount.gAccount.mobile   = nil
        DSSAccount.gAccount.nickname = nil
        DSSAccount.gAccount.headurl  = nil
        
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(DSSAccount.archivePath()) {
            do {
                try fileManager.removeItemAtPath(DSSAccount.archivePath())
            } catch {
                print("error")
            }
        }
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
    
    class func getHeadURL() -> String? {
        if let headurl = DSSAccount.gAccount.headurl {
            return headurl
        }
        return nil
    }
    
    class func getNickname() -> String? {
        if let nick = DSSAccount.gAccount.nickname {
            return nick
        }
        return nil
    }
    
    class func getRoleType() -> RoleType {
        return .RoleTypeAdmin
    }
    
    func mapping(map: Map) {
        userid      <- (map["id"], DSSStringTransform())
        token       <- map["token"]
        mobile      <- (map["mobile"], DSSStringTransform())
        nickname    <- map["nickname"]
        headurl     <- map["head_pic"]
//        roles       <- map["roles"]
    }
}
