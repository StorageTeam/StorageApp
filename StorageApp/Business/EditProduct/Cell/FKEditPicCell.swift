//
//  FKEditPicCell.swift
//  JackSwift
//
//  Created by jack on 16/6/25.
//  Copyright © 2016年 FirstLink. All rights reserved.
//

import UIKit

class FKEditPicCell: UITableViewCell {
    
    var firstContainer : FKEditImgContainer = FKEditImgContainer.init(frame: CGRectZero)
    var secondContainer : FKEditImgContainer = FKEditImgContainer.init(frame: CGRectZero)
    var thirdContainer : FKEditImgContainer = FKEditImgContainer.init(frame: CGRectZero)
    
    weak var delegate: FKEditPicCellDelegate?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .None
        self.initializeSub()
        self.addAllSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeSub(){
        
        self.firstContainer.tapButton.tag = 0
        self.secondContainer.tapButton.tag = 1
        self.thirdContainer.tapButton.tag = 2
        
        self.firstContainer.deleteBtn.tag = 0
        self.secondContainer.deleteBtn.tag = 1
        self.thirdContainer.deleteBtn.tag = 2
        
        self.firstContainer.tapButton.addTarget(self, action: #selector(clickContainer), forControlEvents: .TouchUpInside)
        self.secondContainer.tapButton.addTarget(self, action: #selector(clickContainer), forControlEvents: .TouchUpInside)
        self.thirdContainer.tapButton.addTarget(self, action: #selector(clickContainer), forControlEvents: .TouchUpInside)
        
        self.firstContainer.deleteBtn.addTarget(self, action: #selector(clickDeleteBtn), forControlEvents: .TouchUpInside)
        self.secondContainer.deleteBtn.addTarget(self, action: #selector(clickDeleteBtn), forControlEvents: .TouchUpInside)
        self.thirdContainer.deleteBtn.addTarget(self, action: #selector(clickDeleteBtn), forControlEvents: .TouchUpInside)
    }
    
    func addAllSubviews() -> Void {
        
        let imgMargin = FKEditImgContainer.getImgMargin()
        let itemSpace = (UIScreen.mainScreen().bounds.size.width - CGFloat(imgMargin * 3)) / 8.0
        let itemSize = imgMargin + itemSpace * 2
        
        self.contentView.addSubview(self.firstContainer)
        self.contentView.addSubview(self.secondContainer)
        self.contentView.addSubview(self.thirdContainer)
        
        self.firstContainer.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(itemSpace)
            make.centerY.equalTo(self.contentView)
            make.width.equalTo(itemSize)
            make.height.equalTo(self.contentView)
//            make.size.equalTo(CGSizeMake(itemSize, itemSize))
        }
        
        self.secondContainer.snp_makeConstraints { (make) in
            make.left.equalTo(self.firstContainer.snp_right)
            make.centerY.equalTo(self.contentView)
            make.width.equalTo(itemSize)
            make.height.equalTo(self.contentView)
//            make.size.equalTo(CGSizeMake(itemSize, itemSize))
        }
        
        self.thirdContainer.snp_makeConstraints { (make) in
            make.left.equalTo(self.secondContainer.snp_right)
            make.centerY.equalTo(self.contentView)
            make.width.equalTo(itemSize)
            make.height.equalTo(self.contentView)
//            make.size.equalTo(CGSizeMake(itemSize, itemSize))
        }

    }
    
    func setContentImgs(imgs: [DSSEditImgItem]?, canEdit: Bool){
        
        self.clearContent()
        
        if imgs == nil {
            
            if canEdit {
                self.firstContainer.hidden = false
                self.firstContainer.tapButton.userInteractionEnabled = true
            }
            return
        }
        
        let imageCount = imgs!.count
        var containerArray = [self.firstContainer, self.secondContainer, self.thirdContainer]
        
        for imageItem in imgs! {
            let index = imgs!.indexOf(imageItem)
            if index <= 2 {
                let container = containerArray[index!]
                container.hidden = false
                container.setProductImg(imageItem, canEdit: canEdit)
            }
        }
        
        if imageCount <= 2 {
            let emptContainer = containerArray[imageCount]
            emptContainer.hidden = false
            emptContainer.tapButton.userInteractionEnabled = true
        }
        
    }
    
    override func fk_configWith(viewModel: AnyObject, indexPath: NSIndexPath) {
        if let editModel = viewModel as? EditViewModel {
            
            let imageArray = editModel.getPicImgsAtIndexPath(indexPath)
            
            var canEdit = true
            if editModel.editType == kEditType.kEditTypeCheck {
                canEdit = false
            }
            self.setContentImgs(imageArray, canEdit: canEdit)
            
            
        }
    }
    
    func clearContent() {
        
        self.firstContainer.setProductImg(nil, canEdit: false)
        self.secondContainer.setProductImg(nil, canEdit: false)
        self.thirdContainer.setProductImg(nil, canEdit: false)
        
        self.firstContainer.tapButton.userInteractionEnabled = false
        self.secondContainer.tapButton.userInteractionEnabled = false
        self.thirdContainer.tapButton.userInteractionEnabled = false
        
        self.firstContainer.hidden = true
        self.secondContainer.hidden = true
        self.thirdContainer.hidden = true
    }
    
    func clickContainer(sender: UIButton){
        if self.delegate != nil && self.delegate!.respondsToSelector(#selector(FKEditPicCellDelegate.clickAddImg)){
            self.delegate!.clickAddImg!()
        }
    }
    
    func clickDeleteBtn(sender: UIButton){
        if self.delegate != nil && self.delegate!.respondsToSelector(#selector(FKEditPicCellDelegate.clickDeleteImg(_:index:))){
            self.delegate!.clickDeleteImg(self, index: sender.tag)
        }
    }
}

@objc protocol FKEditPicCellDelegate: NSObjectProtocol {
    
    optional
    func clickAddImg()
    func clickDeleteImg(picCell: FKEditPicCell, index: Int)
}
