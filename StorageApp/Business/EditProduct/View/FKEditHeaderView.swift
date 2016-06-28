//
//  FKEditHeaderView.swift
//  JackSwift
//
//  Created by jack on 16/6/27.
//  Copyright © 2016年 FirstLink. All rights reserved.
//

import UIKit

class FKEditHeaderView: UITableViewHeaderFooterView {
    
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
        titleLabel.textColor = UIColor.colorFromHexStr("9b9b9b")
//        titleLabel.text = "Description"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addAllSubviews() -> Void {
        
        self.contentView.addSubview(self.titleLabel)
        
        self.titleLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(10)
        }
    }

}
