//
//  DSSLoginTextField.swift
//  StorageApp
//
//  Created by ascii on 16/6/23.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import SnapKit

public class DSSLoginTextInput: UIView {
    
    
    init(iconName: String!, placeholder: String?, secure: Bool) {
        super.init(frame: CGRectZero)
        assert(!iconName.isEmpty, "icon name could not be nil")
        
        // config
        self.clipsToBounds = true
        self.layer.cornerRadius = 4
        
        // init property
        self.imgIcon.image = UIImage.init(named: iconName)
        self.textField.placeholder = placeholder
        self.textField.secureTextEntry = secure
        
        // layout
        let grayBgView : UIView! = UIView.init()
        grayBgView.backgroundColor = UIColor.init(white: 204.0/255.0, alpha: 1)
        self.addSubview(grayBgView)
        grayBgView.snp_makeConstraints { (make) in
            make.left.top.bottom.equalTo(self)
            make.width.equalTo(44)
        }
        
        grayBgView.addSubview(self.imgIcon)
        self.imgIcon.snp_makeConstraints { (make) in
            make.left.equalTo(grayBgView).offset(10)
            make.centerY.equalTo(grayBgView)
            make.size.equalTo(CGSizeMake(22, 22))
        }
        
        self.addSubview(self.textField)
        self.textField.snp_makeConstraints { (make) in
            make.left.equalTo(grayBgView.snp_right).offset(16)
            make.right.equalTo(self).offset(-16)
            make.top.equalTo(self).offset(4)
            make.bottom.equalTo(self).offset(-4)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Property
    lazy var imgIcon: UIImageView = {
        let imgIcon = UIImageView()
        return imgIcon
    }()
    
    public lazy var textField: UITextField = {
        let textField = UITextField.init()
        textField.font = UIFont.systemFontOfSize(14)
        return textField
    }()
}
