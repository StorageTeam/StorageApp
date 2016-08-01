//
//  DSSProductListViewModel.swift
//  StorageApp
//
//  Created by ascii on 16/6/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation
import UIKit

enum DSSProductListType: Int {
    case WaitSale
    case OnSale
}

class DSSProductListViewModel: NSObject {
    var listType = DSSProductListType.WaitSale
    
    var waitSaleProds = NSMutableArray.init(capacity: 2)
    var onSaleProds   = NSMutableArray.init(capacity: 2)
    
    override init() {
        super.init()
    }
    
    func isEmpty() -> Bool {
        return (self.waitSaleProds.count == 0 && self.onSaleProds.count == 0)
    }
    
    func append(objs: [AnyObject], type:DSSProductListType) {
        if objs.count == 0 {
            return
        }
        
        if type == .WaitSale {
            self.waitSaleProds.addObjectsFromArray(objs)
        } else if type == .OnSale {
            self.onSaleProds.addObjectsFromArray(objs)
        }
    }
    
    func removeAll(type:DSSProductListType) {
        if type == .WaitSale {
            self.waitSaleProds.removeAllObjects()
        } else if type == .OnSale {
            self.onSaleProds.removeAllObjects()
        }
    }
    
    func removeModel(indexPath: NSIndexPath, type:DSSProductListType) -> Void {
        let array = self.arrayWithType(type)
        if indexPath.row < array.count {
            array.removeObjectAtIndex(indexPath.section)
        }
    }
    
    func arrayWithType(type: DSSProductListType) -> NSMutableArray {
        if self.listType == .WaitSale {
            return self.waitSaleProds
        }
        return self.onSaleProds
    }
    
    func numberOfSection() -> Int {
        return self.arrayWithType(self.listType).count
    }
    
    func itemAtIndexPath(indexPath: NSIndexPath) -> AnyObject? {
        let array = self.arrayWithType(self.listType)
        if indexPath.row < array.count {
            return array.objectAtIndex(indexPath.section)
        }
        
        return nil
    }
}
