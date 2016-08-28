//
//  DSSShopViewModel.swift
//  StorageApp
//
//  Created by ascii on 16/7/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation

class DSSShopViewModel: NSObject {
    var shopArray: [DSSShopModel]!
    
    override init() {
        super.init()
        self.shopArray = [DSSShopModel]()
    }
    
    func getSelShopName() -> String? {
        for model in self.shopArray {
            if model.isSelected == true {
                return model.name
            }
        }
        return nil
    }
    
    func getSelShopID() -> String? {
        for model in self.shopArray {
            if model.isSelected == true {
                return String.init(model.itemID)
            }
        }
        return nil
    }
    
    func isEmpty() -> Bool {
        if self.shopArray.count == 0 {
            return true
        }
        return false
    }
    
    func clearData() -> Void {
        self.shopArray = [DSSShopModel]()
    }
}
