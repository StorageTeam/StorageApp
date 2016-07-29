//
//  DSSEditImgItem.swift
//  StorageApp
//
//  Created by jack on 16/6/29.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import ObjectMapper

class DSSEditImgItem: NSObject, Mappable {

    var picUrl          : String?
    var image           : UIImage?
    
    override init() {
        super.init()
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        picUrl              <- map["pic_url"]
    }
}
