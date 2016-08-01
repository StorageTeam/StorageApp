//
//  DSSProductWaitsaleCell.swift
//  StorageApp
//
//  Created by ascii on 16/8/1.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import Foundation
import Haneke

class DSSProductWaitsaleCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.init(rgb: 0xffffff)
        
        self.contentView.addSubview(self.timeLabel)
        self.timeLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.top.equalTo(self.contentView).offset(12)
        }
        
        let line = UIView.init()
        line.backgroundColor = UIColor.init(rgb: 0xf4f4f4)
        self.contentView.addSubview(line)
        line.snp_makeConstraints { (make) in
            make.top.equalTo(self.timeLabel.snp_bottom).offset(12)
            make.left.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView)
            make.height.equalTo(DSSConst.pixelHeight)
        }
        
        self.contentView.addSubview(self.phototView)
        self.phototView.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.top.equalTo(line.snp_bottom).offset(14)
            make.size.equalTo(CGSizeMake(80, 80))
        }
        
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.phototView.snp_right).offset(10)
            make.right.equalTo(self.contentView).offset(-12)
            make.top.equalTo(self.phototView)
        }
        
        self.contentView.addSubview(self.upcLabel)
        self.upcLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.titleLabel)
            make.bottom.equalTo(self.phototView).offset(-26)
        }
        
        self.contentView.addSubview(self.button)
        self.button.snp_makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-12)
            make.bottom.equalTo(self.phototView)
            make.size.equalTo(CGSizeMake(100, 26))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func fk_configWith(viewModel: AnyObject, indexPath: NSIndexPath) {
        if let viewModel = viewModel as? DSSProductListViewModel {
            if let model = (viewModel.itemAtIndexPath(indexPath) as? DSSProductWaitsaleModel) {
                self.timeLabel.text   = nil
                self.phototView.image = nil
                self.titleLabel.text  = nil
                self.upcLabel.text    = nil

                
                if let time = model.createTime?.stringByReplacingOccurrencesOfString("T", withString: " ") {
                    self.timeLabel.text = "创建时间：" + time
                }
                if let url = model.photoURL {
                    self.phototView.dss_setImageFromURLString(url, cdnWidth: 80)
                }
                if let name = model.name {
                    self.titleLabel.text = name
                }
                if let upc = model.upc {
                    self.upcLabel.text = upc
                }
            }
        }
    }
    
    //MARK: - Method
    
//    class func height() -> CGFloat {
//        return 78
//    }
    
    //MARK: - Property
    lazy var timeLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x262626)
        label.font = UIFont.systemFontOfSize(14)
        return label
    }()
    
    lazy var phototView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .ScaleAspectFit
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.init(rgb: 0xf4f4f4).CGColor
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x262626)
        label.font = UIFont.systemFontOfSize(14)
        label.numberOfLines = 2
//        label.text = "美国纽约市德尔肯街道Wal-Mar远大智宗大商业大厦大商业大厦"
        return label
    }()
    
    lazy var upcLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x999999)
        label.font = UIFont.systemFontOfSize(14)
//        label.text = "DSU20160801"
        return label
    }()
    
    lazy var button: UIButton = {
        let button = UIButton.init(type: .Custom)
        button.titleLabel!.font = UIFont.systemFontOfSize(14)
        button.setTitle("编辑", forState: .Normal)
        button.layer.cornerRadius = 4
        button.backgroundColor = UIColor.init(rgb: 0x1fbad6)
        return button
    }()
}
