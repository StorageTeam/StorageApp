//
//  DSSStringExtension.swift
//  StorageApp
//
//  Created by ascii on 16/6/29.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import Foundation

extension String {
    func dss_cdn(width: Int) -> String {
        if self.rangeOfString("cdn.firstlinkapp.com") != nil {
            return (self + String.init(format: "@%dw_90Q_1l_%dx", width, Int(UIScreen.mainScreen().scale)))
        }
        return self
    }
}
