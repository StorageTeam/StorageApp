//
//  DSSCommonDefine.swift
//  StorageApp
//
//  Created by ascii on 16/6/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation
import UIKit

class DSConst: NSObject {
    // const
    static let PageSize            = "200"
    static let UPLOAD_PHOTO_LENGTH = 320.0
    static let pixelHeight         = 1.0/UIScreen.mainScreen().scale
    static let UISCREENWIDTH       = UIScreen.mainScreen().bounds.size.width
    static let UISCREENHEIGHT       = UIScreen.mainScreen().bounds.size.height
    
    class func IS_Screen_320() -> Bool {
        return Double(fabs((UIScreen.mainScreen().bounds.size.width - 320.0))) < DBL_EPSILON
    }
    
    class func IS_iPhone4() -> Bool {
        return Double(fabs((UIScreen.mainScreen().bounds.size.height - 480.0))) < DBL_EPSILON
    }
    
    class func IS_iPhone6() -> Bool {
        return Double(fabs((UIScreen.mainScreen().bounds.size.width - 375.0))) < DBL_EPSILON
    }
    
    class func IS_iPhone6P() -> Bool {
        return Double(fabs((UIScreen.mainScreen().bounds.size.width - 736.0))) < DBL_EPSILON
    }
}
