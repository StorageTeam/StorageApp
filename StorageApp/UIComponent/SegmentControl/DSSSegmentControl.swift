//
//  DSSSegmentControl.swift
//  StorageApp
//
//  Created by ascii on 16/6/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import Foundation
import SnapKit

protocol DSSSegmentControlDelegate {
    func segmentControlDidSelected(control: DSSSegmentControl, index: Int) -> Void
}

class DSSSegmentControl: UIView {
    private let imageNames: Array<String>!
    private let selectedImageNames: Array<String>!
    private let titles: Array<String>!
    private let titleColor: UIColor!
    private let selectedTitleColor: UIColor!
    private let bgColor: UIColor!
    private let selectedBgColor: UIColor!
    
    private var buttons: Array<UIButton>?
    
    var delegate:DSSSegmentControlDelegate?
    
    
    init(imageNames: Array<String>
        , selectedImageNames: Array<String>
        , titles: Array<String>
        , titleColor: UIColor         = UIColor.init(rgb: 0x9b9b9b)
        , selectedTitleColor: UIColor = UIColor.init(rgb: 0x1fbad6)
        , bgColor: UIColor            = UIColor.init(rgb: 0xffffff)
        , selectedBgColor: UIColor    = UIColor.init(rgb: 0xffffff)) {
        
        self.imageNames         = imageNames
        self.selectedImageNames = selectedImageNames
        self.titles             = titles
        self.titleColor         = titleColor
        self.selectedTitleColor = selectedTitleColor
        self.bgColor            = bgColor
        self.selectedBgColor    = selectedBgColor
        
        super.init(frame: CGRectZero)
    }
    
    @objc private func buttonClickAction(button: UIButton) {
        let tarIdx = button.tag
        for idx in 0 ..< self.buttons!.count {
            if let btn = self.buttons?[idx] {
                if idx == tarIdx {
                    btn.selected = true
                    btn.backgroundColor = self.selectedBgColor
                    
                    self.bottomIndicatorView.frame = CGRectMake(CGFloat.init(idx)*CGRectGetWidth(button.frame),
                                                                CGRectGetHeight(self.frame) - 2.0,
                                                                CGRectGetWidth(button.frame),
                                                                2.0)
                } else {
                    btn.selected = false
                    btn.backgroundColor = self.bgColor
                }
            }
        }
        
        self.delegate?.segmentControlDidSelected(self, index: button.tag)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        var button: UIButton!
        let count = min(min(selectedImageNames.count, imageNames.count), titles.count)
        let width = ceil(CGRectGetWidth(self.frame)/CGFloat(count))
        
        var buttons:Array<UIButton> = []
        
        for idx in 0 ..< count {
            button = UIButton.init(type: .Custom)
            button.titleLabel!.font = UIFont.systemFontOfSize(14)
            button.frame = CGRectMake(CGFloat(idx)*width, 0, width, CGRectGetHeight(self.frame))
            button.setTitle(self.titles[idx], forState: .Normal)
            
            button.setImage(UIImage.init(named: self.imageNames[idx]), forState: .Normal)
            button.setImage(UIImage.init(named: self.selectedImageNames[idx]), forState: .Selected)
            button.setImage(UIImage.init(named: self.selectedImageNames[idx]), forState: .Highlighted)
            
            button.setTitleColor(self.titleColor, forState: .Normal)
            button.setTitleColor(self.selectedTitleColor, forState: .Selected)
            button.setTitleColor(self.selectedTitleColor, forState: .Highlighted)
            
            button.tag = idx
            button.addTarget(self, action: #selector(self.buttonClickAction(_:)), forControlEvents: .TouchUpInside)
            self.addSubview(button)
            
            // set title under image
//            let spacing: CGFloat = CGFloat(3)
//            let imageSize = button.imageView!.frame.size
//            button.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + spacing), 0.0);
            
//            let titleSize = button.titleLabel!.frame.size
//            button.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0.0, 0.0, -titleSize.width);
            
            if idx != (count - 1) {
                let line = UIView.init()
                line.backgroundColor = UIColor.init(rgb: 0xe5e5e5)
                
                button.addSubview(line)
                line.frame = CGRectMake(width - 1,
                                        (CGRectGetHeight(self.frame) - 30.0)/2.0,
                                        DSSConst.pixelHeight,
                                        30.0);
            }
            
            if idx == 0 {
                button.selected = true
                button.backgroundColor = self.selectedBgColor
            } else {
                button.selected = false
                button.backgroundColor = self.bgColor
            }
            
            buttons.append(button)
        }
        
        self.addSubview(self.bottomIndicatorView)
        self.bottomIndicatorView.frame = CGRectMake(0,
                                                    CGRectGetHeight(self.frame) - 2.0,
                                                    width,
                                                    2.0)
        self.buttons = buttons
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var bottomIndicatorView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.init(rgb: 0x1fbad6)
        return view;
    }()

}
