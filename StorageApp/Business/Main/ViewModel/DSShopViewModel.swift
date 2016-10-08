//
//  DSShopViewModel.swift
//  StorageApp
//
//  Created by ascii on 16/7/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation

class DSShopViewModel: NSObject {
    var shopListArray: [DSShopModel]!
    var purchaseRecordArray: [String]?
    
    override init() {
        super.init()
        self.shopListArray = [DSShopModel]()
        self.purchaseRecordArray = nil
    }
    
    func getSelShopName() -> String? {
        for model in self.shopListArray {
            if model.isSelected == true {
                return model.name
            }
        }
        return nil
    }
    
    func getSelShopID() -> String? {
        for model in self.shopListArray {
            if model.isSelected == true {
                return String.init(model.itemID)
            }
        }
        return nil
    }
    
    func popFirstPurchaseRecord() -> String? {
        if let value = self.purchaseRecordArray?.first {
            self.purchaseRecordArray?.removeFirst()
            return value
        }
        return nil
    }
    
    func isEmpty() -> Bool {
        if self.shopListArray.count == 0 {
            return true
        }
        return false
    }
    
    func clearData() -> Void {
        self.shopListArray = [DSShopModel]()
    }
}
