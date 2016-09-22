//
//  FKEditImgContainer.swift
//  StorageApp
//
//  Created by jack on 16/6/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class FKEditImgContainer: UIView {

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.addAllSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAllSubviews() -> Void {
        
        self.addSubview(self.imgBgView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.targetImgView)
        self.addSubview(self.deleteBtn)
        self.addSubview(self.tapButton)
        
        self.imgBgView.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSizeMake(FKEditImgContainer.getImgMargin(), FKEditImgContainer.getImgMargin()))
        }
        
        self.titleLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.imgBgView).offset(-7)
            make.centerX.equalTo(self.imgBgView)
        }
        
        self.targetImgView.snp_makeConstraints { (make) in
            make.edges.equalTo(imgBgView)
        }
        
        self.deleteBtn.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.imgBgView.snp_right)
            make.centerY.equalTo(self.imgBgView.snp_top)
            make.size.equalTo(CGSizeMake(30, 30))
        }
        
        self.tapButton.snp_makeConstraints { (make) in
            make.edges.equalTo(self.imgBgView)
        }
    }
    
    class func getImgMargin() -> CGFloat{
        return CGFloat(90.0)
    }
    
    func setProductImg(picItem: DSEditImgItem?, canEdit: Bool){
     
        if picItem == nil {
            self.targetImgView.image = nil
            self.deleteBtn.hidden = true
            self.deleteBtn.hidden = true
        }else{
            self.deleteBtn.hidden = false
            self.deleteBtn.hidden = !canEdit
            
            if picItem!.image != nil {
                self.targetImgView.image = picItem!.image
            } else if picItem?.picUrl != nil {
                let marigin = Int(FKEditImgContainer.getImgMargin())
                self.targetImgView.dss_setImageFromURLString((picItem?.picUrl)!, cdnWidth: marigin)
            }
        }
    }
    
    lazy var targetImgView: UIImageView = {
        
        let imageView: UIImageView = UIImageView.init()
        imageView.contentMode = .ScaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
        
    }()
    
    lazy var imgBgView: UIImageView = {
        
        let imageView: UIImageView = UIImageView.init(image: UIImage.init(named: "line_rec_camera"))
        return imageView
        
    }()
    
    lazy var titleLabel: UILabel = {
        
        let titleLabel = UILabel.init()
        titleLabel.font = UIFont.systemFontOfSize(10)
        titleLabel.textColor = UIColor.init(rgb: 0x1fbad6)
        titleLabel.text = "继续添加"
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .Center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
        
    }()
    
    lazy var tapButton: UIButton = {
        
        let button = UIButton.init(type: UIButtonType.Custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    lazy var deleteBtn: UIButton = {
        
        let button = UIButton.init(type: UIButtonType.Custom)
        button.setImage(UIImage.init(named: "Clear"), forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
}
