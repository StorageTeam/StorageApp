//
//  DSEditService.swift
//  StorageApp
//
//  Created by jack on 16/6/29.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import ObjectMapper

class DSEditService: NSObject {

    class func requestEditDetail(identify: Int, delegate: DSDataCenterDelegate, productId: String) -> Void {
        var para          = [String : String]()
        para["id"]        = productId
        
        DSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/web/product_shipoffline_json/get_product_shipoffline_to_app.json"
            , para: ["product_shipoffline_json" : para]
            , userInfo: nil)
    }
    
    class func reqDelete(identify: Int, delegate: DSDataCenterDelegate, productId: String) -> Void {
        let para : [String] = [productId]
//        para["id"]        = productId
        
        DSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/web/product_shipoffline_json/remove_product_shipoffline_status_for_app.json"
            , para: ["product_shipoffline_json" : para]
            , userInfo: nil)
    }
    
    class func requestEdit(identify: Int, delegate: DSDataCenterDelegate, para:[String : AnyObject]) -> Void {
        
        DSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/web/product_shipoffline_json/modify_product_shipoffline_to_app.json"
            , para: ["product_shipoffline_json" : para]
            , userInfo: nil)
    }
    
    class func requestCreate(identify: Int, delegate: DSDataCenterDelegate, para:[String : AnyObject]) -> Void {
        
        DSDataCenter.Request(identify
            , delegate: delegate
            , path: "/link-site/web/product_shipoffline_json/create_product_shipoffline_to_app.json"
            , para: ["product_shipoffline_json" : para]
            , userInfo: nil)
    }
    
//    class func reqCreate(identify: Int, delegate: DSDataCenterDelegate, para:[String : AnyObject]) -> Void {
//        
//    }
    
    class func parseEditDetail(json:[String : AnyObject], toModel: EditViewModel) {
        
        if let data = json["data"] as? [String:AnyObject] {
            
            if let sourceItem = Mapper<EditSourceItem>().map(data) {
                toModel.sourceItem = sourceItem
            }
            
            if let proPicInfoArray = data["product_shipoffline_pic_list"] as? NSArray {
                if let picItemArray = Mapper<DSEditImgItem>().mapArray(proPicInfoArray) {
                    toModel.proImgArray = picItemArray
                }
            }
            
            if let pricePicInfoArray = data["audit_pic_json"] as? NSArray {
                if let picItemArray = Mapper<DSEditImgItem>().mapArray(pricePicInfoArray) {
                    toModel.priceImgArray = picItemArray
                }
            }
        
        }
    }
    
    class func parserImgUrl(json: [String : AnyObject]) -> String? {
        if let data = json["data"] as? [String:AnyObject] {
            return data["url"] as? String
        }
        return nil
    }
}
