//
//  DSSIntExtension.swift
//  StorageApp
//
//  Created by ascii on 16/6/29.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    func dss_fen2Yuan(precision: Int = 2) -> String {
        let yuan = CGFloat(self)/100.0
        return String.init(format: "%.\(precision)f", yuan)
    }
}
