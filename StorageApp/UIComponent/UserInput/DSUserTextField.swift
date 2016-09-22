//
//  DSUserTextField.swift
//  StorageApp
//
//  Created by ascii on 16/6/23.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import SnapKit

public class DSUserTextField: UIView {
    
    
    init(placeholder: String?, secure: Bool) {
        super.init(frame: CGRectZero)
        
        self.textField.secureTextEntry = secure
        self.textField.placeholder = placeholder
        
        self.addSubview(self.textField)
        self.textField.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.right.equalTo(self).offset(-15)
            make.top.equalTo(self).offset(4)
            make.bottom.equalTo(self).offset(-4)
        }
        
        self.addSubview(self.line)
        self.line.snp_makeConstraints { (make) in
            make.left.bottom.right.equalTo(self)
            make.height.equalTo(DSConst.pixelHeight)
        }
    }
    
    init(title: String!, placeholder: String?, secure: Bool) {
        super.init(frame: CGRectZero)
        assert(!title.isEmpty, "title could not be nil")
        
        self.titleLabel.text = title
        self.textField.secureTextEntry = secure
        self.textField.placeholder = placeholder
        
        self.addSubview(self.textField)
        self.textField.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(72)
            make.right.equalTo(self)
            make.top.equalTo(self).offset(2)
            make.bottom.equalTo(self).offset(-2)
        }
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.centerY.equalTo(self.textField)
        }
        
        self.addSubview(self.line)
        self.line.snp_makeConstraints { (make) in
            make.left.bottom.right.equalTo(self)
            make.height.equalTo(DSConst.pixelHeight)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Property
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x333333)
        label.font = UIFont.systemFontOfSize(15)
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField.init()
        textField.font = UIFont.systemFontOfSize(15)
        textField.clearButtonMode = .WhileEditing
        return textField
    }()
    
    lazy var line: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.init(rgb: 0xe5e5e5)
        return view
    }()
}
