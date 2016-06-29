//
//  UIImage+Extension.swift
//  StorageApp
//
//  Created by jack on 16/6/29.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

extension UIImage{
    
    class func scaleImage(image: UIImage, toSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContext(toSize)
        image.drawInRect(CGRectMake(0, 0, toSize.width, toSize.height))
        let scaleImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaleImg
    }
}