//
//  FKPerImgCollectionCell.swift
//  StorageApp
//
//  Created by jack on 16/7/27.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class FKPerImgCollectionCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addAllSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addAllSubviews() {
        
        self.contentView.addSubview(self.imgBgView)
        self.contentView.addSubview(self.deleteBtn)
        self.imgBgView.addSubview(self.targetImgView)
        
        self.imgBgView.snp_makeConstraints { (make) in
            make.left.centerY.equalTo(self.contentView)
            make.size.equalTo(CGSizeMake(72, 72))
        }
        
        self.targetImgView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(1, 1, -1, -1))
        }
        
        self.deleteBtn.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.imgBgView.snp_right)
            make.centerY.equalTo(self.imgBgView.snp_top)
        }
    }
    
    //MARK: - property
    private lazy var imgBgView: UIImageView = {
        
        let imageView: UIImageView = UIImageView.init(image: UIImage.init(named: "line_rect"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    lazy var deleteBtn: UIButton = {
        
        let button = UIButton.init(type: UIButtonType.Custom)
        button.setImage(UIImage.init(named: "Clear"), forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        return button
        
    }()
    
    lazy var targetImgView: UIImageView = {
        
        let imageView: UIImageView = UIImageView.init()
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()

}
