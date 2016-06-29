//
//  DSSProductListViewModel.swift
//  StorageApp
//
//  Created by ascii on 16/6/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation

enum DSSProductListType: Int {
    case Unknown
    case OnSale
    case WaitSale
}

class DSSProductListViewModel: NSObject {
    var listType = DSSProductListType.Unknown
    
    var waitSaleProds = [DSSProductListModel]()
    var onSaleProds   = [DSSProductListModel]()
    
    override init() {
        super.init()
    }
    
    func isEmpty() -> Bool {
        return (self.waitSaleProds.count == 0 && self.onSaleProds.count == 0)
    }
    
    func append(objs: [DSSProductListModel], type:DSSProductListType) {
        if objs.count == 0 {
            return
        }
        
        if type == .WaitSale {
            self.waitSaleProds += objs
        } else if type == .OnSale {
            self.onSaleProds += objs
        }
    }
    
    func arrayWithType(type: DSSProductListType) -> Array<DSSProductListModel> {
        if self.listType == .WaitSale {
            return self.waitSaleProds
        }
        return self.onSaleProds
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return self.arrayWithType(self.listType).count
    }
    
    func itemAtIndexPath(indexPath: NSIndexPath) -> DSSProductListModel? {
        let array = self.arrayWithType(self.listType)
        if indexPath.row < array.count {
            return array[indexPath.row]
        }
        
        return nil
    }
}
