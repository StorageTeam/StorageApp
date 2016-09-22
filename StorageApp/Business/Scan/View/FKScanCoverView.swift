//
//  FKScanCoverView.swift
//  JackSwift
//
//  Created by jack on 16/6/28.
//  Copyright © 2016年 FirstLink. All rights reserved.
//

import UIKit

class FKScanCoverView: UIView {

    var scanRect : CGRect?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    convenience init(scanRect: CGRect) {
        self.init(frame: CGRectZero)
        self.scanRect = scanRect
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        
        let ctx = UIGraphicsGetCurrentContext()
        
        UIColor.blackColor().colorWithAlphaComponent(0.5).setFill()
        
        let screenPath = CGPathCreateMutable()
        CGPathAddRect(screenPath, nil, self.bounds)
        
        let scanPath = CGPathCreateMutable()
        CGPathAddRect(screenPath, nil, self.scanRect!)
        
        let path = CGPathCreateMutable()
        CGPathAddPath(path, nil, screenPath)
        CGPathAddPath(path, nil, scanPath)
        
        CGContextAddPath(ctx!, path)
        CGContextDrawPath(ctx!, .EOFill)
        
    }

}
