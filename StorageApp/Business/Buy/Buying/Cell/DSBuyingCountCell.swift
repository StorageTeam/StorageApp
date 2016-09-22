//
//  FKBuyingCountCell.swift
//  StorageApp
//
//  Created by jack on 16/8/26.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSBuyingCountCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.addAllSubviews();
        self.contentView.backgroundColor = UIColor.whiteColor()
        self.selectionStyle = .None
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAllSubviews() {
        self.contentView.addSubview(self.buyCountTipLabel)
        self.contentView.addSubview(self.buyCountField)
        self.contentView.addSubview(self.waitCountLabel)
        
        self.buyCountTipLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(15)
            make.centerY.equalTo(self.contentView)
        }
        
        self.buyCountField.snp_makeConstraints { (make) in
            make.left.equalTo(self.buyCountTipLabel.snp_right).offset(15)
            make.centerY.equalTo(self.contentView)
//            make.right.equalTo(self.waitCountLabel.snp_left).offset(- 15)
            make.size.equalTo(CGSizeMake(150, 50))
        }
        
        self.waitCountLabel.snp_makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-15)
            make.centerY.equalTo(self.contentView)
        }
    }
    
    lazy var buyCountTipLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x666666)
        label.font = UIFont.systemFontOfSize(14)
        label.text = "本次采购数"
        return label
    }()
    
    lazy var buyCountField: UITextField = {
        let textField = UITextField.init()
        textField.font = UIFont.systemFontOfSize(14)
        textField.textColor = UIColor.init(rgb: 0x333333)
        textField.returnKeyType = UIReturnKeyType.Done
        textField.keyboardType = UIKeyboardType.NumberPad
        return textField
    }()
    
    lazy var waitCountLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x999999)
        label.font = UIFont.systemFontOfSize(12)
        return label
    }()


}
