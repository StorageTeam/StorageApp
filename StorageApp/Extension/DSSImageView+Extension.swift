//
//  DSSImageViewExtension.swift
//  StorageApp
//
//  Created by ascii on 16/6/29.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import Foundation
import Haneke

extension UIImageView {
    func dss_setImageFromURLString(urlString: String, cdnWidth: Int) -> Void {
        self.hnk_setImageFromURL(NSURL.init(string: urlString.dss_cdn(cdnWidth))!,
                                 placeholder: nil,
                                 format: Format<UIImage>(name: "original"),
                                 failure: nil,
                                 success: nil)
    }
    
    func dss_setImage(urlString: String, placeholder: UIImage?) -> Void {
        if let url = NSURL.init(string: urlString) {
            self.hnk_setImageFromURL(url,
                                     placeholder: placeholder,
                                     format: Format<UIImage>(name: "original"),
                                     failure: nil,
                                     success: nil);
        }
    }
}
