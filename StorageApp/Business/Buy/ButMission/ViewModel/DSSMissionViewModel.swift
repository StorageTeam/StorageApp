//
//  DSSMissionViewModel.swift
//  StorageApp
//
//  Created by jack on 16/8/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSSMissionViewModel: NSObject {
    
    var dataArray: [DSSMissionItem]?
    var shopArray: [DSSShopModel]?
    
    var shopId: Int? {
        didSet {
            self.dataArray = self.filterDataArray()
        }
    }
    
    var orginDataArray: [DSSMissionItem]? {
        didSet{
            self.dataArray = self.filterDataArray()
        }
    }
    
    
    func filterDataArray() -> [DSSMissionItem]? {
        if (self.shopId != nil && self.orginDataArray?.count > 0) {
            var resArray : [DSSMissionItem] = []
            
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
    
    func missionItemAtIndex(index: Int) -> DSSMissionItem? {
        if index >= 0 && index < self.dataArray?.count {
            return self.dataArray![index]
        }
        return nil
    }
    
}
