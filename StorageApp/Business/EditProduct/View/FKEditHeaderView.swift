//
//  FKEditHeaderView.swift
//  JackSwift
//
//  Created by jack on 16/6/27.
//  Copyright © 2016年 FirstLink. All rights reserved.
//

import UIKit

class FKEditHeaderView: UITableViewHeaderFooterView {
    
    var tapButton = UIButton.init(type: UIButtonType.Custom)
    var titleLabel: UILabel! = UILabel.init()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.initializeSub()
        self.addAllSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeSub(){
        
        titleLabel.font = UIFont.systemFontOfSize(13)
        titleLabel.textColor = UIColor.init(rgb: 0x9b9b9b)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
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

}
