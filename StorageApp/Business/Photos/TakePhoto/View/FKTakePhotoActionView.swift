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
        CGContextAddEllipseInRect(context, rect)
        
        UIColor.whiteColor().setFill()
        CGContextFillPath(context)
    }
}

class FKTakePhotoActionView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addAllSubviews() {
        self.addSubview(self.doneBtnBgView)
        self.doneBtnBgView.snp_makeConstraints { (make) in
            make.center.equalTo(self)
        }
    }
    
    lazy var doneBtnBgView: FKCircleBgView = {
        let view = FKCircleBgView.init()
        view.backgroundColor = UIColor.redColor()
        return view
    }()
    
    
}
