//
//  DSSEditProItem.swift
//  StorageApp
//
//  Created by jack on 16/6/29.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
//import ObjectMapper

class DSEditItem: NSObject {

//    var infoItem : DSEditInfoItem?
//    var picItems : [DSEditImgItem]?
    
    func isDataComplete() -> (complete: Bool, error: String?) {
        
        var complete = true
        var errorStr: String?
        
        if self.infoItem.name == nil || self.infoItem.name?.characters.count == 0{
            complete = false
            errorStr = "Enter name"
        }else if self.picItems.count == 0 {
            complete = false
            errorStr = "Add at least one photo"
        } else if self.infoItem.price == nil || self.infoItem.price <= 0 {
            complete = false
            errorStr = "Enter Price"
        } else if self.specItem.stock == nil || Int((self.specItem.stock)!) <= 0 {
            complete = false
            errorStr = "Enter Inventory"
        } else if self.specItem.weight == nil || Int((self.specItem.weight)!) <= 0 {
            complete = false
            errorStr = "Enter Weight"
        }else if self.specItem.upcStr == nil || self.specItem.upcStr?.characters.count == 0 {
            complete = false
            errorStr = "Enter UPC"
        } else if self.specItem.siteSku == nil || self.specItem.siteSku?.characters.count == 0 {
            complete = false
            errorStr = "Enter Item number"
        }
        
        if self.infoItem.name != nil && self.infoItem.name?.characters.count > 255 {
            complete = false
            errorStr = "Product name can not exceed 255 characters"
        }
        
        if self.infoItem.chinaName != nil && self.infoItem.chinaName?.characters.count > 255 {
            complete = false
            errorStr = "Product name in Chinese can not exceed 255 characters"
        }
        
        if self.infoItem.brand != nil && self.infoItem.brand?.characters.count > 126 {
            complete = false
            errorStr = "Brand name can not exceed 126 characters"
        }
    
        return (complete, errorStr)
        
    }
    
    lazy var infoItem: DSEditInfoItem = {
        let infoItem = DSEditInfoItem.init()
        return infoItem
    }()
    
    lazy var specItem: DSEditSpecItem = {
        let specItem = DSEditSpecItem.init()
        return specItem
    }()
    
    lazy var picItems: [DSEditImgItem] = {
        let picItems : [DSEditImgItem] = []
        return picItems
    }()
}
