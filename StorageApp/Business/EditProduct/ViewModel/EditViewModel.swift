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

//let PIC_CELL_IDENTIFY = "PIC_CELL_IDENTIFY"
//let DESC_CELL_IDENTIFY = "DESC_CELL_IDENTIFY"
//let UPC_CELL_IDENTIFY = "UPC_CELL_IDENTIFY"
//let DELETE_CELL_IDENTIFY = "DELETE_CELL_IDENTIFY"
//let EDIT_COMMON_CELL_IDENTIFY = "EDIT_COMMON_CELL_IDENTIFY"

//public let EDIT_HEADER_VIEW_IDENTIFY = "EDIT_HEADER_VIEW_IDENTIFY"

class EditViewModel: NSObject {

    var editType = kEditType.kEditTypeAdd
    var productID: String?
    var address: String = ""
    var upc: String = ""
    var proImgArray : [DSSEditImgItem] = []
    var priceImgArray : [DSSEditImgItem] = []
    
//    var dataItem: DSSEditItem?

    func numberOfSection() -> Int {
        return 5
//        if self.editType == kEditType.kEditTypeEdit {
//            return 4
//        }
//        return 3
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
    func getPicCellCount(imgArray: [DSSEditImgItem]) -> Int{
        
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
    
    func getPicImgsAtIndexPath(indexPath: NSIndexPath) -> [DSSEditImgItem]? {
        
        let cellType = self.cellTypeForIndexPath(indexPath)
        guard cellType == kEditCellType.kEditCellTypePricePic || cellType == kEditCellType.kEditCellTypeProductPic else {
            return nil
        }
        
        let startIndex = indexPath.row * 3
        var imageArray: [DSSEditImgItem] = []
        
        var targetImgArray = self.proImgArray
        if cellType == kEditCellType.kEditCellTypePricePic {
            targetImgArray = self.priceImgArray
        }
        
        for index in 0...2 {
            if index + startIndex < targetImgArray.count {
                let imgItem = targetImgArray[index + startIndex]
                if imgItem.isKindOfClass(DSSEditImgItem) {
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
//    func getSavePara() -> [String : AnyObject]? {
//        let res = self.dataItem.isDataComplete()
//        if res.complete == false {
//            return nil
//        }
//        
//        var para : [String : AnyObject] = [:]
//        
//        var infoPara : [String : AnyObject] = [:]
//        
//        if self.dataItem.infoItem.name != nil {
//            infoPara["name"] = self.dataItem.infoItem.name
//        }
//        
//        if self.dataItem.infoItem.chinaName != nil {
//            infoPara["name_cn"] = self.dataItem.infoItem.chinaName
//        }
//        
//        if self.dataItem.infoItem.desc != nil {
//            infoPara["description"] = self.dataItem.infoItem.desc
//        }
//        
//        if self.dataItem.infoItem.brand != nil {
//            infoPara["brand"] = self.dataItem.infoItem.brand
//        }
//        
//        if (self.editType == kEditType.kEditTypeEdit) {
//            para["operation"] = "save"
//            
//            if self.productID != nil {
//                infoPara["id"] = self.productID
//            }
//        }
//        
//        infoPara["currency"] = "USD"
//        para["product_shipoffline"] = infoPara
//        
//        
//        var latitudePara : [String : AnyObject] = [:]
//        latitudePara["规格"] = "标配"
//        
//        var goodsInfoPara : [String : AnyObject] = [:]
//        
//        if self.dataItem.specItem.upcStr != nil {
//            goodsInfoPara["upc"] = self.dataItem.specItem.upcStr
//        }
//        
//        if self.dataItem.specItem.siteSku != nil {
//            goodsInfoPara["site_sku"] = self.dataItem.specItem.siteSku
//         }
//        
//        if self.dataItem.infoItem.price > 0 {
//            goodsInfoPara["price"] = self.dataItem.infoItem.price
//        }
//        
//        if self.dataItem.specItem.stock != nil {
//            goodsInfoPara["stock"] = self.dataItem.specItem.stock
//        }
//        
//        if self.dataItem.specItem.weight != nil {
//            goodsInfoPara["weight"] = self.dataItem.specItem.weight
//        }
//        
//        if self.dataItem.specItem.weight != nil {
//            goodsInfoPara["weight"] = self.dataItem.specItem.weight
//        }
//        
//        let imageItem = self.dataItem.picItems.first
//        if imageItem != nil && imageItem?.picUrl != nil{
//            goodsInfoPara["image"] = imageItem?.picUrl
//        }
//        
//        var specItemPara : [String : AnyObject] = [:]
//        specItemPara["goods_latitude"] = latitudePara
//        specItemPara["goods_info"] = goodsInfoPara
//        let specItemArray = [specItemPara]
//        
//        var specInfoPara : [String : AnyObject] = [:]
//        specInfoPara["product_shipoffline_goods_list"] = specItemArray
//        
//        var picDescItemArray : [[String : AnyObject]] = []
//        for imageItem in self.dataItem.picItems {
//            if imageItem.picUrl != nil {
//                let picDict = ["pic_url" : imageItem.picUrl!]
//                picDescItemArray.append(picDict)
//            }
//        }
//        specInfoPara["product_shipoffline_pic_list"] = picDescItemArray
//        
//        let valArray = ["标配"]
//        var valDict : [String : AnyObject] = [:]
//        valDict["product_spec_val_list"] = valArray
//        valDict["product_spec_def"] = "规格"
//        let specListArray = [valDict]
//        
//        specInfoPara["product_spec_list"] = specListArray
//        
//        para["product_shipoffline_goods"] = specInfoPara
//        
//        return para
//    }
    
//    lazy var dataItem: DSSEditItem = {
//        let dataItem = DSSEditItem.init()
//        return dataItem
//    }()
    
}
