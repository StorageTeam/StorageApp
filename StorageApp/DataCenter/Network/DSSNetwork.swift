//
//  DSSNetwork.swift
//  StorageApp
//
//  Created by ascii on 16/6/23.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation
import Alamofire

class DSSNetwork: NSObject {
    static let errorMSG: String = "数据解析异常"
    
    class func Request(identify: Int,
                       delegate: DSSDataCenterDelegate,
                       path         : String,
                       para         : [String : AnyObject]?,
                       userInfo     : [String : AnyObject]?,
                       fileData     : NSData? = nil,
                       name         : String = "name",
                       fileName     : String = "photo.jpeg",
                       mimeType     : String = "image/jpeg",
                       server       : String = DSSServer.apiServer()) {
        
        // construct url with sever and path
        var url = NSURL.init(string: server)
        url = url?.URLByAppendingPathComponent(path)
        
        // construct parameters
        var parameters = DSSRequestHeader.requestHeader()
        if let newPara = para {
            for (key, value) in newPara {
                parameters.updateValue(value, forKey: key)
            }
        }
        
        Alamofire.upload(.POST,
                         url!,
                         multipartFormData: { multipartFormData in
                            if let data = fileData {
                                multipartFormData.appendBodyPart(data: data, name: name, fileName: fileName, mimeType: mimeType)
                            }
                            
                            // submit with form data
                            for (key, value) in parameters {
                                if let string = value as? String {
                                    let data = string.dataUsingEncoding(NSUTF8StringEncoding)
                                    multipartFormData.appendBodyPart(data: data!, name: key)
                                } else {
                                    do {
                                        let data = try NSJSONSerialization.dataWithJSONObject(value, options: NSJSONWritingOptions.PrettyPrinted)
                                        multipartFormData.appendBodyPart(data: data, name: key)
                                    } catch {
                                    }
                                }
                            }
            }, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseString { response in
                        // response
                        let header = DSSResponseHeader.init()
                        header.code = DSSResponseCode.Normal
                        
                        if let responseString = response.result.value {
                            do {
                                if let json = try NSJSONSerialization.JSONObjectWithData(responseString.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.AllowFragments) as? [String: AnyObject] {
                                    print(json, separator: "", terminator: "\r\n")
                                    if let code = json["code"] as? String {
                                        let responseCode = DSSResponseCode(rawValue: Int(code)!)
                                        header.code = responseCode
                                        
                                        if responseCode == DSSResponseCode.Normal || responseCode == DSSResponseCode.BusinessError {
                                            if let msg = json["message"] as? String {
                                                header.msg = msg
                                            }
                                            delegate.networkDidResponseSuccess(identify, header: header, response: json, userInfo: userInfo)
                                        } else if responseCode == DSSResponseCode.AccessError {
                                            // show login page
                                        }
                                    }
                                }
                            } catch {
                            }
                        }
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
            }
        )
        
    }
}
