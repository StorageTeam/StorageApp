//
//  DSAccount.swift
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

class DSAccountRole: NSObject, Mappable, NSCoding {
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
        role        <- (map["id"], DSStringTransform())
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

class DSAccount: NSObject, Mappable, NSCoding {
    static private let gAccount = DSAccount.loadFromFile()
    
    private var userid      : String?
    private var token       : String?
    private var mobile      : String?
    private var nickname    : String?
    private var headurl     : String?
    private var role        : String?
    
    private override init() { }
    required init?(_ map: Map) { }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        self.userid   = aDecoder.decodeObjectForKey("userid") as? String
        self.token    = aDecoder.decodeObjectForKey("token") as? String
        self.mobile   = aDecoder.decodeObjectForKey("mobile") as? String
        self.nickname = aDecoder.decodeObjectForKey("nickname") as? String
        self.headurl  = aDecoder.decodeObjectForKey("headurl") as? String
        self.role     = aDecoder.decodeObjectForKey("role") as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.userid,    forKey: "userid")
        aCoder.encodeObject(self.token,     forKey: "token")
        aCoder.encodeObject(self.mobile,    forKey: "mobile")
        aCoder.encodeObject(self.nickname,  forKey: "nickname")
        aCoder.encodeObject(self.headurl,   forKey: "headurl")
        aCoder.encodeObject(self.role,      forKey: "role")
    }
    
    private class func loadFromFile() -> DSAccount {
        if let account: DSAccount = NSKeyedUnarchiver.unarchiveObjectWithFile(DSAccount.archivePath()) as? DSAccount {
            return account
        }
        return DSAccount()
    }
    
    // MARK: - Method

    private class func archivePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let homePath: NSString = paths[0]
        return homePath.stringByAppendingPathComponent("DSAccount.archive")
    }
    
    private class func setGAccount(account: DSAccount?) {
        DSAccount.gAccount.userid   = account?.userid
        DSAccount.gAccount.token    = account?.token
        DSAccount.gAccount.mobile   = account?.mobile
        DSAccount.gAccount.nickname = account?.nickname
        DSAccount.gAccount.headurl  = account?.headurl
        DSAccount.gAccount.role     = account?.role
    }
    
    // MARK:- Api
    
    class func getAccount() -> DSAccount {
        return DSAccount.gAccount;
    }
    
    class func saveAccount(json: AnyObject?) -> Void {
        let account = Mapper<DSAccount>().map(json)
        DSAccount.setGAccount(account)
        
        NSKeyedArchiver.archiveRootObject(DSAccount.gAccount, toFile: DSAccount.archivePath())
    }
    
    class func isLogin() -> Bool {
        if DSAccount.gAccount.token != nil {
            return true
        }
        return false
    }
    
    class func logout() -> Void {
        DSAccount.gAccount.userid   = nil
        DSAccount.gAccount.token    = nil
        DSAccount.gAccount.mobile   = nil
        DSAccount.gAccount.nickname = nil
        DSAccount.gAccount.headurl  = nil
        DSAccount.gAccount.role     = nil
        
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(DSAccount.archivePath()) {
            do {
                try fileManager.removeItemAtPath(DSAccount.archivePath())
            } catch {
                print("error")
            }
        }
    }
    
    class func getToken() -> String {
        if let token = DSAccount.gAccount.token {
            return token
        }
        return ""
    }
    
    class func getUserID() -> String {
        if let userid = DSAccount.gAccount.userid {
            return userid
        }
        return ""
    }
    
    class func getHeadURL() -> String? {
        if let headurl = DSAccount.gAccount.headurl {
            return headurl
        }
        return nil
    }
    
    class func getNickname() -> String? {
        if let nick = DSAccount.gAccount.nickname {
            return nick
        }
        return nil
    }
    
    class func getRoleType() -> RoleType {
        if let role = DSAccount.gAccount.role {
            switch role {
            case "1":
                return .RoleTypeBuyer
            case "2":
                return .RoleTypeDeliver
            case "3":
                return .RoleTypeAdmin
            default:
                break
            }
        }
        return .RoleTypeBuyer
    }
    
    func mapping(map: Map) {
        userid      <- (map["id"], DSStringTransform())
        token       <- map["token"]
        mobile      <- (map["mobile"], DSStringTransform())
        nickname    <- map["nickname"]
        headurl     <- map["head_pic"]
        role        <- (map["privilege"], DSStringTransform())
    }
}
