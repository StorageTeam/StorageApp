//
//  EditViewController.swift
//  JackSwift
//
//  Created by jack on 16/6/23.
//  Copyright © 2016年 FirstLink. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos


class EditViewController: DSSBaseViewController, DSSDataCenterDelegate{

    private let DETAIL_DATA_REQ = 1000
    private let DELETE_PRO_REQ = 1001
    private let CREATE_PRO_REQ = 1002
    private let EDIT_SAVE__REQ = 1003
    private let UPLOAD_IMG_REQ = 1004
    
    private let IMG_UPLOAD_INDEX_KEY = "IMG_UPLOAD_INDEX_KEY"
    private let IMG_UPLOAD_IS_PRODUCT_KEY = "IMG_UPLOAD_IS_PRODUCT_KEY"

//    weak private var firstRespond : UIView?
    
    // MARK: Life sycle
    override func viewDidLoad() {
        
        self.addAllSubviews()
        self.configNavItem()
//        self.addKeyboardObser()
//        self.requestInitalData()
        
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    convenience init(editType: kEditType, productID: String?) {
        self.init()
        self.viewModel.editType = editType
        self.viewModel.productID = productID
        
//        if editType == kEditType.kEditTypeAdd {
//            self.viewModel.dataItem = DSSEditItem.init()
//            self.viewModel.dataItem.picItems = [DSSEditImgItem]()
//            self.viewModel.dataItem.infoItem = DSSEditInfoItem.init()
//            self.viewModel.dataItem.specItem = DSSEditSpecItem.init()
//        }
    }
    
    deinit {
        self.cacheManger.stopCachingImagesForAllAssets()
    }
    
    func addAllSubviews() -> Void {
        self.view.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsZero)
        }
    }
    
//    deinit {
//        NSNotificationCenter.defaultCenter().removeObserver(self)
//    }
    
    // MARK: Reuqest
    func requestInitalData() {
        if self.viewModel.productID != nil && self.viewModel.editType != kEditType.kEditTypeAdd{
            self.showHUD()
            DSSEditService.requestEditDetail(DETAIL_DATA_REQ, delegate: self, productId: self.viewModel.productID!)
        }
    }
    
    func requestSaveData() {
        
        self.showHUD()
        
        if self.viewModel.editType == kEditType.kEditTypeAdd {
            // 新建
//            DSSEditService.requestCreate(CREATE_PRO_REQ, delegate: self, para: self.viewModel.getSavePara()!)
            
        }else if self.viewModel.editType == kEditType.kEditTypeEdit {
            // 修改
//            DSSEditService.requestEdit(EDIT_SAVE__REQ,
//                                       delegate: self,
//                                       para: self.viewModel.getSavePara()!)
        }
    }
    
    // MARK: Response
    func networkDidResponseSuccess(identify: Int, header: DSSResponseHeader, response: [String : AnyObject], userInfo: [String : AnyObject]?) {
        
        
        if header.code == DSSResponseCode.Normal {
            if identify == DETAIL_DATA_REQ {
                self.hidHud(false)
//                self.viewModel.dataItem = DSSEditService.parseEditDetail(response)!
                self.tableView.reloadData()
                
            } else if identify == DELETE_PRO_REQ {
                
                self.hidHud(false)
                self.showText("删除成功")
                self.clickBackAction()
                
            } else if identify == UPLOAD_IMG_REQ {
                
                let imgUrl = DSSEditService.parserImgUrl(response)
                let imgIndex : Int = (userInfo![IMG_UPLOAD_INDEX_KEY]?.integerValue)!
                let isProduct: Bool = userInfo![IMG_UPLOAD_IS_PRODUCT_KEY]!.boolValue
                if (imgUrl != nil) {
                    self.savePicUrl(imgUrl!, index: imgIndex, isProduct: isProduct)
                    self.checkAndSave()
                }
                
            } else if identify == CREATE_PRO_REQ {
                
                self.hidHud(false)
                self.showText("创建成功")
                self.clickBackAction()
                self.navigationController?.popViewControllerAnimated(true)
                
            } else if identify == EDIT_SAVE__REQ {
                
                self.hidHud(false)
                self.showText("修改保存成功")
                self.clickBackAction()
            }
            
        } else {
            print("error = \(response)")
        }
    }
    
    func networkDidResponseError(identify: Int, header: DSSResponseHeader?, error: String?, userInfo: [String : AnyObject]?) {
        self.hidHud(false)
        self.showText(header?.msg)
    }
    

    // MARK:  TextFieldCell delegate
//    func shouldBeginEditing(view: UIView) {
//        self.firstRespond = view
//    }
    
//    func finishInput(cell: UITableViewCell, text: String?) {
//        let indexPath = self.tableView.indexPathForCell(cell)
//        if (indexPath != nil) {
//            let cellType = self.viewModel.cellTypeForIndexPath(indexPath!)
//            
//            switch cellType {
//            case .kEditCellTypeTitle:
//                self.viewModel.dataItem.infoItem.name = text
//            case .kEditCellTypeName:
//                self.viewModel.dataItem.infoItem.chinaName = text
//            case .kEditCellTypeBrand:
//                self.viewModel.dataItem.infoItem.brand = text
//            case .kEditCellTypeDesc:
//                self.viewModel.dataItem.infoItem.desc = text
//            case .kEditCellTypePrice:
//                var priceInt : Int = 0
//                if (text != nil && text?.characters.count > 0) {
//                    let priceFloat = Float(text!)!
//                    priceInt = Int(round(priceFloat * 100))
//                }
//                self.viewModel.dataItem.infoItem.price = priceInt
//            case .kEditCellTypeStock:
//                self.viewModel.dataItem.specItem.stock = text
//            case .kEditCellTypeWeight:
//                self.viewModel.dataItem.specItem.weight = text
//            case .kEditCellTypeItemNo:
//                self.viewModel.dataItem.specItem.siteSku = text
//            case .kEditCellTypeUPC:
//                self.viewModel.dataItem.specItem.upcStr = text
//            default:
//                break
//            }
//        }
//    }
    
    // MARK: Action
//    func clickScanAction(sender: UIButton){
//        
//        if self.viewModel.editType == kEditType.kEditTypeCheck {
//            return
//        }
//        
//        weak var weakself = self
//        let scanController = FKScanController.init { (resStr) -> Void in
//            print("scan res string = \(resStr)")
//            weakself?.viewModel.dataItem.specItem.upcStr = resStr
//            weakself?.viewModel.dataItem.specItem.siteSku = resStr
//            weakself?.tableView.reloadData()
//        }
//        self.navigationController?.pushViewController(scanController, animated: true)
//    }
    
    func clickDeleteAction(){
        if self.viewModel.productID != nil {
            DSSEditService.reqDelete(DELETE_PRO_REQ, delegate: self, productId: self.viewModel.productID!)
        }
    
    }
    
    func clickBackAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func clickReleaseBtn() {
        
        self.view.endEditing(true)
    
        let res = self.viewModel.isDataComplete()
        if (res.complete == false){
            self.showText(res.error)
            //            print("not complete error = \(res?.error)")
            return
        }
        
        // 上传图片
        if self.viewModel.isAllImgUploaded() {
            self.requestSaveData()
        } else {
            
            self.uploadImgWith(self.viewModel.proImgArray, isProduct: true)
            self.uploadImgWith(self.viewModel.priceImgArray, isProduct: false)
        }
        
    }
    
    private func uploadImgWith(imageItems: [DSSEditImgItem], isProduct: Bool) {
        
        for imgItem in imageItems {
            if imgItem.image != nil && imgItem.picUrl == nil {
                let index = imageItems.indexOf(imgItem)
                var imgData = UIImagePNGRepresentation(imgItem.image!)
                if imgData == nil {
                    imgData = UIImageJPEGRepresentation(imgItem.image!, 1.0)
                }
                
                if imgData == nil {
                    continue
                }
    
                let info : [String : AnyObject] = [IMG_UPLOAD_INDEX_KEY : index!,
                                                   IMG_UPLOAD_IS_PRODUCT_KEY : isProduct]
                
                DSSDataCenter.Request(UPLOAD_IMG_REQ,
                                      delegate: self,
                                      path:  "/link-site/web/product_shipoffline_json/uploadFile.json",
                                      para: nil,
                                      userInfo: info,
                                      fileData: imgData)
                
            }
        }
    }
    
    // MARK: Mehod
    func configNavItem() -> Void {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Cancel",
                                                                     style: UIBarButtonItemStyle.Plain,
                                                                     target: self,
                                                                     action: #selector(self.clickBackAction))
        
        guard self.viewModel.editType == kEditType.kEditTypeEdit else {
            return
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "删除",
                                                                      style: UIBarButtonItemStyle.Plain,
                                                                      target: self,
                                                                      action: #selector(self.clickDeleteAction))
    }
    
    func savePicUrl(picUrl: String, index: Int, isProduct: Bool) {
        var picItems = self.viewModel.priceImgArray
        if isProduct {
            picItems = self.viewModel.proImgArray
        }
        
        if index < picItems.count {
            let imgItem = picItems[index]
            imgItem.picUrl = picUrl
        }
    }
    
    func checkAndSave() {
        if self.viewModel.isAllImgUploaded() {
            self.hidHud(false)
            self.requestSaveData()
        }
    }
    
//    func keyBoardChange(sender: NSNotification) {
//        
//        if sender.name == UIKeyboardWillShowNotification {
//            
//            let keyboardEndFrame = sender.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
//            let firstRespondRect = self.view.window?.convertRect((self.firstRespond?.frame)!, fromView: self.firstRespond?.superview)
//            let margin = (keyboardEndFrame?.origin.y)! - ((firstRespondRect?.origin.y)! + (firstRespondRect?.size.height)!)
//            
//            if margin < 20.0 {
//                let upMargin = 20 - margin
//                self.tableView.frame = CGRectOffset(self.tableView.frame, 0, -upMargin)
//            }
//        } else if sender.name == UIKeyboardWillHideNotification {
//            self.tableView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height)
//            self.tableView.contentInset = UIEdgeInsetsZero
//        }
//    }
    
    // MARK: Property
    lazy var tableView: UITableView = {
        
        let tableView = UITableView.init(frame: CGRectZero, style: .Grouped)
        tableView.backgroundColor = UIColor.init(rgb: 0xf4f4f4)
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .None
        
        tableView.registerClass(FKEditTitleCell.self, forCellReuseIdentifier: String(FKEditTitleCell))
        tableView.registerClass(FKEditPicCell.self, forCellReuseIdentifier: String(FKEditPicCell))
        tableView.registerClass(FKEditSaveCell.self, forCellReuseIdentifier: String(FKEditSaveCell))
        tableView.registerClass(FKEditHeaderView.self, forHeaderFooterViewReuseIdentifier: String(FKEditHeaderView))
        
        return tableView
    }()
    
    lazy var viewModel: EditViewModel = {
        let viewModel = EditViewModel.init()
        return viewModel
    }()
    
    lazy var cacheManger: PHCachingImageManager = {
        let manger = PHCachingImageManager.init()
        return manger
    }()
}

extension EditViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.viewModel.numberOfSection()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.viewModel.heightForRowAtIndexPath(indexPath)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(self.viewModel.cellIdentifyForIndexPath(indexPath))
        if cell == nil{
            cell = UITableViewCell.init(style: .Default, reuseIdentifier: nil)
        }
        
        
       if let picCell = cell as? FKEditPicCell {
            picCell.delegate = self
            picCell.tag = indexPath.row - 2
        }else if let saveCell = cell as? FKEditSaveCell {
            saveCell.saveBtn.addTarget(self, action: #selector(self.clickReleaseBtn), forControlEvents: .TouchUpInside)
        }
        
        cell?.fk_configWith(self.viewModel, indexPath: indexPath);
        return cell!
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let indexPath = NSIndexPath.init(forRow: 0, inSection: section)
        let cellType = self.viewModel.cellTypeForIndexPath(indexPath)
        guard cellType != kEditCellType.kEditCellTypeSave else {
            return nil
        }
        
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(String(FKEditHeaderView)) as? FKEditHeaderView
        
        switch cellType {
        case .kEditCellTypeAddress:
            headerView?.titleLabel.text = "地址"
        case .kEditCellTypeUPC:
            headerView?.titleLabel.text = "UPC"
        case .kEditCellTypeProductPic:
            headerView?.titleLabel.text = "照片"
        case .kEditCellTypePricePic:
            headerView?.titleLabel.text = "价签照片"
        default:
            break
        }
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let indexPath = NSIndexPath.init(forRow: 0, inSection: section)
        let cellType = self.viewModel.cellTypeForIndexPath(indexPath)
        guard cellType != kEditCellType.kEditCellTypeSave else {
            return CGFloat.min
        }
        return 35.0
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        self.view.endEditing(true)
//    }
    
    
}

extension EditViewController: FKEditPicCellDelegate, UINavigationControllerDelegate{
    
    func clickAddImg(picCell: FKEditPicCell){
        if let indexPath = self.tableView.indexPathForCell(picCell) {
            let cellType = self.viewModel.cellTypeForIndexPath(indexPath)
            var isProduct = true
            if cellType == kEditCellType.kEditCellTypePricePic {
                isProduct = false
            }
            weak var weakSelf = self
            let sheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .ActionSheet)
            
            let action0 = UIAlertAction.init(title: "Camera", style: .Default, handler: { (action: UIAlertAction) in
                weakSelf?.prensentImgPickWithType(.Camera, isProduct: isProduct)
            })
            
            let action1 = UIAlertAction.init(title: "PhotoLibray", style: .Default, handler: { (action: UIAlertAction) in
                weakSelf?.prensentImgPickWithType(.SavedPhotosAlbum, isProduct: isProduct) // 手机相册，而不是图库
            })
            
            let cancelAction = UIAlertAction.init(title: "Cancel", style: .Cancel, handler:nil)
            
            sheet.addAction(action0)
            sheet.addAction(action1)
            sheet.addAction(cancelAction)
            
            self.presentViewController(sheet, animated: true, completion: nil)

         }
    }
    
    func clickDeleteImg(picCell: FKEditPicCell, index: Int) {
//        let indexPath = self.tableView.indexPathForCell(picCell)
        if let indexPath = self.tableView.indexPathForCell(picCell) {
            
            let cellType = self.viewModel.cellTypeForIndexPath(indexPath)
            let imgIndex = indexPath.row * 3 + index
            if cellType == kEditCellType.kEditCellTypePricePic {
                if imgIndex < self.viewModel.priceImgArray.count {
                    self.viewModel.priceImgArray.removeAtIndex(imgIndex)
                    self.tableView.reloadData()
                }
            } else {
                if imgIndex < self.viewModel.proImgArray.count {
                    self.viewModel.proImgArray.removeAtIndex(imgIndex)
                    self.tableView.reloadData()
                }
            }
            
        }
    }
    
    func prensentImgPickWithType(type: UIImagePickerControllerSourceType, isProduct: Bool) {
        weak var weakSelf = self
        
        if type == .Camera {
            let takePhoto = DSSTakePhotoController.init(title: "拍照", takeDonePicture: { (images:[UIImage]) in
                weakSelf?.addImags(images, isProduct: isProduct)
            })
            self.navigationController?.pushViewController(takePhoto, animated: true)
        } else {
            let selectPic = DSSSelectImgController.init(selectDone: { (assets:[PHAsset]) in
                weakSelf?.addImags(assets, isProduct: isProduct)
            })
            self.navigationController?.pushViewController(selectPic, animated: true)
        }
//        if type == .Camera && !UIImagePickerController.isSourceTypeAvailable(type) {
//            self.showCameraAuthorityAlert()
//        } else {
//            let imgPicker = UIImagePickerController.init()
//            imgPicker.allowsEditing = true
//            imgPicker.sourceType = type
//            imgPicker.delegate = self
//            imgPicker.modalPresentationStyle = .FullScreen
//            self.presentViewController(imgPicker, animated: true, completion: nil)
//        }
    }
    
//    private func showCameraAuthorityAlert() {
//        let alert = UIAlertController.init(title: "dsds", message: "sd", preferredStyle: .Alert)
//        let action = UIAlertAction.init(title: "无法使用相机，请前往设置打开", style: .Default, handler: nil)
//        alert.addAction(action)
//        self.presentViewController(alert, animated: true, completion: nil)
//    }
    
    private func addImags(images: [UIImage], isProduct: Bool) {
        
        var targetImageItems: [DSSEditImgItem] = []
        for singleImg in images {
            
            let size = CGSizeMake(CGFloat(DSSConst.UPLOAD_PHOTO_LENGTH), CGFloat(DSSConst.UPLOAD_PHOTO_LENGTH))
            let sizedImg = UIImage.scaleImage(singleImg, toSize: size)
            let newImgItem = DSSEditImgItem()
            newImgItem.image = sizedImg
            targetImageItems.append(newImgItem)
        }

        if isProduct {
            self.viewModel.proImgArray.appendContentsOf(targetImageItems)
        } else {
            self.viewModel.priceImgArray.appendContentsOf(targetImageItems)
        }
        self.tableView.reloadData()
    }
    
    private func addImags(assets: [PHAsset], isProduct: Bool) {
    
//        let scale = UIScreen.mainScreen().scale
//        let size = CGSizeMake(CGFloat(FKEditImgContainer.getImgMargin() * scale), CGFloat(FKEditImgContainer.getImgMargin() * scale))
        let size = CGSizeMake(CGFloat(DSSConst.UPLOAD_PHOTO_LENGTH), CGFloat(DSSConst.UPLOAD_PHOTO_LENGTH))
        let option = PHImageRequestOptions.init()
        option.deliveryMode = .HighQualityFormat
        
        weak var weakSelf = self
        for assetItem in assets {
            self.cacheManger.requestImageForAsset(assetItem, targetSize: size, contentMode: .AspectFit, options: option, resultHandler: { (resImg: UIImage?, info:[NSObject : AnyObject]?) in
                
                print("finish load assset = \(assetItem), resimg = \(resImg)")
                let newImgItem = DSSEditImgItem()
                newImgItem.image = resImg
                if isProduct {
                    weakSelf?.viewModel.proImgArray.append(newImgItem)
                } else {
                    weakSelf?.viewModel.priceImgArray.append(newImgItem)
                }
                weakSelf?.tableView.reloadData()
            })
        }
        
//        if isProduct {
//            self.viewModel.proImgArray.appendContentsOf(targetImageItems)
//        } else {
//            self.viewModel.priceImgArray.appendContentsOf(targetImageItems)
//        }
//        self.tableView.reloadData()
    }
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        
//        let mediaType = info[UIImagePickerControllerMediaType] as! String
//        
//        var image : UIImage?
//        if mediaType == kUTTypeImage as String {
//            if picker.allowsEditing {
//                image = info[UIImagePickerControllerEditedImage] as? UIImage
//            }else{
//                image = info[UIImagePickerControllerOriginalImage] as? UIImage
//            }
//            
//            if image != nil {
//                image = UIImage.scaleImage(image!, toSize: CGSizeMake(CGFloat(DSSConst.UPLOAD_PHOTO_LENGTH), CGFloat(DSSConst.UPLOAD_PHOTO_LENGTH)))
//                
//                let newImgItem = DSSEditImgItem()
//                newImgItem.image = image
//                
//                self.viewModel.dataItem.picItems.append(newImgItem)
//                self.tableView.reloadData()
//            }
//        }
//        
//        picker.dismissViewControllerAnimated(true, completion: nil)
//    }

}


