//
//  JSFetchImgCell.swift
//  JSNoteOnline
//
//  Created by jack on 16/7/22.
//  Copyright © 2016年 FirstLink. All rights reserved.
//

import UIKit

class DSSFetchImgCell: UICollectionViewCell {
    
    var assetIdentify: String?
    var didSelected: Bool = false {
        didSet {
            self.selectImgView.hidden = (didSelected ? false : true)
            self.noSelectView.hidden = (didSelected ? true : false)
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.addAllSubviews()
        
        self.contentView.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addAllSubviews() {
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.noSelectView)
        self.contentView.addSubview(self.selectImgView)
        
        self.imageView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsZero)
        }
        
        self.noSelectView.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.contentView.snp_right).offset(-13)
            make.centerY.equalTo(self.contentView.snp_top).offset(13)
            make.size.equalTo(CGSizeMake(22, 22))
        }
        
        self.selectImgView.snp_makeConstraints { (make) in
            make.center.equalTo(self.noSelectView)
        }
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.contentMode = .ScaleAspectFill
        return imageView
    }()

    lazy var selectImgView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "blue_selected"))
//        imageView.hidden = true
        return imageView
    }()
    
    lazy var noSelectView : UIView = {
       let view = UIView.init()
        view.userInteractionEnabled = false
        view.layer.cornerRadius = 11.0
        view.layer.borderColor = UIColor.init(rgb: 0xdddddd).CGColor
        view.layer.borderWidth = 1.0
        return view
    }()
}
