//
//  DSALoginController.swift
//  StorageApp
//
//  Created by ascii on 16/6/23.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

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
        self.view.backgroundColor = UIColor(white: 0, alpha: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - DSSDataCenterDelegate
    func networkDidResponseSuccess(identify: Int, header: DSSResponseHeader, response: [String : AnyObject], userInfo: [String : AnyObject]?) {
        if header.code == DSSResponseCode.Normal {
            DSSAccount.saveAccount(response["data"]?["user"])
            self.dismissViewControllerAnimated(true, completion: {})
        } else {
            super.showHUD(header.msg)
        }
    }
    
    func networkDidResponseError(identify: Int, header: DSSResponseHeader?, error: String?, userInfo: [String : AnyObject]?) {
        super.showHUD(error)
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
    @objc private func loginAction() {
        DSSLoginService.requestLogin(DSSLoginController.DSS_LOGIN_REQUEST_IDENTIFY
            , delegate: self
            , mobile: "18656396627"
            , password: "111111")
    }
    
    // MARK: - loadView
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(self.logoImgView)
        self.logoImgView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view).offset(96)
            make.centerX.equalTo(self.view)
            make.size.equalTo(CGSizeMake(100, 100))
        }
        
        self.view.addSubview(self.mobileInputView)
        self.mobileInputView.snp_makeConstraints { (make) in
            make.top.equalTo(self.logoImgView.snp_bottom).offset(40)
            make.centerX.equalTo(self.view)
            make.size.equalTo(CGSizeMake(276, 46))
        }
        
        self.view.addSubview(self.passwordInputView)
        self.passwordInputView.snp_makeConstraints { (make) in
            make.top.equalTo(self.mobileInputView.snp_bottom).offset(16)
            make.centerX.equalTo(self.view)
            make.size.equalTo(CGSizeMake(276, 46))
        }
        
        self.view.addSubview(self.loginBtn)
        self.loginBtn.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.view).offset(-200)
            make.centerX.equalTo(self.view)
            make.size.equalTo(CGSizeMake(276, 46))
        }
    }
    
    // MARK: - Property
    lazy var logoImgView: UIImageView = {
        let logoImgView = UIImageView()
        logoImgView.backgroundColor = UIColor(white: 0.5, alpha: 1)
        return logoImgView
    }()
    
    lazy var mobileInputView: DSSLoginTextInput = {
        let mobileInputView = DSSLoginTextInput(iconName: "test", placeholder: "Phone number", secure: false)
        mobileInputView.backgroundColor = UIColor.init(white: 1, alpha: 1)
        mobileInputView.textField.delegate = self;
        mobileInputView.textField.returnKeyType = .Done
        mobileInputView.textField.keyboardType = .NumbersAndPunctuation
        return mobileInputView
    }()
    
    lazy var passwordInputView: DSSLoginTextInput = {
        let passwordInputView = DSSLoginTextInput(iconName: "test", placeholder: "Password", secure: true)
        passwordInputView.backgroundColor = UIColor.init(white: 1, alpha: 1)
        passwordInputView.textField.delegate = self;
        passwordInputView.textField.returnKeyType = .Done
        return passwordInputView
    }()

    lazy var loginBtn: UIButton = {
        let loginBtn = UIButton(type: UIButtonType.Custom)
        loginBtn.layer.cornerRadius = 4
        loginBtn.setTitle("Sign in", forState: UIControlState.Normal)
        loginBtn.backgroundColor = UIColor(red: 232.0/255.0, green: 97.0/255.0, blue: 31.0/255.0, alpha: 1.0)
        loginBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        loginBtn.addTarget(self, action: #selector(self.loginAction), forControlEvents: .TouchUpInside)
        return loginBtn
    }()
}
