//
//  UIColor+Extension.swift
//  StorageApp
//
//  Created by jack on 16/6/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

extension UIColor {
 
    public class func colorFromHexStr(HexStr: String) -> UIColor{
        var colorStr = HexStr.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).uppercaseString
        
        if colorStr.hasPrefix("#"){
            colorStr = (colorStr as NSString).substringFromIndex(1)
        }
        
        if colorStr.characters.count != 6 {
            return UIColor.blackColor()
        }
        
        let rStr = (colorStr as NSString).substringFromIndex(2)
        let gStr = (colorStr as NSString).substringWithRange(NSMakeRange(2, 2))
        let bStr = (colorStr as NSString).substringWithRange(NSMakeRange(4, 2))
        
        var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0
        
        NSScanner.init(string: rStr).scanHexInt(&r)
        NSScanner.init(string: gStr).scanHexInt(&g)
        NSScanner.init(string: bStr).scanHexInt(&b)
     
        return UIColor.init(red: CGFloat.init(r) / 255.0, green: CGFloat.init(g) / 255.0, blue: CGFloat.init(b) / 255.0, alpha: 1.0)
    }
}