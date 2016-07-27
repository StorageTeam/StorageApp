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
    
    func cutFromCenterTo(targetSize: CGSize) -> UIImage {
        
        let realHeight = self.size.width * targetSize.height / targetSize.width
        let cutMargin = self.size.height - realHeight
        print("self.size = \(self.size), realH = \(realHeight), targetSize = \(targetSize)")
        guard cutMargin > 0 else {
            print("can not cut")
            return self
        }
        
        let targetRect = CGRectMake(cutMargin / 2.0, 0, self.size.width, realHeight)
        let imageRef = self.CGImage
        let partRef = CGImageCreateWithImageInRect(imageRef, targetRect)
        
        guard partRef != nil else {
            return self
        }
        
        let resImg = UIImage.init(CGImage: partRef!, scale: self.scale, orientation: self.imageOrientation)
        return resImg
    }
}