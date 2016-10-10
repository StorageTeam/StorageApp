//
//  ZBarSymbolSet+Extension.swift
//  StorageApp
//
//  Created by ascii on 2016/10/10.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import Foundation
import ZBarSDK

extension ZBarSymbolSet: SequenceType {
    public func generate() -> NSFastGenerator {
        return NSFastGenerator(self)
    }
}

