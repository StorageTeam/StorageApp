//
//  EditViewController.swift
//  JackSwift
//
//  Created by jack on 16/6/23.
//  Copyright © 2016年 FirstLink. All rights reserved.
//

import UIKit
import MobileCoreServices

class EditViewController: DSSBaseViewController, DSSDataCenterDelegate, FKEditBaseCellDelegate{

//    private var editType = kEditType.kEditTypeAdd
    private var tableView : UITableView! = nil
    private var viewModel : EditViewModel = EditViewModel()
    
    private let DETAIL_DATA_REQ = 1000
    private let DELETE_PRO_REQ = 1001
    private let CREATE_PRO_REQ = 1002
    private let EDIT_SAVE__REQ = 1003
    private let UPLOAD_IMG_REQ = 1004
    
    private let IMG_INDEX_KEY = "IMG_INDEX_KEY"
    
    override func viewDidLoad() {
        self.buildTableView()
        self.addAllSubviews()
        self.configNavItem()
        self.addKeyboardObser()
        
        if self.viewModel.productID != nil && self.viewModel.editType != kEditType.kEditTypeAdd{
            DSSEditService.requestEditDetail(DETAIL_DATA_REQ, delegate: self, productId: self.viewModel.productID!)
        }
        
    }
    
    convenience init(editType: kEditType, productID: String?) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel.editType = editType
        self.viewModel.productID = productID
        
        if editType == kEditType.kEditTypeAdd {
            self.viewModel.dataItem = DSSEditItem.init()
            self.viewModel.dataItem?.picItems = [DSSEditImgItem]()
            self.viewModel.dataItem?.infoItem = DSSEditInfoItem.init()
            self.viewModel.dataItem?.specItem = DSSEditSpecItem.init()
        }
    }
    
    func addAllSubviews() -> Void {
        self.view.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsZero)
        }
    }
    
    func addKeyboardObser() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyBoardChange(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyBoardChange(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func configNavItem() -> Void {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.clickBackAction))
        
        if self.viewModel.editType != kEditType.kEditTypeCheck {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Release", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.clickReleaseBtn))
        }
    }
    
    func networkDidResponseSuccess(identify: Int, header: DSSResponseHeader, response: [String : AnyObject], userInfo: [String : AnyObject]?) {
        if header.code == DSSResponseCode.Normal {
            if identify == DETAIL_DATA_REQ {
                
                self.viewModel.dataItem = DSSEditService.parseEditDetail(response)
                self.tableView.reloadData()
                
            } else if identify == DELETE_PRO_REQ {
                
                self.showHUD("删除成功")
                self.popAfterTime(2)
                
            } else if identify == UPLOAD_IMG_REQ {
                
                let imgUrl = DSSEditService.parserImgUrl(response)
                let imgIndex : Int = (userInfo![IMG_INDEX_KEY]?.integerValue)!
                if (imgUrl != nil) {
                    self.savePicUrl(imgUrl!, index: imgIndex)
                    self.checkAndSave()
                }
                
            } else if identify == CREATE_PRO_REQ {
                
                self.showHUD("创建成功")
                self.popAfterTime(2)
                self.navigationController?.popViewControllerAnimated(true)
                
            } else if identify == EDIT_SAVE__REQ {
                
                self.showHUD("修改保存成功")
                self.popAfterTime(2)
            }
            
        } else {
            print("error = \(response)")
        }
    }
    
    func networkDidResponseError(identify: Int, header: DSSResponseHeader?, error: String?, userInfo: [String : AnyObject]?) {
        print("receive error identify = \(identify), header = \(header), error = \(error)")
    }
    
    private func buildTableView() -> Void{
        
        self.tableView = UITableView.init(frame: CGRectZero, style: .Grouped)
        self.tableView.backgroundColor = UIColor.init(rgb: 0xf8f8f8)
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.separatorStyle = .None
        
        self.tableView.registerClass(FKEditInputCell.self, forCellReuseIdentifier: EDIT_COMMON_CELL_IDENTIFY)
        self.tableView.registerClass(FKEditPicCell.self, forCellReuseIdentifier: PIC_CELL_IDENTIFY)
        self.tableView.registerClass(FKEditDescCell.self, forCellReuseIdentifier: DESC_CELL_IDENTIFY)
        self.tableView.registerClass(FKEditUpcCell.self, forCellReuseIdentifier: UPC_CELL_IDENTIFY)
        self.tableView.registerClass(FKEditDeleteCell.self, forCellReuseIdentifier: DELETE_CELL_IDENTIFY)
        self.tableView.registerClass(FKEditHeaderView.self, forHeaderFooterViewReuseIdentifier: EDIT_HEADER_VIEW_IDENTIFY)
    }
    
    func popAfterTime(second: UInt64) {
        weak var weakSelf = self
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(second * NSEC_PER_SEC)), dispatch_get_main_queue(), {
            weakSelf!.navigationController?.popViewControllerAnimated(true)
        })
    }
    
    func finishInput(cell: FKEditBaseCell, text: String?) {
        let indexPath = self.tableView.indexPathForCell(cell)
        if (indexPath != nil) {
            let cellType = self.viewModel.cellTypeForIndexPath(indexPath!)
            
            switch cellType {
            case .kEditCellTypeTitle:
                self.viewModel.dataItem?.infoItem?.name = text
            case .kEditCellTypeName:
                self.viewModel.dataItem?.infoItem?.chinaName = text
            case .kEditCellTypeBrand:
                self.viewModel.dataItem?.infoItem?.brand = text
            case .kEditCellTypeDesc:
                self.viewModel.dataItem?.infoItem?.desc = text
            case .kEditCellTypePrice:
                var priceInt : Float = 0.0
                if (text != nil && text?.characters.count > 0) {
                    priceInt = Float(text!)!
                }
                self.viewModel.dataItem?.infoItem?.price = priceInt
            case .kEditCellTypeStock:
                self.viewModel.dataItem?.specItem?.stock = text
            case .kEditCellTypeWeight:
                self.viewModel.dataItem?.specItem?.weight = text
            case .kEditCellTypeItemNo:
                self.viewModel.dataItem?.specItem?.siteSku = text
            default:
                break
            }
        }
    }
    
    func clickScanAction(sender: UIButton){
        
        if self.viewModel.editType == kEditType.kEditTypeCheck {
            return
        }
        
        weak var weakself = self
        let scanController = FKScanController.init { (resStr) -> Void in
            print("scan res string = \(resStr)")
            weakself?.viewModel.dataItem?.specItem?.upcStr = resStr
            weakself?.viewModel.dataItem?.specItem?.siteSku = resStr
            weakself?.tableView.reloadData()
        }
        self.navigationController?.pushViewController(scanController, animated: true)
    }
    
    func clickDeleteAction(sender: UIButton){
        if self.viewModel.productID != nil {
            DSSEditService.reqDelete(DELETE_PRO_REQ, delegate: self, productId: self.viewModel.productID!)
        }
    
    }
    
    func clickBackAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func clickReleaseBtn() {
        
        self.view.endEditing(true)
    
        let res = self.viewModel.dataItem?.isDataComplete()
        if (res?.complete == false){
            self.showHUD(res?.error)
            //            print("not complete error = \(res?.error)")
            return
        }
        
        // 上传图片
        if self.viewModel.isAllImgUploaded() {
            self.requestSaveData()
        } else {
            
            for imgItem in (self.viewModel.dataItem?.picItems)! {
                if imgItem.image != nil && imgItem.picUrl == nil {
                    let index = self.viewModel.dataItem?.picItems?.indexOf(imgItem)
                    var imgData = UIImagePNGRepresentation(imgItem.image!)
                    if imgData == nil {
                        imgData = UIImageJPEGRepresentation(imgItem.image!, 1.0)
                    }
                    
                    if imgData == nil {
                        continue
                    }
                    
                    let info : [String : AnyObject] = [IMG_INDEX_KEY : index!]
                    DSSDataCenter.Request(UPLOAD_IMG_REQ,
                                          delegate: self,
                                          path:  "/link-site/web/product_shipoffline_json/uploadFile.json",
                                          para: nil,
                                          userInfo: info,
                                          fileData: imgData)
                    
                }
            }
        }
        
    }
    
    func savePicUrl(picUrl: String, index: Int) {
        if index < self.viewModel.dataItem?.picItems?.count {
            let imgItem = self.viewModel.dataItem?.picItems![index]
            imgItem?.picUrl = picUrl
        }
    }
    
    func checkAndSave() {
        if self.viewModel.isAllImgUploaded() {
            print("all img loaded then save")
            self.requestSaveData()
        }
    }
    
    func requestSaveData() {
        if self.viewModel.editType == kEditType.kEditTypeAdd {
            // 新建
            DSSEditService.requestCreate(CREATE_PRO_REQ, delegate: self, para: self.viewModel.getSavePara()!)
            
        }else if self.viewModel.editType == kEditType.kEditTypeEdit {
            // 修改
            DSSEditService.requestEdit(EDIT_SAVE__REQ, delegate: self, para: self.viewModel.getSavePara()!)
        }
    }
    
    func keyBoardChange(sender: NSNotification) {
        
        if sender.name == UIKeyboardWillShowNotification {
            let keyboardHeight = sender.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size.height
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight!, 0)
        } else if sender.name == UIKeyboardWillHideNotification {
            self.tableView.contentInset = UIEdgeInsetsZero
        }
    }
    
}

extension EditViewController : UITableViewDelegate, UITableViewDataSource, FKEditPicCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
        
        if let baseCell = cell as? FKEditBaseCell {
            baseCell.delegate = self
        }
        
        if let upcCell = cell as? FKEditUpcCell{
            upcCell.addButton.addTarget(self, action: #selector(self.clickScanAction(_:)), forControlEvents: .TouchUpInside)
        }else if let picCell = cell as? FKEditPicCell {
            picCell.delegate = self
            picCell.tag = indexPath.row - 2
        }else if let deleteCell = cell as? FKEditDeleteCell {
            deleteCell.deleteBtn.addTarget(self, action: #selector(self.clickDeleteAction(_:)), forControlEvents: .TouchUpInside)
        }
        
        cell?.fk_configWith(self.viewModel, indexPath: indexPath);
        return cell!
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 3 {
            return nil
        }
        
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(EDIT_HEADER_VIEW_IDENTIFY) as? FKEditHeaderView
        
        if section == 0 {
            headerView?.titleLabel.text = "name&photo"
        } else if section == 1 {
            headerView?.titleLabel.text = "basic information"
        } else if section == 2 {
            headerView?.titleLabel.text = "commodity information"
        }
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 3 {
            return CGFloat.min
        }
        return 33.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.view.endEditing(true)
    }
    
    func clickAddImg() {
        
        weak var weakSelf = self
        let sheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let action0 = UIAlertAction.init(title: "Camera", style: .Default, handler: { (action: UIAlertAction) in
            weakSelf?.prensentImgPickWithType(.Camera)
        })
        
        let action1 = UIAlertAction.init(title: "PhotoLibray", style: .Default, handler: { (action: UIAlertAction) in
            weakSelf?.prensentImgPickWithType(.PhotoLibrary)
        })
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .Cancel, handler:nil)
        
        sheet.addAction(action0)
        sheet.addAction(action1)
        sheet.addAction(cancelAction)
        
        self.presentViewController(sheet, animated: true, completion: nil)
//        self.viewModel.proImgArray.append(UIImage.init(named: "SegmentReserveSelected")!)
//        self.tableView.reloadData()
    }
    
    func clickDeleteImg(picCell: FKEditPicCell, index: Int) {
        let imgIndex = picCell.tag * 3 + index
        if imgIndex < self.viewModel.dataItem?.picItems!.count {
            self.viewModel.dataItem?.picItems?.removeAtIndex(imgIndex)
            self.tableView.reloadData()
        }
    }
    
    func prensentImgPickWithType(type: UIImagePickerControllerSourceType) {
     
        if type == .Camera && !UIImagePickerController.isSourceTypeAvailable(type) {
            self.showCameraAuthorityAlert()
        } else {
            let imgPicker = UIImagePickerController.init()
            imgPicker.allowsEditing = true
            imgPicker.sourceType = type
            imgPicker.delegate = self
            imgPicker.modalPresentationStyle = .FullScreen
            self.presentViewController(imgPicker, animated: true, completion: nil)
        }
    }
    
    private func showCameraAuthorityAlert() {
        let alert = UIAlertController.init(title: "dsds", message: "sd", preferredStyle: .Alert)
        let action = UIAlertAction.init(title: "无法使用相机，请前往设置打开", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        var image : UIImage?
        if mediaType == kUTTypeImage as String {
            if picker.allowsEditing {
                image = info[UIImagePickerControllerEditedImage] as? UIImage
            }else{
                image = info[UIImagePickerControllerOriginalImage] as? UIImage
            }
            
            if image != nil {
                image = UIImage.scaleImage(image!, toSize: CGSizeMake(CGFloat(DSSConst.UPLOAD_PHOTO_LENGTH), CGFloat(DSSConst.UPLOAD_PHOTO_LENGTH)))
                
                let newImgItem = DSSEditImgItem()
                newImgItem.image = image
                
                if self.viewModel.dataItem?.picItems != nil {
                    self.viewModel.dataItem?.picItems!.append(newImgItem)
                }

                self.tableView.reloadData()
            }
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
}


