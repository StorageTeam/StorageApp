//
//  DSSMainViewModel.swift
//  StorageApp
//
//  Created by ascii on 16/7/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation

class DSSMainViewModel: NSObject {
    var supplierArray: [DSSSupplierModel]!
    
    override init() {
        super.init()
        self.supplierArray = [DSSSupplierModel]()
    }
    
    func getSelSupplierName() -> String? {
        for model in self.supplierArray {
            if model.isSelected == true {
                return model.name
            }
        }
        return nil
    }
    
    func getSelSupplierID() -> String? {
        for model in self.supplierArray {
            if model.isSelected == true {
                return String.init(model.itemID)
            }
        }
        return nil
    }
    
    func isEmpty() -> Bool {
        if self.supplierArray.count == 0 {
            return true
        }
        return false
    }
    
    func clearData() -> Void {
        self.supplierArray = [DSSSupplierModel]()
    }
}
