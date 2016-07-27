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
        self.layer.borderWidth = DSSConst.pixelHeight
        self.layer.borderColor = UIColor.init(rgb: 0xdddddd).CGColor
        self.backgroundColor = UIColor.clearColor()
        
        // init property
//        self.imgIcon.image = UIImage.init(named: iconName)
//        self.textField.placeholder = placeholder
        self.textField.secureTextEntry = secure
        self.textField.attributedPlaceholder = NSAttributedString.init(string: placeholder!,
                                                                       attributes: [NSForegroundColorAttributeName: UIColor.init(rgb: 0x888888)])
        
        // layout
//        let grayBgView : UIView! = UIView.init()
//        grayBgView.backgroundColor = UIColor.clearColor()
//        self.addSubview(grayBgView)
//        grayBgView.snp_makeConstraints { (make) in
//            make.left.top.bottom.equalTo(self)
//            make.width.equalTo(44)
//        }
        
//        grayBgView.addSubview(self.imgIcon)
//        self.imgIcon.snp_makeConstraints { (make) in
//            make.left.equalTo(grayBgView).offset(10)
//            make.centerY.equalTo(grayBgView)
//            make.size.equalTo(CGSizeMake(22, 22))
//        }
        
        self.addSubview(self.textField)
        self.textField.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(12)
            make.right.equalTo(self).offset(-12)
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
        imgIcon.contentMode = .ScaleAspectFit
        return imgIcon
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField.init()
        textField.font = UIFont.systemFontOfSize(15)
        textField.textColor = UIColor.init(rgb: 0x1fbad6)
        return textField
    }()
}
