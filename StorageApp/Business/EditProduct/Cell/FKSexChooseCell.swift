//
//  FKSexChooseCell.swift
//  JackSwift
//
//  Created by jack on 16/6/25.
//  Copyright © 2016年 FirstLink. All rights reserved.
//

import UIKit

class FKSexChooseCell: UITableViewCell {

    var titleLabel: UILabel!
    var subLabel : UILabel!
    let rightArrow = UIImageView.init(image: UIImage.init(named: "edit_rightArrow"))

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .None
        self.initializeSub()
        self.addAllSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeSub(){
        
        titleLabel = UILabel.init()
        titleLabel.font = UIFont.systemFontOfSize(14)
        titleLabel.textColor = UIColor.colorFromHexStr("4a4a4a")
        titleLabel.text = "Group"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        subLabel = UILabel.init()
        subLabel.font = UIFont.systemFontOfSize(14)
        subLabel.textColor = UIColor.blueColor()
        subLabel.text = "Neuter"
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func addAllSubviews() -> Void {
        
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.subLabel)
        self.contentView.addSubview(self.rightArrow)
        
        self.titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.centerY.equalTo(self.contentView)
        }
        
        self.subLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.titleLabel.snp_right).offset(10)
            make.centerY.equalTo(self.titleLabel)
        }
        
        self.rightArrow.snp_makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-10)
            make.centerY.equalTo(self.contentView)
        }
        
    }


}

