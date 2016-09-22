//
//  EditViewModel.swift
//  JackSwift
//
//  Created by jack on 16/6/23.
//  Copyright © 2016年 FirstLink. All rights reserved.
//

import Foundation
import UIKit

enum kEditCellType: Int{
    case kEditCellTypeNone = 0
    case kEditCellTypeAddress
    case kEditCellTypeUPC
    case kEditCellTypeProductPic
    case kEditCellTypePricePic
    case kEditCellTypeSave
}

enum kEditType: Int{
    case kEditTypeAdd = 0
    case kEditTypeCheck
    case kEditTypeEdit
}

class EditViewModel: NSObject {

    var editType = kEditType.kEditTypeAdd
    var productID: String?
    
    var sourceItem = EditSourceItem.init()
    var proImgArray : [DSEditImgItem] = []
    var priceImgArray : [DSEditImgItem] = []
    
    func numberOfSection() -> Int {
        if self.editType == kEditType.kEditTypeCheck {
            if self.priceImgArray.count <= 0 {
                return 3
            }
            return 4
        }
        return 5
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        
        let indexpath = NSIndexPath.init(forRow: 0, inSection: section)
        let cellType = self.cellTypeForIndexPath(indexpath)
        
        if cellType == kEditCellType.kEditCellTypePricePic {
            return self.getPicCellCount(self.priceImgArray)
        } else if cellType == kEditCellType.kEditCellTypeProductPic {
            return self.getPicCellCount(self.proImgArray)
        }
        return 1

    }
    
    func heightForRowAtIndexPath(indexPath: NSIndexPath) -> CGFloat {
        
        let cellType = self.cellTypeForIndexPath(indexPath)
        
        switch cellType {
            case .kEditCellTypeAddress, .kEditCellTypeUPC:
                return 60.0
            case .kEditCellTypePricePic, .kEditCellTypeProductPic:
                return 115.0
            case .kEditCellTypeSave:
                return 105.0
            default:
                return 0.0
        }
    }
    
    func cellTypeForIndexPath(indexPath:NSIndexPath) -> kEditCellType {
        switch indexPath.section {
        case 0:
            return .kEditCellTypeAddress
        case 1:
            return .kEditCellTypeUPC
        case 2:
            return .kEditCellTypeProductPic
        case 3:
            return .kEditCellTypePricePic
        case 4:
            return .kEditCellTypeSave
        default:
            return .kEditCellTypeNone
        }
    }
    
    func cellIdentifyForIndexPath(indexPath:NSIndexPath) -> String {
        
        let cellType = self.cellTypeForIndexPath(indexPath)

        switch cellType {
        case .kEditCellTypeAddress, .kEditCellTypeUPC:
            return String(FKEditTitleCell)
        case .kEditCellTypePricePic, .kEditCellTypeProductPic:
            return String(FKEditPicCell)
        case .kEditCellTypeSave:
            return String(FKEditSaveCell)
        default:
            return " "
        }
    }
    

    // 获取图片cell的数量
    func getPicCellCount(imgArray: [DSEditImgItem]) -> Int{
        
        var picCellCount = 0
        picCellCount = Int(floor(CGFloat(imgArray.count) / 3.0)) + 1
        
        
        if picCellCount > 10 {
            picCellCount = 10
        }
        
        if picCellCount == 0 {
            return 1
        }
     
        return picCellCount
    }
    
    func getPicImgsAtIndexPath(indexPath: NSIndexPath) -> [DSEditImgItem]? {
        
        let cellType = self.cellTypeForIndexPath(indexPath)
        guard cellType == kEditCellType.kEditCellTypePricePic || cellType == kEditCellType.kEditCellTypeProductPic else {
            return nil
        }
        
        let startIndex = indexPath.row * 3
        var imageArray: [DSEditImgItem] = []
        
        var targetImgArray = self.proImgArray
        if cellType == kEditCellType.kEditCellTypePricePic {
            targetImgArray = self.priceImgArray
        }
        
        for index in 0...2 {
            if index + startIndex < targetImgArray.count {
                let imgItem = targetImgArray[index + startIndex]
                if imgItem.isKindOfClass(DSEditImgItem) {
                    imageArray.append(imgItem)
                }
            }
        }
        
        if imageArray.count > 0 {
            return imageArray
        }
        
        return nil
    }
    
    func isAllImgUploaded() -> Bool {
        
        guard self.proImgArray.count > 0 else {
            return false
        }
        
        for imageItem in self.proImgArray {
            if imageItem.image != nil && imageItem.picUrl == nil {
                return false
            }
        }
        
        for imageItem in self.priceImgArray {
            if imageItem.image != nil && imageItem.picUrl == nil {
                return false
            }
        }
        return true
    }
    
    func isDataComplete() -> (complete: Bool, error: String?) {
        
        var complete = true
        var errorStr: String?
        
        if self.proImgArray.count <= 0{
            complete = false
            errorStr = "至少上传一张商品主图"
        }
        return (complete, errorStr)
    }
    
    func getSavePara() -> [String : AnyObject]? {

        if self.editType == kEditType.kEditTypeCheck {
            return nil
        }
        
        var para: [String : AnyObject] = [:]
        
        if self.editType == kEditType.kEditTypeEdit{
            if self.productID != nil {
                para["id"] = self.productID
            }
        } else if self.editType == kEditType.kEditTypeAdd {
            
            if self.sourceItem.shopId != nil {
                para["shop_id"] = self.sourceItem.shopId
            }
            
            if self.sourceItem.upc != nil {
                para["upc"] = self.sourceItem.upc
            }
            
        }
        
        var proImgDictArray: [[String : AnyObject]] = []
        for picItem in self.proImgArray {
            guard picItem.picUrl != nil else {
                continue
            }
            var dict : [String : AnyObject] = [:]
            dict["pic_url"] = picItem.picUrl
            proImgDictArray.append(dict)
        }
        
        if proImgDictArray.count > 0 {
            para["product_shipoffline_pic_list"] = proImgDictArray
        }
        
        var priceImgDictArray: [[String : AnyObject]] = []
        for picItem in self.priceImgArray {
            guard picItem.picUrl != nil else {
                continue
            }
            var dict : [String : AnyObject] = [:]
            dict["pic_url"] = picItem.picUrl
            priceImgDictArray.append(dict)
        }
        
        if priceImgDictArray.count > 0 {
            para["audit_pic_json"] = priceImgDictArray
        }
        
        return para
    }
}
