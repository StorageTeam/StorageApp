//
//  FKBuyingHeaderView.swift
//  StorageApp
//
//  Created by jack on 16/8/26.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSSDeliverTitleCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.selectionStyle = .None
        self.backgroundColor = UIColor.whiteColor()
        
        self.addAllSubviews();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    func addAllSubviews() {
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(15)
            make.bottom.equalTo(self.contentView).offset(-10)
        }
    }
    
    // MARK: - Property
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x999999)
        label.font = UIFont.systemFontOfSize(12)
        return label
    }()

}
