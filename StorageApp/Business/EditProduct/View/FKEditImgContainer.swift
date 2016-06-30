//
//  FKEditImgContainer.swift
//  StorageApp
//
//  Created by jack on 16/6/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class FKEditImgContainer: UIView {
    
    private let targetImgView: UIImageView = UIImageView.init()
    private let imgBgView: UIImageView = UIImageView.init(image: UIImage.init(named: "line_rect"))
    private let titleLabel: UILabel = UILabel.init()
    
    let deleteBtn: UIButton = UIButton.init(type: UIButtonType.Custom)
    let tapButton: UIButton = UIButton.init(type: UIButtonType.Custom)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeSub()
        self.addAllSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeSub(){
        
        titleLabel.font = UIFont.systemFontOfSize(14)
        titleLabel.textColor = UIColor.init(rgb: 0xcccccc)
        titleLabel.text = "Main\nPicture"
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .Center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        targetImgView.contentMode = .ScaleAspectFit
        targetImgView.translatesAutoresizingMaskIntoConstraints = false
        
        deleteBtn.setImage(UIImage.init(named: "Clear"), forState: .Normal)
        deleteBtn.translatesAutoresizingMaskIntoConstraints = false
        
        imgBgView.translatesAutoresizingMaskIntoConstraints = false
        
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
//            make.center.equalTo(self)
            make.size.equalTo(CGSizeMake(FKEditImgContainer.getImgMargin(), FKEditImgContainer.getImgMargin()))
        }
        
        self.titleLabel.snp_makeConstraints { (make) in
            make.center.equalTo(self.imgBgView)
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
    
    func setProductImg(picItem: DSSEditImgItem?, canEdit: Bool){
     
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
}
