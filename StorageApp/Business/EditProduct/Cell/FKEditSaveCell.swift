//
//  FKEditDeleteCell.swift
//  StorageApp
//
//  Created by jack on 16/6/29.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class FKEditSaveCell: UITableViewCell {

//    var deleteBtn: UIButton = UIButton.init(type: UIButtonType.Custom)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .None
        self.backgroundColor = UIColor.clearColor()
    
        self.addAllSubviews()
    }
    
    func addAllSubviews() -> Void {
        
        self.contentView.addSubview(self.saveBtn)
        self.saveBtn.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(15)
            make.right.equalTo(self.contentView).offset(-15)
            make.center.equalTo(self.contentView)
            make.height.equalTo(46.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func fk_configWith(viewModel: AnyObject, indexPath: NSIndexPath) {
        if let editViewModel = viewModel as? EditViewModel {
            let res = editViewModel.isDataComplete();
            self.refreshState(res.complete)
        }
    }
    
    private func refreshState(enable: Bool) {
        if enable {
            self.saveBtn.userInteractionEnabled = true
            self.saveBtn.backgroundColor = UIColor.init(rgb: 0x1fbad6)
        } else {
            self.saveBtn.userInteractionEnabled = false
            self.saveBtn.backgroundColor = UIColor.init(rgb: 0xcccccc)
        }
    }
    
    //MARK: Property
    lazy var saveBtn: UIButton = {
        let button = UIButton.init(type: UIButtonType.Custom)
        button.setTitle("确认收集", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        button.backgroundColor = UIColor.init(rgb: 0x1fbad6)
        button.layer.cornerRadius = 5.0
        return button
    }()

}
