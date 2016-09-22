//
//  DSStartController.swift
//  StorageApp
//
//  Created by ascii on 16/6/23.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import Foundation

class DSStartController: DSBaseViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.hidden = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    @objc private func clickLoginAction() {
        
    }
    
    @objc private func clickRegisterAction() {
        
    }
    
    // MARK: - loadView
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(self.bgImgView)
        self.bgImgView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        self.view.addSubview(self.logoLabel)
        self.logoLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.view).offset(109)
            make.centerX.equalTo(self.view)
        }
        
        self.view.addSubview(self.titleLabel)
        self.titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.logoLabel.snp_bottom).offset(12)
            make.centerX.equalTo(self.view)
        }
        
        self.view.addSubview(self.loginBtn)
        self.loginBtn.snp_makeConstraints { (make) in
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view.snp_centerX).offset(-10)
            make.bottom.equalTo(self.view).offset(-70)
            make.height.equalTo(45)
        }
        
        self.view.addSubview(self.registerBtn)
        self.registerBtn.snp_makeConstraints { (make) in
            make.left.equalTo(self.view.snp_centerX).offset(10)
            make.right.equalTo(self.view).offset(-20)
            make.bottom.equalTo(self.view).offset(-70)
            make.height.equalTo(45)
        }
    }
    
    // MARK: - Property
    
    lazy var logoLabel: UILabel = {
        let label = UILabel.init()
        label.text = "FIRST LINK"
        label.textColor = UIColor.init(rgb: 0xffffff)
        label.font = UIFont.boldSystemFontOfSize(30)
        label.textAlignment = .Center
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.text = "世界商店零距离"
        label.textColor = UIColor.init(rgb: 0x1fbad6)
        label.font = UIFont.systemFontOfSize(32)
        label.textAlignment = .Center
        return label
    }()
    
    lazy var bgImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = DSImage.dss_bgImage(UIScreen.mainScreen().bounds.size)
        return imgView
    }()

    lazy var loginBtn: UIButton = {
        let button = UIButton(type: UIButtonType.Custom)
        button.layer.cornerRadius = 4
        button.setTitle("登录", forState: UIControlState.Normal)
        button.backgroundColor = UIColor.init(rgb: 0xffffff)
        button.setTitleColor(UIColor.init(rgb: 0x1fbad6), forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        button.addTarget(self, action: #selector(self.clickLoginAction), forControlEvents: .TouchUpInside)
        return button
    }()
    
    lazy var registerBtn: UIButton = {
        let button = UIButton(type: UIButtonType.Custom)
        button.layer.cornerRadius = 4
        button.setTitle("注册", forState: UIControlState.Normal)
        button.backgroundColor = UIColor.init(rgb: 0x1fbad6)
        button.setTitleColor(UIColor.init(rgb: 0xffffff), forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        button.addTarget(self, action: #selector(self.clickRegisterAction), forControlEvents: .TouchUpInside)
        return button
    }()
}
