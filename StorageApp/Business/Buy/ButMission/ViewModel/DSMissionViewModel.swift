//
//  DSMissionViewModel.swift
//  StorageApp
//
//  Created by jack on 16/8/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSMissionViewModel: NSObject {
    
    var dataArray: [DSMissionItem]?
    var shopArray: [DSShopModel]?
    
    var shopId: Int? {
        didSet {
            self.dataArray = self.filterDataArray()
        }
    }
    
    var orginDataArray: [DSMissionItem]? {
        didSet{
            self.dataArray = self.filterDataArray()
        }
    }
    
    
    func filterDataArray() -> [DSMissionItem]? {
        if (self.shopId != nil && self.orginDataArray?.count > 0) {
            var resArray : [DSMissionItem] = []
            
            for item in self.orginDataArray! {
                if item.shopID == self.shopId {
                    resArray.append(item)
                }
            }
            return resArray
        } else{
            return self.orginDataArray
        }
    }
    
    func checkSelectedShop() -> String? {
        if (shopArray?.count > 0) {
            for shopItem in self.shopArray! {
                
                if shopItem.isSelected != nil && shopItem.isSelected {
                    self.shopId = shopItem.itemID
                    return shopItem.name
                }
            }
        }
        self.shopId = nil
        return "全部"
    }
    
    func missionItemAtIndex(index: Int) -> DSMissionItem? {
        if index >= 0 && index < self.dataArray?.count {
            return self.dataArray![index]
        }
        return nil
    }
    
}
