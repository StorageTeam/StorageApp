//
//  FKEditDescCell.swift
//  JackSwift
//
//  Created by jack on 16/6/25.
//  Copyright © 2016年 FirstLink. All rights reserved.
//

import UIKit

class FKEditDescCell: UITableViewCell , UITextViewDelegate, FKEditCellProtocol{
    
    weak var delegate : FKEditInputProtocol?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .None
        self.addAllSubviews()
        
    }
    
     required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAllSubviews() -> Void {
        
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.textView)
        
        self.titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.centerY.equalTo(self.contentView)
        }
        
        self.textView.snp_makeConstraints { (make) in
            make.left.equalTo(self.titleLabel.snp_right).offset(10)
            make.right.equalTo(self.contentView).offset(-10)
            make.top.equalTo(contentView).offset(10)
            make.bottom.equalTo(self.contentView).offset(-10)
        }
    }
    
    override func fk_configWith(viewModel: AnyObject, indexPath: NSIndexPath) {
        if let editModel = viewModel as? EditViewModel {
            self.textView.text = editModel.dataItem.infoItem.desc
            
            var canEdit = true
            if editModel.editType == kEditType.kEditTypeCheck {
                canEdit = false
            }
            self.textView.userInteractionEnabled = canEdit
        }
    }
    
    
    func textViewDidEndEditing(textView: UITextView) {
        if self.delegate != nil && self.delegate!.respondsToSelector(#selector(FKEditInputProtocol.finishInput(_:text:))){
            self.delegate?.finishInput(self, text: textView.text)
        }
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if self.delegate != nil && self.delegate!.respondsToSelector(#selector(FKEditInputProtocol.shouldBeginEditing(_:))){
            self.delegate?.shouldBeginEditing(textView)
        }
        return true
    }

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.endEditing(true)
            return false
        }
        return true
    }
    
    // MARK: property
    lazy var titleLabel: UILabel = {
        
        let label = UILabel.init()
        label.font = UIFont.systemFontOfSize(14)
        label.textColor = UIColor.init(rgb: 0x4a4a4a)
        label.text = "Description\n(optional)"
        label.numberOfLines = 2
        label.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    lazy var textView: UITextView = {
        
        let textView = UITextView.init()
        textView.textColor = UIColor.init(rgb: 0xcccccc)
        textView.returnKeyType = .Done
        textView.font = UIFont.systemFontOfSize(14)
        textView.delegate = self
        textView.showsVerticalScrollIndicator = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
        
    }()

}
