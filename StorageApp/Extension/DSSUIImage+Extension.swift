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
        return scaleImg!
    }
    
//    func cutFromCenterTo(targetSize: CGSize) -> UIImage {
//        
//        let realHeight = self.size.width * targetSize.height / targetSize.width
//        let cutMargin = self.size.height - realHeight
//        
//        guard cutMargin > 0 else {
//            return self
//        }
//        
//        let targetRect = CGRectMake(cutMargin / 2.0, 0, self.size.width, realHeight)
//        let imageRef = self.CGImage
//        let partRef = CGImageCreateWithImageInRect(imageRef, targetRect)
//        
//        guard partRef != nil else {
//            return self
//        }
//        
//        let resImg = UIImage.init(CGImage: partRef!, scale: self.scale, orientation: self.imageOrientation)
//        return resImg
//    }
    
    func dss_thumImageFromCenter(dstSize: CGSize) -> UIImage {
        let scale  = max(dstSize.width/self.size.width, dstSize.height/self.size.height)
        let width  = self.size.width * scale
        let height = self.size.height * scale
        let imageRect = CGRectMake((dstSize.width - width)/2.0,
                                   (dstSize.height - height)/2.0,
                                   width,
                                   height)
        
        UIGraphicsBeginImageContextWithOptions(dstSize, false, 0)
        self.drawInRect(imageRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage!
    }
}
