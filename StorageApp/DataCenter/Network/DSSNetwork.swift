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
    
    static func Request(identify: Int
        , delegate: DSSDataCenterDelegate
        , path: String
        , para: [String : AnyObject]?
        , userInfo: [String : AnyObject]?
        , server: String = DSSServer.apiServer()) {
        
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
        
        Alamofire.request(.POST, url!, parameters: parameters)
            .validate()
            .responseData { response in
                let header = DSSResponseHeader.init()
                header.code = DSSResponseCode.Normal
                
                switch response.result {
                case .Success:
                    do {
                        let responseJSON = try NSJSONSerialization.JSONObjectWithData(response.data!, options: []) as! [String: AnyObject]
                        if let code = responseJSON["code"] as? DSSResponseCode {
                            header.code = code
                            
                            if code == DSSResponseCode.BusinessError || code == DSSResponseCode.BusinessError {
                                if let msg = responseJSON["message"] as? String {
                                    header.msg = msg
                                }
                                delegate.networkDidResponseSuccess(identify, header: header, response: responseJSON, userInfo: userInfo)
                            } else if code == DSSResponseCode.AccessError {
                                // show login page
                            }
                        }
                    } catch {
                        header.msg = DSSNetwork.errorMSG
                        delegate.networkDidResponseError?(identify, header: header, error: DSSNetwork.errorMSG, userInfo: userInfo)
                    }
                case .Failure(let error):
                    header.msg = DSSNetwork.errorMSG
                    delegate.networkDidResponseError?(identify, header: header, error: error.localizedDescription, userInfo: userInfo)
                }
        }
    }
}
