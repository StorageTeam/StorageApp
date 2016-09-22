//
//  DSSView+Extension.swift
//  StorageApp
//
//  Created by ascii on 16/7/1.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

extension UIView {
    private struct AssociatedKeys {
        static var DescribeName = "dss_DescriptiveName"
    }
    
    var describeName: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.DescribeName) as? String
        }
        
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.DescribeName,
                    newValue as NSString?,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
}
