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


class EditViewController: DSBaseViewController, DSDataCenterDelegate{

    private let DETAIL_DATA_REQ = 1000
    private let DELETE_PRO_REQ = 1001
    private let CREATE_PRO_REQ = 1002
    private let EDIT_SAVE__REQ = 1003
    private let UPLOAD_IMG_REQ = 1004
    
    private let IMG_UPLOAD_INDEX_KEY = "IMG_UPLOAD_INDEX_KEY"
    private let IMG_UPLOAD_IS_PRODUCT_KEY = "IMG_UPLOAD_IS_PRODUCT_KEY"
    
    // MARK: Life sycle
    override func viewDidLoad() {
        
        self.addAllSubviews()
        self.configNavBar()
        self.requestInitalData()
        
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    convenience init(editType: kEditType, productID: String?) {
        self.init()
        self.viewModel.editType = editType
        self.viewModel.productID = productID
    }
    
    convenience init(source: EditSourceItem, images: [UIImage]?) {
        self.init(editType: kEditType.kEditTypeAdd, productID: nil)
        self.viewModel.sourceItem = source
        if images != nil {
            self.addImags(images!, isProduct: true)
        }
        
    }
    
    deinit {
        let status = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        if status == .Authorized {
            self.cacheManger.stopCachingImagesForAllAssets()
        }
    }
    
    //MARK: - UI config
    func addAllSubviews() -> Void {
        self.view.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsZero)
        }
    }
    
    func configNavBar() -> Void {
        self.configNavTitle()
        self.configNavItems()
    }
    
    func configNavTitle() {
        
        var title = ""
        switch self.viewModel.editType {
        case kEditType.kEditTypeAdd:
            title = "添加商品"
        case .kEditTypeEdit:
            title = "商品编辑"
        case .kEditTypeCheck:
            title = "商品详情"
        }
        
        self.navigationItem.title = title
    }
    
    func configNavItems() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "common_back"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.clickBackAction))
        
        guard self.viewModel.editType == kEditType.kEditTypeEdit else {
            return
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "删除",
                                                                      style: UIBarButtonItemStyle.Plain,
                                                                      target: self,
                                                                      action: #selector(self.clickDeleteAction))
        
    }

    
    // MARK: - Reuqest
    func requestInitalData() {
        if self.viewModel.productID != nil {
            self.showHUD()
            DSEditService.requestEditDetail(DETAIL_DATA_REQ, delegate: self, productId: self.viewModel.productID!)
        }
    }
    
    func requestSaveData() {
        
        self.showHUD()
        
        if let para = self.viewModel.getSavePara() {
            
            if self.viewModel.editType == kEditType.kEditTypeAdd {
                // 新建
                DSEditService.requestCreate(CREATE_PRO_REQ, delegate: self, para: para)
            }else if self.viewModel.editType == kEditType.kEditTypeEdit {
                // 修改
                DSEditService.requestEdit(EDIT_SAVE__REQ, delegate: self, para: para)
            }

        } else {
            self.hidHud(false)
        }
    }
    
    // MARK: - Response
    func networkDidResponseSuccess(identify: Int, header: DSResponseHeader, response: [String : AnyObject], userInfo: [String : AnyObject]?) {
        
        if header.code == DSResponseCode.Normal {
            if identify == DETAIL_DATA_REQ {
                self.hidHud(false)
                DSEditService.parseEditDetail(response, toModel: self.viewModel)
                self.tableView.reloadData()
                
            } else if identify == DELETE_PRO_REQ {
                 //.,mxzsaasd 
                self.hidHud(false)
                self.showText("删除成功")
                self.clickBackAction()
                
            } else if identify == UPLOAD_IMG_REQ {
                
                let imgUrl = DSEditService.parserImgUrl(response)
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
            self.showText(header.msg)
        }
    }
    
    func networkDidResponseError(identify: Int, header: DSResponseHeader?, error: String?, userInfo: [String : AnyObject]?) {
        self.hidHud(false)
        self.showText(header?.msg)
    }
    
    // MARK: - Action
    func clickDeleteAction(){
        if self.viewModel.productID != nil {
            DSEditService.reqDelete(DELETE_PRO_REQ, delegate: self, productId: self.viewModel.productID!)
        }
    
    }
    
    func clickBackAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func clickSaveBtn() {
            
        let res = self.viewModel.isDataComplete()
        if (res.complete == false){
            self.showText(res.error)
            return
        }
        
        // 上传图片
        if self.viewModel.isAllImgUploaded() {
            self.requestSaveData()
        } else {
            self.showHUD()
            self.uploadImgWith(self.viewModel.proImgArray, isProduct: true)
            self.uploadImgWith(self.viewModel.priceImgArray, isProduct: false)
        }
        
    }
    
     // MARK: - Mehod
    private func uploadImgWith(imageItems: [DSEditImgItem], isProduct: Bool) {
        
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
                
                DSDataCenter.Request(UPLOAD_IMG_REQ,
                                      delegate: self,
                                      path:  "/link-site/web/product_shipoffline_json/upload_file.json",
                                      para: nil,
                                      userInfo: info,
                                      fileData: imgData)
                
            }
        }
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
    
    // MARK: - Property
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
            saveCell.saveBtn.addTarget(self, action: #selector(self.clickSaveBtn), forControlEvents: .TouchUpInside)
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
            
            let action0 = UIAlertAction.init(title: "照相机", style: .Default, handler: { (action: UIAlertAction) in
                weakSelf?.prensentImgPickWithType(.Camera, isProduct: isProduct)
            })
            
            let action1 = UIAlertAction.init(title: "相册", style: .Default, handler: { (action: UIAlertAction) in
                weakSelf?.prensentImgPickWithType(.SavedPhotosAlbum, isProduct: isProduct) // 手机相册，而不是图库
            })
            
            let cancelAction = UIAlertAction.init(title: "取消", style: .Cancel, handler:nil)
            
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
        
        var remainCount = 30 - self.viewModel.priceImgArray.count
        if isProduct {
            remainCount = 30 - self.viewModel.proImgArray.count
        }
        
        if type == .Camera {
            
            let takePhoto = DSTakePhotoController.init(title: "拍照", takeDonePicture: { (images:[UIImage]) in
                
                weakSelf?.addImags(images, isProduct: isProduct)
                weakSelf?.navigationController?.popViewControllerAnimated(true)
                
                }, cancel: nil)
            
            takePhoto.maxImgCount = remainCount
            self.navigationController?.pushViewController(takePhoto, animated: true)
            
        } else {
            
            let selectPic = DSSelectImgController.init(selectDone: { (assets:[PHAsset]) in
                weakSelf?.addImagAsset(assets, isProduct: isProduct)
                weakSelf?.navigationController?.popViewControllerAnimated(true)
            })
            selectPic.maxImgCount = remainCount
            self.navigationController?.pushViewController(selectPic, animated: true)
        }
    }
    
    private func addImags(images: [UIImage], isProduct: Bool) {
        
        var targetImageItems: [DSEditImgItem] = []
        for singleImg in images {
            
//            let size = CGSizeMake(CGFloat(DSConst.UPLOAD_PHOTO_LENGTH), CGFloat(DSConst.UPLOAD_PHOTO_LENGTH))
//            let sizedImg = UIImage.scaleImage(singleImg, toSize: size)
            let newImgItem = DSEditImgItem()
            newImgItem.image = singleImg
            targetImageItems.append(newImgItem)
        }

        if isProduct {
            self.viewModel.proImgArray.appendContentsOf(targetImageItems)
        } else {
            self.viewModel.priceImgArray.appendContentsOf(targetImageItems)
        }
        self.tableView.reloadData()
    }
    
    private func addImagAsset(assets: [PHAsset], isProduct: Bool) {

        let size = CGSizeMake(CGFloat(DSConst.UPLOAD_PHOTO_LENGTH), CGFloat(DSConst.UPLOAD_PHOTO_LENGTH))
        let option = PHImageRequestOptions.init()
        option.deliveryMode = .HighQualityFormat
        
        weak var weakSelf = self
        for assetItem in assets {
            self.cacheManger.requestImageForAsset(assetItem, targetSize: size, contentMode: .AspectFit, options: option, resultHandler: { (resImg: UIImage?, info:[NSObject : AnyObject]?) in
                
                let newImgItem = DSEditImgItem()
                newImgItem.image = resImg
                if isProduct {
                    weakSelf?.viewModel.proImgArray.append(newImgItem)
                } else {
                    weakSelf?.viewModel.priceImgArray.append(newImgItem)
                }
                weakSelf?.tableView.reloadData()
            })
        }
    }
}


