//
//  DSSDeliverViewModel.swift
//  StorageApp
//
//  Created by ascii on 16/8/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSSDeliverViewModel: NSObject {
    var dataSource : [DSSDeliverMissionModel]!
    
    override init() {
        super.init()
        
        self.dataSource = [DSSDeliverMissionModel]()
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if section >= 0 && section < self.dataSource.count {
            let model = self.dataSource[section]
            if let products = model.products {
                return (1 + products.count + 1)
            }
        }
        return 2
    }

}
