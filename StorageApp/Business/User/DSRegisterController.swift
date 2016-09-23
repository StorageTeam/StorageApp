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
    
    override func clickLoginAction() {
        
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
