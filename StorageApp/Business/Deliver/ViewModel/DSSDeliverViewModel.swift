//
//  DSSDeliverViewModel.swift
//  StorageApp
//
//  Created by ascii on 16/8/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

enum DSSDeliverCell: Int {
    case Unknown
    case Status
    case Product
    case Action
}


class DSSDeliverViewModel: NSObject {
    var dataSource = NSMutableArray.init(capacity: 2)
    
    override init() {
        super.init()
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if section >= 0 && section < self.dataSource.count {
            let model = self.dataSource[section] as? DSSDeliverMissionModel
            if let products = model?.products {
                return (1 + products.count + 1)
            }
        }
        return 2
    }
    
    func cellTypeAtIndexPath(indexPath : NSIndexPath) -> DSSDeliverCell {
        let rowCount = self.numberOfRowsInSection(indexPath.section)
        if indexPath.row == 0 {
            return .Status
        } else if (indexPath.row == (rowCount - 1)) {
            return .Action
        }
        return .Product
    }
    
    func heightForRowAtIndexPath(indexPath : NSIndexPath) -> CGFloat {
        let cellType = self.cellTypeAtIndexPath(indexPath)
        switch cellType {
        case .Status:
            return 44
        case .Product:
            return 108
        case .Action:
            return 50
        default:
            break
        }
        return CGFloat.min
    }
    
    func missionModelAtIndexPath(indexPath :NSIndexPath) -> DSSDeliverMissionModel? {
        let idx = indexPath.section
        if idx >= 0 && idx < self.dataSource.count {
            return (self.dataSource[idx] as? DSSDeliverMissionModel)
        }
        return nil
    }

}
