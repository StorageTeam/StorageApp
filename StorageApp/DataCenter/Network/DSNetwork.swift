//
//  DSNetwork.swift
//  StorageApp
//
//  Created by ascii on 16/6/23.
//  Copyright © 2016年 DSB. All rights reserved.
//

import Foundation
import Alamofire

class DSNetwork: NSObject {
    static let errorMSG: String = "server data error!"
    
    class func Request(identify : Int,
                       delegate : DSDataCenterDelegate,
                       path     : String,
                       para     : [String : AnyObject]?,
                       userInfo : [String : AnyObject]?,
                       fileData : NSData? = nil,
                       server   : String  = DSServer.apiServer()) {
        
        // construct url with sever and path
        var url = NSURL.init(string: server)
        url = url?.URLByAppendingPathComponent(path)
        
        // construct parameters
        var parameters = DSRequestHeader.requestHeader()
        if let newPara = para {
            for (key, value) in newPara {
                parameters.updateValue(value, forKey: key)
            }
        }
        
        Alamofire.upload(.POST,
                         url!,
                         multipartFormData: { multipartFormData in
                            if let data = fileData {
                                let base64 = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.init(rawValue: 0))
                                if let base64Data = base64.dataUsingEncoding(NSUTF8StringEncoding) {
                                    multipartFormData.appendBodyPart(data: base64Data, name: "stream")
                                }
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
                                    } catch { }
                                }
                            }
            }, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseString { response in
                        let header = DSResponseHeader.init()
                        header.code = DSResponseCode.BusinessError
                        header.msg = DSNetwork.errorMSG
                        
                        // response
                        if let responseString = response.result.value {
                            do {
                                if let json = try NSJSONSerialization.JSONObjectWithData(responseString.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.AllowFragments) as? [String: AnyObject] {
                                    
                                    print(json, separator: "", terminator: "\r\n")
                                    
                                    if let code = json["code"] as? String {
                                        let responseCode = DSResponseCode(rawValue: Int(code)!)
                                        header.code = responseCode
                                        
                                        if responseCode == DSResponseCode.Normal || responseCode == DSResponseCode.BusinessError || responseCode == DSResponseCode.AccessError {
                                            if let msg = json["message"] as? String {
                                                header.msg = msg
                                            }
                                            delegate.networkDidResponseSuccess(identify, header: header, response: json, userInfo: userInfo)
                                            return
                                        }
//                                        else if responseCode == DSResponseCode.AccessError {
//                                            // show login page
//                                        }
                                    }
                                }
                            } catch {
                                delegate.networkDidResponseError?(identify, header: header, error: DSNetwork.errorMSG, userInfo: userInfo)
                            }
                        }
                        delegate.networkDidResponseError?(identify, header: header, error: DSNetwork.errorMSG, userInfo: userInfo)
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                    delegate.networkDidResponseError?(identify, header: nil, error: nil, userInfo: userInfo)
                }
            }
        )
        
    }
}
