//
//  DSALoginController.swift
//  StorageApp
//
//  Created by ascii on 16/6/23.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import Foundation

class DSLoginController: DSBaseViewController, UITextFieldDelegate, DSDataCenterDelegate {
    static let DS_LOGIN_REQUEST_IDENTIFY: Int = 0
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.whiteColor()
        #if DEBUG
//            self.emailTextField.textField.text      = "18956396627"
//            self.passwordTextField.textField.text   = "duoshoubang2016"
            self.emailTextField.textField.text      = "10897654@qq.com"
            self.passwordTextField.textField.text   = "duoshoubang2016"
        #endif
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - DSDataCenterDelegate
    func networkDidResponseSuccess(identify: Int, header: DSResponseHeader, response: [String : AnyObject], userInfo: [String : AnyObject]?) {
        if header.code == DSResponseCode.Normal {
            DSAccount.saveAccount(response["data"]?["user"])
            self.dismissViewControllerAnimated(true, completion: {})
        } else {
            super.showText(header.msg)
        }
    }
    
    func networkDidResponseError(identify: Int, header: DSResponseHeader?, error: String?, userInfo: [String : AnyObject]?) {
        super.showText(error)
    }
    
    // MARK: - UITextFieldDelegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if "\n" == string {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    // MARK: - Actions
    @objc func clickSubmitAction() {
        let email = self.emailTextField.textField.text
        let password = self.passwordTextField.textField.text
        
        if email?.characters.count > 0 && password?.characters.count > 0 {
            DSUserService.requestLogin(DSLoginController.DS_LOGIN_REQUEST_IDENTIFY,
                                         delegate: self,
                                            email: email!,
                                         password: password!)
        } else {
            self.showText("邮箱或密码错误")
        }
    }
    
    @objc private func clickFindPwdAction() {
        let controller = DSFindPwdController.init()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc private func clickRegisterAction() {
        var controllers = self.navigationController?.viewControllers
        if controllers?.count >= 2 {
            controllers?.removeLast()
            controllers?.append(DSRegisterController.init())
            self.navigationController?.setViewControllers(controllers!, animated: true)
        }
    }
    
    // MARK: - loadView
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(self.popBackBtn)
        self.popBackBtn.snp_makeConstraints { (make) in
            make.top.equalTo(self.view).offset(20)
            make.left.equalTo(self.view).offset(12)
            make.size.equalTo(CGSizeMake(44, 44))
        }
        
        self.view.addSubview(self.titleLabel)
        self.titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.view).offset(100)
            make.centerX.equalTo(self.view)
        }
        
        self.view.addSubview(self.emailTextField)
        self.emailTextField.snp_makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp_bottom).offset(72)
            make.left.equalTo(self.view).offset(28)
            make.right.equalTo(self.view).offset(-28)
            make.height.equalTo(32)
        }
        
        self.view.addSubview(self.passwordTextField)
        self.passwordTextField.snp_makeConstraints { (make) in
            make.top.equalTo(self.emailTextField.snp_bottom).offset(16)
            make.left.equalTo(self.view).offset(28)
            make.right.equalTo(self.view).offset(-28)
            make.height.equalTo(32)
        }
        
        self.view.addSubview(self.loginBtn)
        self.loginBtn.snp_makeConstraints { (make) in
            make.top.equalTo(self.passwordTextField.snp_bottom).offset(40)
            make.left.right.equalTo(self.passwordTextField)
            make.height.equalTo(45)
        }
        
        self.view.addSubview(self.findPwdBtn)
        self.findPwdBtn.snp_makeConstraints { (make) in
            make.top.equalTo(self.loginBtn.snp_bottom)
            make.centerX.equalTo(self.view)
            make.size.equalTo(CGSizeMake(80, 44))
        }
        
        self.view.addSubview(self.registerTipLabel)
        self.registerTipLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.view).offset(-36)
            make.centerX.equalTo(self.view).offset(-14)
        }
        
        self.view.addSubview(self.registerBtn)
        self.registerBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.registerTipLabel)
            make.left.equalTo(self.registerTipLabel.snp_right).offset(-3)
            make.size.equalTo(CGSizeMake(44, 44))
        }
    }
    
    // MARK: - Property
    
    lazy var popBackBtn: UIButton = {
        let button = UIButton(type: UIButtonType.Custom)
        button.setTitle("取消", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.init(rgb: 0x1fbad6), forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        button.addTarget(self, action: #selector(self.clickDefaultLeftBar), forControlEvents: .TouchUpInside)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.text = "请输入登录邮箱地址"
        label.textColor = UIColor.init(rgb: 0x333333)
        label.font = UIFont.systemFontOfSize(28)
        label.textAlignment = .Center
        return label
    }()
    
    lazy var emailTextField: DSUserTextField = {
        let emailTextField = DSUserTextField(title: "邮箱", placeholder: "请输入邮箱地址", secure: false)
        emailTextField.textField.delegate = self;
        emailTextField.textField.returnKeyType = .Done
        emailTextField.textField.keyboardType = .NumbersAndPunctuation
        return emailTextField
    }()
    
    lazy var passwordTextField: DSUserTextField = {
        let passwordTextField = DSUserTextField(title: "密码", placeholder: "密码为6-16位且包含数字和字母组合", secure: true)
        passwordTextField.textField.delegate = self;
        passwordTextField.textField.returnKeyType = .Done
        passwordTextField.textField.keyboardType = .NumbersAndPunctuation
        return passwordTextField
    }()

    lazy var loginBtn: UIButton = {
        let button = UIButton(type: UIButtonType.Custom)
        button.layer.cornerRadius = 4
        button.setTitle("登录", forState: UIControlState.Normal)
        button.backgroundColor = UIColor.init(rgb: 0x1fbad6)
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        button.addTarget(self, action: #selector(self.clickSubmitAction), forControlEvents: .TouchUpInside)
        return button
    }()
    
    lazy var findPwdBtn: UIButton = {
        let button = UIButton(type: UIButtonType.Custom)
        button.setTitle("忘记密码?", forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(14)
        button.setTitleColor(UIColor.init(rgb: 0x666666), forState: .Normal)
        button.addTarget(self, action: #selector(self.clickFindPwdAction), forControlEvents: .TouchUpInside)
        return button
    }()
    
    lazy var registerTipLabel: UILabel = {
        let label = UILabel.init()
        label.text = "还没有扫一扫账号，点此去"
        label.textColor = UIColor.init(rgb: 0x333333)
        label.font = UIFont.systemFontOfSize(14)
        label.textAlignment = .Center
        return label
    }()
    
    lazy var registerBtn: UIButton = {
        let button = UIButton(type: UIButtonType.Custom)
        button.setTitle("注册>", forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(14)
        button.setTitleColor(UIColor.init(rgb: 0x1fbad6), forState: .Normal)
        button.addTarget(self, action: #selector(self.clickRegisterAction), forControlEvents: .TouchUpInside)
        return button
    }()
}
