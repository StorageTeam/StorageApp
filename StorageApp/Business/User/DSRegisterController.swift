//
//  DSRegisterController.swift
//  StorageApp
//
//  Created by ascii on 16/9/22.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import Foundation

class DSRegisterController: DSLoginController {
    private static let DS_REGISTER_REQUEST_IDENTIFY: Int = 1
    private static let DS_REGISTER_LOGIN_REQUEST_IDENTIFY: Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.titleLabel.text = "请输入注册邮箱地址"
        self.loginBtn.setTitle("注册", forState: UIControlState.Normal)
        self.findPwdBtn.hidden = true
        self.registerTipLabel.hidden = true
        self.registerBtn.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - DSDataCenterDelegate
    
    override func networkDidResponseSuccess(identify: Int, header: DSResponseHeader, response: [String : AnyObject], userInfo: [String : AnyObject]?) {
        if header.code == DSResponseCode.Normal {
            if identify == DSRegisterController.DS_REGISTER_REQUEST_IDENTIFY {
                if let email = self.emailTextField.textField.text {
                    if let password = self.passwordTextField.textField.text {
                        DSUserService.requestLogin(DSRegisterController.DS_REGISTER_LOGIN_REQUEST_IDENTIFY,
                                                   delegate: self,
                                                   email: email,
                                                   password: password)
                    }
                }
            } else if identify == DSRegisterController.DS_REGISTER_LOGIN_REQUEST_IDENTIFY {
                DSAccount.saveAccount(response["data"]?["user"])
                self.dismissViewControllerAnimated(true, completion: {})
            }
        } else {
            super.showText(header.msg)
        }
    }
    
    override func networkDidResponseError(identify: Int, header: DSResponseHeader?, error: String?, userInfo: [String : AnyObject]?) {
        super.showText(error)
    }
    
    // MARK: - Action
    
    override func clickSubmitAction() {
        if let email = self.emailTextField.textField.text {
            if let password = self.passwordTextField.textField.text {
                DSUserService.requestRegister(DSRegisterController.DS_REGISTER_REQUEST_IDENTIFY, delegate: self, email: email, password: password)
            } else {
                self.showText("请输入注册密码")
            }
        } else {
            self.showText("请输入注册邮箱")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}
