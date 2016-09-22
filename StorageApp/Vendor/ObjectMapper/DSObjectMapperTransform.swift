//
//  DSSObjectMapperTransform.swift
//  StorageApp
//
//  Created by ascii on 16/6/29.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation
import ObjectMapper

public class DSStringTransform: TransformType {
    public typealias Object = String
    public typealias JSON = Double
    
    public init() {}
    
    public func transformFromJSON(value: AnyObject?) -> String? {
        if let v = value as? Int {
            return String(format:"%d", v)
        }
        
        if let v = value as? CGFloat {
            return String(format:"%.2f", v)
        }
        
        if let v = value as? String {
            return v
        }
        
        return nil
    }
    
    public func transformToJSON(value: String?) -> Double? {
        if let s = value {
            return Double(s)
        }
        return nil
    }
}
