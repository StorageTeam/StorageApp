//
//  DSALoginController.swift
//  StorageApp
//
//  Created by ascii on 16/6/23.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import Foundation

class DSSLoginController: DSSBaseViewController, UITextFieldDelegate, DSSDataCenterDelegate {
    static let DSS_LOGIN_REQUEST_IDENTIFY: Int = 0
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        #if DEBUG
            self.mobileInputView.textField.text     = "18956396627"
            self.passwordInputView.textField.text   = "111111"
        #endif
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - DSSDataCenterDelegate
    func networkDidResponseSuccess(identify: Int, header: DSSResponseHeader, response: [String : AnyObject], userInfo: [String : AnyObject]?) {
        if header.code == DSSResponseCode.Normal {
            DSSAccount.saveAccount(response["data"]?["user"])
            self.dismissViewControllerAnimated(true, completion: {})
        } else {
            super.showText(header.msg)
        }
    }
    
    func networkDidResponseError(identify: Int, header: DSSResponseHeader?, error: String?, userInfo: [String : AnyObject]?) {
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
    @objc private func clickLoginAction() {
//        DSSLoginService.requestLogin(DSSLoginController.DSS_LOGIN_REQUEST_IDENTIFY,
//                                     delegate: self,
//                                     mobile: "18656396627",
//                                     password: "111111")
        
        let mobile      = self.mobileInputView.textField.text
        let password    = self.passwordInputView.textField.text
        
        if mobile?.characters.count > 0 && password?.characters.count > 0 {
            DSSLoginService.requestLogin(DSSLoginController.DSS_LOGIN_REQUEST_IDENTIFY,
                                         delegate: self,
                                         mobile: mobile!,
                                         password: password!)
        } else {
            self.showText("please enter phone number and password")
        }
    }
    
    // MARK: - loadView
    override func loadView() {
        super.loadView()
        
        var offset = (DSSConst.IS_iPhone4() ? 40 : 80)
        let width:CGFloat = (DSSConst.IS_iPhone4() ? CGFloat(260) : CGFloat(276))
        
        self.view.addSubview(self.bgImgView)
        self.bgImgView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        self.view.addSubview(self.logoImgView)
        self.logoImgView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view).offset(offset)
            make.centerX.equalTo(self.view)
            make.size.equalTo(CGSizeMake(60, 50))
        }
        
        self.view.addSubview(self.textLogoImgView)
        self.textLogoImgView.snp_makeConstraints { (make) in
            make.top.equalTo(self.logoImgView.snp_bottom).offset(10)
            make.centerX.equalTo(self.view)
        }
        
        offset = (DSSConst.IS_iPhone4() ? 20 : 40)
        self.view.addSubview(self.mobileInputView)
        self.mobileInputView.snp_makeConstraints { (make) in
            make.top.equalTo(self.textLogoImgView.snp_bottom).offset(offset)
            make.centerX.equalTo(self.view)
            make.size.equalTo(CGSizeMake(width, 42))
        }
        
        offset = (DSSConst.IS_iPhone4() ? 8 : 16)
        self.view.addSubview(self.passwordInputView)
        self.passwordInputView.snp_makeConstraints { (make) in
            make.top.equalTo(self.mobileInputView.snp_bottom).offset(offset)
            make.centerX.equalTo(self.view)
            make.size.equalTo(CGSizeMake(width, 42))
        }
        
        offset = (DSSConst.IS_iPhone4() ? 20 : 40)
        self.view.addSubview(self.loginBtn)
        self.loginBtn.snp_makeConstraints { (make) in
            make.top.equalTo(self.passwordInputView.snp_bottom).offset(offset)
            make.centerX.equalTo(self.view)
            make.size.equalTo(CGSizeMake(width, 44))
        }
    }
    
    // MARK: - Property
    
    lazy var bgImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = DSSImage.dss_bgImage()
        return imgView
    }()
    
    lazy var logoImgView: UIImageView = {
        let logoImgView = UIImageView()
        logoImgView.image = UIImage.init(named: "logo")
        return logoImgView
    }()
    
    lazy var textLogoImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "textLogo")
        return imgView
    }()
    
    lazy var mobileInputView: DSSLoginTextInput = {
        let mobileInputView = DSSLoginTextInput(iconName: "MobileInputLogo", placeholder: "Phone number", secure: false)
        mobileInputView.textField.delegate = self;
        mobileInputView.textField.returnKeyType = .Done
        mobileInputView.textField.keyboardType = .NumbersAndPunctuation
        return mobileInputView
    }()
    
    lazy var passwordInputView: DSSLoginTextInput = {
        let passwordInputView = DSSLoginTextInput(iconName: "PasswordInputLogo", placeholder: "Password", secure: true)
        passwordInputView.textField.delegate = self;
        passwordInputView.textField.returnKeyType = .Done
        passwordInputView.textField.keyboardType = .NumbersAndPunctuation
        return passwordInputView
    }()

    lazy var loginBtn: UIButton = {
        let loginBtn = UIButton(type: UIButtonType.Custom)
        loginBtn.layer.cornerRadius = 4
        loginBtn.setTitle("Sign in", forState: UIControlState.Normal)
        loginBtn.backgroundColor = UIColor(red: 31.0/255.0, green: 186.0/255.0, blue: 214.0/255.0, alpha: 0.9)
        loginBtn.titleLabel?.font = UIFont.systemFontOfSize(15)
        loginBtn.addTarget(self, action: #selector(self.clickLoginAction), forControlEvents: .TouchUpInside)
        return loginBtn
    }()
}
