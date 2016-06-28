//
//  FKEditUpcCell.swift
//  JackSwift
//
//  Created by jack on 16/6/25.
//  Copyright © 2016年 FirstLink. All rights reserved.
//

import UIKit

class FKEditUpcCell: UITableViewCell {

    private var titleLabel: UILabel!
    private var contentLabel: UILabel!
    var addButton : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
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
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.text = "UPC"
        titleLabel.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentLabel = UILabel.init()
        contentLabel.font = UIFont.systemFontOfSize(14)
        contentLabel.textColor = UIColor.blackColor()
        contentLabel.numberOfLines = 1
        contentLabel.lineBreakMode = .ByTruncatingTail
        contentLabel.textAlignment = .Left
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addButton = UIButton.init(type:.Custom)
        addButton.titleLabel?.font = UIFont.systemFontOfSize(25)
//        addButton.setTitle("+", forState: .Normal)
        //        addButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
        addButton.setImage(UIImage.init(named: "upc_add"), forState: .Normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addAllSubviews() -> Void {
        
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.contentLabel)
        self.contentView.addSubview(self.addButton)
        
        self.titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(15)
            make.centerY.equalTo(self.contentView)
        }
        
        self.contentLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.titleLabel.snp_right).offset(15)
            make.right.equalTo(self.addButton.snp_left)
            make.centerY.equalTo(self.contentView)
        }
        
        self.addButton.snp_makeConstraints { (make) in
            make.right.equalTo(self.contentView)
            make.centerY.equalTo(self.contentView)
            make.height.equalTo(self.contentView)
            make.width.equalTo(45);
        }
    }
    
    override func fk_configWith(viewModel: AnyObject, indexPath: NSIndexPath) {
        if let editViewModel = viewModel as? EditViewModel{
            self.contentLabel.text = editViewModel.currentUpcStr
        }
    }

}
