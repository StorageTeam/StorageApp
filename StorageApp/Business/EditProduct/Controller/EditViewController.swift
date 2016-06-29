//
//  EditViewController.swift
//  JackSwift
//
//  Created by jack on 16/6/23.
//  Copyright © 2016年 FirstLink. All rights reserved.
//

import UIKit
import MobileCoreServices

class EditViewController: UIViewController{

    private var tableView : UITableView! = nil
    private var viewModel : EditViewModel = EditViewModel()
    
    
    override func viewDidLoad() {
        self.buildTableView()
        self.addAllSubviews()
    }
    
    func addAllSubviews() -> Void {
        self.view.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsZero)
        }
        
//        self.viewModel.proImgArray.append(UIImage.init(named: "upc_add")!)
//        self.viewModel.proImgArray.append(UIImage.init(named: "Clear")!)
//        self.viewModel.proImgArray.append(UIImage.init(named: "edit_rightArrow")!)
//        self.viewModel.proImgArray.append(UIImage.init(named: "test")!)
//        
//        self.viewModel.proImgArray.append(UIImage.init(named: "SegmentOnsaleNormal")!)
//        self.viewModel.proImgArray.append(UIImage.init(named: "SegmentOnsaleSelected")!)
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
//        self.tableView.registerClass(FKSexChooseCell.self, forCellReuseIdentifier: SEX_CELL_IDENTIFY)
        self.tableView.registerClass(FKEditDescCell.self, forCellReuseIdentifier: DESC_CELL_IDENTIFY)
        self.tableView.registerClass(FKEditUpcCell.self, forCellReuseIdentifier: UPC_CELL_IDENTIFY)
        self.tableView.registerClass(FKEditHeaderView.self, forHeaderFooterViewReuseIdentifier: EDIT_HEADER_VIEW_IDENTIFY)
    }
    
    func setUpcWithString(string: String){
        
    }
    
    func clickScanAction(sender: UIButton){
        
        weak var weakself = self
        let scanController = FKScanController.init { (resStr) -> Void in
            print("scan res string = \(resStr)")
            weakself?.viewModel.currentUpcStr = resStr
            weakself?.tableView.reloadData()
        }
        self.navigationController?.pushViewController(scanController, animated: true)
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
        
        if let upcCell = cell as? FKEditUpcCell{
            upcCell.addButton.addTarget(self, action: #selector(self.clickScanAction(_:)), forControlEvents: .TouchUpInside)
        }else if let picCell = cell as? FKEditPicCell {
            picCell.delegate = self
            picCell.tag = indexPath.row - 2
        }
        
        cell?.fk_configWith(self.viewModel, indexPath: indexPath);
        return cell!
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
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
        return 33.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.view.endEditing(true)
        
//        let cellType = self.viewModel.cellTypeForIndexPath(indexPath)
//        if cellType == .kEditCellTypeGroup {
//            
//            weak var weakSelf = self
//            let sheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .ActionSheet)
//            
//            let action0 = UIAlertAction.init(title: "Neuter", style: .Default, handler: { (action: UIAlertAction) in
//                weakSelf?.viewModel.groupType = .kGroupTypeNeuter
//                weakSelf?.tableView.reloadData()
//            })
//            
//            let action1 = UIAlertAction.init(title: "Male", style: .Default, handler: { (action: UIAlertAction) in
//                weakSelf?.viewModel.groupType = .kGroupTypeMale
//                weakSelf?.tableView.reloadData()
//            })
//            
//            let action2 = UIAlertAction.init(title: "Female", style: .Default, handler: { (action: UIAlertAction) in
//                weakSelf?.viewModel.groupType = .kGroupTypeFemale
//                weakSelf?.tableView.reloadData()
//            })
//            
//            let cancelAction = UIAlertAction.init(title: "Cancel", style: .Cancel, handler:nil)
//            
//            sheet.addAction(action0)
//            sheet.addAction(action1)
//            sheet.addAction(action2)
//            sheet.addAction(cancelAction)
//            
//            self.presentViewController(sheet, animated: true, completion: nil)
//        }
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
        if imgIndex < self.viewModel.proImgArray.count {
            self.viewModel.proImgArray.removeAtIndex(imgIndex)
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
                self.viewModel.proImgArray.append(image!)
                self.tableView.reloadData()
            }
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
}


