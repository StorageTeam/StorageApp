//
//  FKEditPicCell.swift
//  JackSwift
//
//  Created by jack on 16/6/25.
//  Copyright © 2016年 FirstLink. All rights reserved.
//

import UIKit

class FKEditPicCell: UITableViewCell {
    
    weak var delegate: FKEditPicCellDelegate?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .None
        self.addAllSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    func addAllSubviews() -> Void {
        
        let imgMargin = FKEditImgContainer.getImgMargin()
        let itemSpace = (UIScreen.mainScreen().bounds.size.width - CGFloat(imgMargin * 3)) / 4.0
        let itemSize = imgMargin + itemSpace
        
        self.contentView.addSubview(self.firstContainer)
        self.contentView.addSubview(self.secondContainer)
        self.contentView.addSubview(self.thirdContainer)
        
        self.firstContainer.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(itemSpace)
            make.centerY.equalTo(self.contentView)
            make.width.equalTo(itemSize)
            make.height.equalTo(self.contentView)
        }
        
        self.secondContainer.snp_makeConstraints { (make) in
            make.left.equalTo(self.firstContainer.snp_right)
            make.centerY.equalTo(self.contentView)
            make.width.equalTo(itemSize)
            make.height.equalTo(self.contentView)
        }
        
        self.thirdContainer.snp_makeConstraints { (make) in
            make.left.equalTo(self.secondContainer.snp_right)
            make.centerY.equalTo(self.contentView)
            make.width.equalTo(itemSize)
            make.height.equalTo(self.contentView)
        }

    }
    
    func setContentImgs(imgs: [DSSEditImgItem]?, canEdit: Bool, firstLine: Bool){
        
        self.clearContent()
        
        if imgs == nil {
            
            if canEdit {
                self.firstContainer.hidden = false
                self.firstContainer.tapButton.userInteractionEnabled = true
                if (firstLine) {
                    self.firstContainer.titleLabel.text = "添加主图片"
                }
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
        
        if imageCount <= 2 && canEdit{
            let emptContainer = containerArray[imageCount]
            emptContainer.hidden = false
            emptContainer.tapButton.userInteractionEnabled = true
        }
        
    }
    
    override func fk_configWith(viewModel: AnyObject, indexPath: NSIndexPath) {
        if let editModel = viewModel as? EditViewModel {
            
            let imageArray = editModel.getPicImgsAtIndexPath(indexPath)
            let isFirstLine = (indexPath.row == 0) ? true : false
            
            var canEdit = true
            if editModel.editType == kEditType.kEditTypeCheck {
                canEdit = false
            }
            self.setContentImgs(imageArray, canEdit: canEdit, firstLine: isFirstLine)
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
        
        self.firstContainer.titleLabel.text = "继续添加"
        self.secondContainer.titleLabel.text = "继续添加"
        self.thirdContainer.titleLabel.text = "继续添加"
    }
    
    func clickContainer(sender: UIButton){
        if self.delegate != nil && self.delegate!.respondsToSelector(#selector(FKEditPicCellDelegate.clickAddImg)){
            self.delegate!.clickAddImg!(self)
        }
    }
    
    func clickDeleteBtn(sender: UIButton){
        if self.delegate != nil && self.delegate!.respondsToSelector(#selector(FKEditPicCellDelegate.clickDeleteImg(_:index:))){
            self.delegate!.clickDeleteImg(self, index: sender.tag)
        }
    }
    
    // MARK: property
    lazy var firstContainer: FKEditImgContainer = {
        let fist = FKEditImgContainer.init(frame: CGRectZero)
        fist.tapButton.tag = 0
        fist.deleteBtn.tag = 0
        fist.tapButton.addTarget(self, action: #selector(clickContainer), forControlEvents: .TouchUpInside)
        fist.deleteBtn.addTarget(self, action: #selector(clickDeleteBtn), forControlEvents: .TouchUpInside)
        return fist
    }()
    
    lazy var secondContainer: FKEditImgContainer = {
        let second = FKEditImgContainer.init(frame: CGRectZero)
        second.tapButton.tag = 1
        second.deleteBtn.tag = 1
        second.tapButton.addTarget(self, action: #selector(clickContainer), forControlEvents: .TouchUpInside)
        second.deleteBtn.addTarget(self, action: #selector(clickDeleteBtn), forControlEvents: .TouchUpInside)
        return second
    }()
    
    lazy var thirdContainer: FKEditImgContainer = {
        let third = FKEditImgContainer.init(frame: CGRectZero)
        third.tapButton.tag = 2
        third.deleteBtn.tag = 2
        third.tapButton.addTarget(self, action: #selector(clickContainer), forControlEvents: .TouchUpInside)
        third.deleteBtn.addTarget(self, action: #selector(clickDeleteBtn), forControlEvents: .TouchUpInside)
        return third
    }()
}

@objc protocol FKEditPicCellDelegate: NSObjectProtocol {
    
    optional
    func clickAddImg(picCell: FKEditPicCell)
    func clickDeleteImg(picCell: FKEditPicCell, index: Int)
}
