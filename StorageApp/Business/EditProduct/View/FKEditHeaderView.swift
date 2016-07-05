//
//  FKEditHeaderView.swift
//  JackSwift
//
//  Created by jack on 16/6/27.
//  Copyright © 2016年 FirstLink. All rights reserved.
//

import UIKit

class FKEditHeaderView: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        
        super.init(reuseIdentifier: reuseIdentifier)
        self.addAllSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAllSubviews() -> Void {
        
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.tapButton)
        
        self.titleLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(10)
        }
        
        self.tapButton.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsZero)
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFontOfSize(13)
        label.textColor = UIColor.init(rgb: 0x9b9b9b)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var tapButton: UIButton = {
        let button = UIButton.init(type: UIButtonType.Custom)
        return button
    }()

}
