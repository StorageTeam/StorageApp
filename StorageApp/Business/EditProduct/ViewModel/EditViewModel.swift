//
//  EditViewModel.swift
//  JackSwift
//
//  Created by jack on 16/6/23.
//  Copyright © 2016年 FirstLink. All rights reserved.
//

import Foundation
import UIKit

public enum kEditCellType: Int{
    case kEditCellTypeNone = 0
    case kEditCellTypeTitle
    case kEditCellTypeName
    case kEditCellTypePic
//    case kEditCellTypeGroup
    case kEditCellTypeBrand
    case kEditCellTypeDesc
    case kEditCellTypePrice
    case kEditCellTypeStock
    case kEditCellTypeWeight
    case kEditCellTypeUPC
    case kEditCellTypeItemNo
}


public enum kGroupType: Int{
    case kGroupTypeNone = 0
    case kGroupTypeNeuter
    case kGroupTypeMale
    case kGroupTypeFemale
}


public let PIC_CELL_IDENTIFY = "PIC_CELL_IDENTIFY"
//public let SEX_CELL_IDENTIFY = "SEX_CELL_IDENTIFY"
public let DESC_CELL_IDENTIFY = "DESC_CELL_IDENTIFY"
public let UPC_CELL_IDENTIFY = "UPC_CELL_IDENTIFY"
public let EDIT_COMMON_CELL_IDENTIFY = "EDIT_COMMON_CELL_IDENTIFY"

public let EDIT_HEADER_VIEW_IDENTIFY = "EDIT_HEADER_VIEW_IDENTIFY"

class EditViewModel: NSObject {

    var currentUpcStr : String?
    var proImgArray: [UIImage] = []
    internal var groupType: kGroupType = kGroupType.kGroupTypeNeuter
    
    
    func numberOfSection() -> Int {
        
        return 3
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        switch section {
        case 0:
            return 2 + self.getPicCellCount()
        case 1:
            return 2
        case 2:
            return 5
        default:
            return 0
        }
    }
    
    func heightForRowAtIndexPath(indexPath: NSIndexPath) -> CGFloat {
        
        let cellType = self.cellTypeForIndexPath(indexPath)
        
        switch cellType {
        case .kEditCellTypePic:
            return 120.0
        case .kEditCellTypeDesc:
            return 75.0
        case .kEditCellTypeNone:
            return 0.0
        default:
            return 49.0
        }
    }
    
    func cellTypeForIndexPath(indexPath:NSIndexPath) -> kEditCellType {
        
        if indexPath.section == 0{
            
            switch indexPath.row {
                case 0:
                    return .kEditCellTypeTitle
                case 1:
                    return .kEditCellTypeName
                default:
                    return .kEditCellTypePic
            }
            
        }else if indexPath.section == 1{
            
            switch indexPath.row {
                case 0:
                    return .kEditCellTypeBrand
                case 1:
                    return .kEditCellTypeDesc
                default:
                    return .kEditCellTypeNone
            }
            
        }else if indexPath.section == 2{
            
            switch indexPath.row {
                case 0:
                    return .kEditCellTypePrice
                case 1:
                    return .kEditCellTypeStock
                case 2:
                    return .kEditCellTypeWeight
                case 3:
                    return .kEditCellTypeUPC
                case 4:
                    return .kEditCellTypeItemNo
                default:
                    return .kEditCellTypeNone
            }
        }
        
        return .kEditCellTypeNone
    }
    
    func cellIdentifyForIndexPath(indexPath: NSIndexPath) -> String {
        
        let cellType = self.cellTypeForIndexPath(indexPath);
        
        switch cellType {
        case .kEditCellTypePic:
            return PIC_CELL_IDENTIFY
//        case .kEditCellTypeGroup:
//            return SEX_CELL_IDENTIFY
        case .kEditCellTypeDesc:
            return DESC_CELL_IDENTIFY
        case .kEditCellTypeUPC:
            return UPC_CELL_IDENTIFY
        default:
            return EDIT_COMMON_CELL_IDENTIFY
        }
    }
    
    // 获取图片cell的数量
    func getPicCellCount() -> Int{
        var picCellCount = Int(ceil(CGFloat(self.proImgArray.count) / 3.0))
        if picCellCount > 10 {
            picCellCount = 10
        }
        
        if picCellCount == 0 {
            return 1
        }
        
        return picCellCount
    }
    
    func getPicImgsAtIndexPath(indexPath: NSIndexPath) -> [UIImage]? {
        
        if indexPath.section != 0 || indexPath.row <= 1{
            return nil
        }
        
        let startIndex = (indexPath.row - 2) * 3
        var imageArray: [UIImage] = []
        
        for index in 0...2 {
            if index + startIndex < self.proImgArray.count {
                imageArray.append(self.proImgArray[index + startIndex])
            }
        }
        
        if imageArray.count > 0 {
            return imageArray
        }
        
        return nil
    }
    
}
