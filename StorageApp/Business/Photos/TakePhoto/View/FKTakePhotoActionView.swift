//
//  JSTakePhotoActionView.swift
//  StorageApp
//
//  Created by jack on 16/7/26.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class FKCircleBgView: UIView {
    
    private let fixedMargin = CGFloat(68.0)
    
    override init(frame: CGRect) {
        super.init(frame: CGRectMake(frame.origin.x, frame.origin.y, self.fixedMargin, self.fixedMargin))
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(self.fixedMargin, self.fixedMargin)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextAddEllipseInRect(context!, rect)
        
        UIColor.whiteColor().setFill()
        CGContextFillPath(context!)
        
        let r = CGFloat(6.0)
        let smallRect = CGRectMake(rect.origin.x + r, rect.origin.y + r, rect.size.width - 2 * r, rect.size.height - 2 * r)
        UIColor.blackColor().setStroke()
        CGContextSetLineWidth(context!, 2)
        CGContextStrokeEllipseInRect(context!, smallRect)
    }
}

class FKTakePhotoActionView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addAllSubviews()
        self.backgroundColor = UIColor.blackColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addAllSubviews() {
        self.addSubview(self.doneBtnBgView)
        self.addSubview(self.takePhotoBtn)
        self.addSubview(self.cancelBtn)
        self.addSubview(self.finishBtn)
        
        self.doneBtnBgView.snp_makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
        self.takePhotoBtn.snp_makeConstraints { (make) in
            make.center.equalTo(self)
            make.top.bottom.equalTo(self)
            make.width.equalTo(self.doneBtnBgView).offset(30)
        }
        
        self.cancelBtn.snp_makeConstraints { (make) in
            make.left.centerY.equalTo(self)
        }
        
        self.finishBtn.snp_makeConstraints { (make) in
            make.right.centerY.equalTo(self)
        }
    }
    
    private lazy var doneBtnBgView: FKCircleBgView = {
        let view = FKCircleBgView.init()
        return view
    }()
    
    lazy var takePhotoBtn: UIButton = {
        let button = UIButton.init(type: UIButtonType.Custom)
        return button
    }()
    
    lazy var cancelBtn: UIButton = {
        let button = UIButton.init(type: UIButtonType.Custom)
        button.setTitle("取消", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(18)
        button.contentEdgeInsets = UIEdgeInsetsMake(30, 20, 30, 20)
        return button
    }()
    
    lazy var finishBtn: UIButton = {
        let button = UIButton.init(type: UIButtonType.Custom)
        button.setTitle("完成", forState: .Normal)
        button.setTitleColor(UIColor.init(rgb: 0x1fbad6), forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(18)
        button.contentEdgeInsets = UIEdgeInsetsMake(30, 20, 30, 20)
        return button
    }()
    
    
}
