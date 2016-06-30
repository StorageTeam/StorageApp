//
//  DSSEditService.swift
//  StorageApp
//
//  Created by jack on 16/6/29.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import ObjectMapper

class DSSEditService: NSObject {

    class func requestEditDetail(identify: Int, delegate: DSSDataCenterDelegate, productId: String) -> Void {
        var para          = [String : String]()
        para["id"]        = productId
        
        DSSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/web/product_shipoffline_json/get_product_shipoffline.json"
            , para: ["product_shipoffline_json" : para]
            , userInfo: nil)
    }
    
    class func reqDelete(identify: Int, delegate: DSSDataCenterDelegate, productId: String) -> Void {
        let para : [String] = [productId]
//        para["id"]        = productId
        
        DSSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/web/product_shipoffline_json/remove_product_shipoffline_status.json"
            , para: ["product_shipoffline_json" : para]
            , userInfo: nil)
    }
    
    class func requestEdit(identify: Int, delegate: DSSDataCenterDelegate, para:[String : AnyObject]) -> Void {
        
        DSSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/web/product_shipoffline_json/modify_product_shipoffline.json"
            , para: ["product_shipoffline_json" : para]
            , userInfo: nil)
    }
    
    class func requestCreate(identify: Int, delegate: DSSDataCenterDelegate, para:[String : AnyObject]) -> Void {
        
        DSSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/web/product_shipoffline_json/create_product_shipoffline.json"
            , para: ["product_shipoffline_json" : para]
            , userInfo: nil)
    }
    
//    class func reqCreate(identify: Int, delegate: DSSDataCenterDelegate, para:[String : AnyObject]) -> Void {
//        
//    }
    
    class func parseEditDetail(json:[String : AnyObject]) -> DSSEditItem? {
        if let data = json["data"] as? [String:AnyObject] {
            
            let editItem = DSSEditItem()
            
            if let infoDict = data["product_shipoffline"] as? NSDictionary {
                editItem.infoItem = Mapper<DSSEditInfoItem>().map(infoDict)
            }
            
            if let shipDict = data["product_shipoffline_goods"] as? NSDictionary {
                if let specArrayDict = shipDict["product_shipoffline_goods_list"] as? [NSDictionary] {
                    if let itemDict = specArrayDict.first {
                        if let goodsDict = itemDict["goods_info"] {
                            editItem.specItem = Mapper<DSSEditSpecItem>().map(goodsDict)
                        }
                    }
                }
                
                if let imgArrayDict = shipDict["product_shipoffline_pic_list"] as? [NSDictionary] {
                    editItem.picItems = Mapper<DSSEditImgItem>().mapArray(imgArrayDict)!
                }
            }
            
            return editItem
        }
        return nil
    }
}
