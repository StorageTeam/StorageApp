//
//  DSSImage.swift
//  StorageApp
//
//  Created by ascii on 16/7/27.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation
import UIKit

class DSImage: NSObject {
    class func dss_bgImage(size: CGSize) -> UIImage {
        return UIImage.init(named: "dssBgIcon")!.dss_thumImageFromCenter(size)
    }
}
