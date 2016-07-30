//
//  FKPhotoListView.swift
//  StorageApp
//
//  Created by jack on 16/7/27.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

typealias removeImgClosure = (index: Int) -> Void

class FKPhotoListView: UIView {

    var maxCount: Int = 0 {
        didSet {
            self.refreshIndexLabel()
        }
    }
    
    private var images: [UIImage]?
    var removeClosure: removeImgClosure?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.addAllSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData(images: [UIImage]?, scrollToLast: Bool) -> Void {
        self.images = images
        self.collectionView.reloadData()
        self.refreshIndexLabel()
        
        if scrollToLast && self.images != nil {
            let lastIndex = NSIndexPath.init(forRow: self.images!.count - 1, inSection: 0)
            self.collectionView.scrollToItemAtIndexPath(lastIndex, atScrollPosition: .None, animated: true)
        }
    }
    
    private func refreshIndexLabel() {
        var imageCount = 0
        if self.images != nil {
            imageCount = (self.images?.count)!
        }
        
        let indexStr = String.init(format: "%ld/%ld", imageCount, self.maxCount)
        self.indexLabel.text = indexStr
    }
    
    private func addAllSubviews() {
        self.addSubview(self.collectionView)
        self.addSubview(self.indexLabel)
        
        self.collectionView.snp_makeConstraints { (make) in
            make.left.top.bottom.equalTo(self)
            make.right.equalTo(self).offset(-50)
        }
        
        self.indexLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.centerX.equalTo(self.snp_right).offset(-25)
        }
    }
    
    @objc private func clickDeleteBtn(sender: UIButton) {
        if self.removeClosure != nil {
            self.removeClosure!(index: sender.tag)
        }
    }
    
    // MARK: - property
    lazy var collectionView: UICollectionView = {
        
        let flow = UICollectionViewFlowLayout.init()
        flow.minimumLineSpacing = 1.0
        flow.minimumInteritemSpacing = 1.0
        flow.itemSize = CGSizeMake(85, 90)
        flow.scrollDirection = .Horizontal
        
        let collectionView = UICollectionView.init(frame: CGRectZero, collectionViewLayout: flow)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.registerClass(FKPerImgCollectionCell.self, forCellWithReuseIdentifier: String(FKPerImgCollectionCell))
        return collectionView
    }()
    
    lazy var indexLabel: UILabel = {
       let label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x444444)
        label.font = UIFont.systemFontOfSize(12)
        label.text = "6/9"
        return label
    }()
}

extension FKPhotoListView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let imageArray = self.images as [UIImage]! else {
            return 0
        }
        return imageArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        guard let imgCell = collectionView.dequeueReusableCellWithReuseIdentifier(String(FKPerImgCollectionCell), forIndexPath: indexPath) as? FKPerImgCollectionCell else{
            return UICollectionViewCell.init()
        }
        let image = self.getImageAtIndex(indexPath.row)
        imgCell.targetImgView.image = image
        imgCell.deleteBtn.tag = indexPath.row
        imgCell.deleteBtn.addTarget(self, action: #selector(self.clickDeleteBtn(_:)), forControlEvents: .TouchUpInside)
        return imgCell
    }
    
    private func getImageAtIndex(index: Int) -> UIImage? {
        guard index >= 0 && self.images != nil else {
            return nil
        }
        
        guard index < self.images?.count else {
            return nil
        }
        
        return self.images![index]
    }
}
