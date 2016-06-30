//
//  FKEditDeleteCell.swift
//  StorageApp
//
//  Created by jack on 16/6/29.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class FKEditDeleteCell: UITableViewCell {

    var deleteBtn: UIButton = UIButton.init(type: UIButtonType.Custom)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .None
        self.backgroundColor = UIColor.clearColor()
        
        self.initializeSub()
        self.addAllSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeSub(){
        self.deleteBtn.setTitle("Delete", forState: .Normal)
        self.deleteBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.deleteBtn.titleLabel?.font = UIFont.systemFontOfSize(15)
        self.deleteBtn.backgroundColor = UIColor.init(rgb: 0xfe3b31)
        self.deleteBtn.layer.cornerRadius = 5.0
    }
    
    func addAllSubviews() -> Void {
        
        self.contentView.addSubview(self.deleteBtn)
        self.deleteBtn.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(15)
            make.right.equalTo(self.contentView).offset(-15)
            make.center.equalTo(self.contentView)
            make.height.equalTo(46.0)
        }
    }

}
