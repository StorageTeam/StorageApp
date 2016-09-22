//
//  DSFindPwdController.swift
//  StorageApp
//
//  Created by ascii on 16/9/22.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSFindPwdController: DSBaseViewController, UITextFieldDelegate {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.init(rgb: 0xf4f4f4)
        self.configLeftBackBtn()
        self.navigationItem.title = "忘记密码"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - UITextFieldDelegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if "\n" == string {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    // MARK: - Action
    func configLeftBackBtn() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "common_back"),
                                                                     style: UIBarButtonItemStyle.Plain,
                                                                     target: self,
                                                                     action: #selector(self.clickDefaultLeftBar))
    }
    
    @objc private func clickSubmitBtnAction() {
        
    }
    
    // MARK: - loadView
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(self.emailTextField)
        self.emailTextField.snp_makeConstraints { (make) in
            make.top.equalTo(self.view).offset(12)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.height.equalTo(44)
        }
        
        self.view.addSubview(self.pwdTextField)
        self.pwdTextField.snp_makeConstraints { (make) in
            make.top.equalTo(self.emailTextField.snp_bottom)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.height.equalTo(44)
        }
        
        self.view.addSubview(self.confirmPwdTextField)
        self.confirmPwdTextField.snp_makeConstraints { (make) in
            make.top.equalTo(self.pwdTextField.snp_bottom)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.height.equalTo(44)
        }

        self.view.addSubview(self.submitButton)
        self.submitButton.snp_makeConstraints { (make) in
            make.top.equalTo(self.confirmPwdTextField.snp_bottom).offset(30)
            make.left.equalTo(self.view).offset(28)
            make.right.equalTo(self.view).offset(-28)
            make.height.equalTo(45)
        }
    }
    
    // MARK: - Property
    
    lazy var emailTextField: DSUserTextField = {
        let emailTextField = DSUserTextField(placeholder: "请输入邮箱地址", secure: false)
        emailTextField.textField.delegate = self;
        emailTextField.textField.returnKeyType = .Done
        emailTextField.textField.keyboardType = .NumbersAndPunctuation
        emailTextField.backgroundColor = UIColor.whiteColor()
        return emailTextField
    }()
    
    lazy var pwdTextField: DSUserTextField = {
        let pwdTextField = DSUserTextField(placeholder: "设置新密码(密码为6-16位字母或数字)", secure: true)
        pwdTextField.textField.delegate = self;
        pwdTextField.textField.returnKeyType = .Done
        pwdTextField.textField.keyboardType = .NumbersAndPunctuation
        pwdTextField.backgroundColor = UIColor.whiteColor()
        return pwdTextField
    }()
    
    lazy var confirmPwdTextField: DSUserTextField = {
        let pwdTextField = DSUserTextField(placeholder: "再次输入密码", secure: true)
        pwdTextField.textField.delegate = self;
        pwdTextField.textField.returnKeyType = .Done
        pwdTextField.textField.keyboardType = .NumbersAndPunctuation
        pwdTextField.backgroundColor = UIColor.whiteColor()
        return pwdTextField
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton(type: UIButtonType.Custom)
        button.layer.cornerRadius = 4
        button.setTitle("完成", forState: UIControlState.Normal)
        button.backgroundColor = UIColor.init(rgb: 0x1fbad6)
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        button.addTarget(self, action: #selector(self.clickSubmitBtnAction), forControlEvents: .TouchUpInside)
        return button
    }()

}
