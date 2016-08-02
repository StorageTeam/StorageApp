//
//  JSSelectImgController.swift
//  JSNoteOnline
//
//  Created by jack on 16/7/22.
//  Copyright © 2016年 FirstLink. All rights reserved.
//

import UIKit
import Photos

class DSSSelectImgController: DSSBaseViewController {

    var maxImgCount: Int = 30
    
    var fetchRes : PHFetchResult?
    var itemSize : CGSize {
        get {
            let itemMargin = floor((DSSConst.UISCREENWIDTH - 40) / 3)
            return CGSizeMake(itemMargin, itemMargin)
        }
    }
    
    var imageSize : CGSize {
        get {
            let scale = UIScreen.mainScreen().scale
            return CGSizeMake(self.itemSize.width * scale , self.itemSize.height * scale)
        }
    }
    
    var selectDone:([PHAsset] -> Void)?
    
    convenience init(selectDone: (([PHAsset]) -> Void)?) {
        self.init()
        self.selectDone = selectDone
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addAllSubviews()
        self.configNavItem()
        self.fetchAllPhoto()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.checkAuthority()
    }
    
    deinit {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .Authorized {
            self.cacheManger.stopCachingImagesForAllAssets()
        }
    }

    private func addAllSubviews() {
        self.title = "select photo"
        self.view.addSubview(self.collectionView)
        self.collectionView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsZero)
        }
    }
    
    private func checkAuthority() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .NotDetermined:
            
            weak var weakSelf = self
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) in
                if status == .Authorized {
                    weakSelf?.fetchAllPhoto()
                }
            })
        case .Denied, .Restricted:
            let alert = UIAlertView.init(title: nil, message: "无法使用相机胶卷，请前往设置打开", delegate: nil, cancelButtonTitle: "确认")
            alert.show()
        default:
            break
        }
    }
    
    private func configNavItem() {
        
        let countItem = UIBarButtonItem.init(customView: self.countBtn)
        let flexItem = UIBarButtonItem.init(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        flexItem.width = 7
        
        let finishItem = UIBarButtonItem.init(title: "完成", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.clickFinishBtn))
        let att = [NSForegroundColorAttributeName : UIColor.init(rgb: 0x1fbad6),
                   NSFontAttributeName : UIFont.systemFontOfSize(15)]
        finishItem.setTitleTextAttributes(att, forState: .Normal)
        
        self.navigationItem.rightBarButtonItems = [countItem, flexItem, finishItem]
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "common_back"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.clickBackBtn))
        
    }
    
    @objc private func clickFinishBtn() {
        
        let fetchArray = self.getSelectedFetchArray()
        
        guard fetchArray.count > 0 else {
            self.showText("至少选择一张照片")
            return
        }
        
        if self.selectDone != nil {
            self.selectDone!(fetchArray)
        }
    }
    
    @objc private func clickBackBtn() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func getSelectedFetchArray() -> [PHAsset] {
        
        let indexPaths = self.collectionView.indexPathsForSelectedItems()
        var fetchArray : [PHAsset] = []
        
        guard indexPaths != nil else{
            return fetchArray
        }
        
        for indexItem in indexPaths! {
            let fetchItem = self.getFetchItemAtIndexpath(indexItem)
            guard fetchItem != nil else {
                continue
            }
            fetchArray.append(fetchItem!)
        }
        return fetchArray
    }
    
    private func fetchAllPhoto() {
        let option = PHFetchOptions.init()
        option.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
        self.fetchRes = PHAsset.fetchAssetsWithOptions(option)
        self.collectionView.reloadData()
    }
    
    private func getFetchItemAtIndexpath(indexPath: NSIndexPath) -> PHAsset? {
        guard self.fetchRes != nil else {
            return nil
        }
        
        if indexPath.row < self.fetchRes?.count {
            return self.fetchRes![indexPath.row] as? PHAsset
        }
        return nil
    }
    
    private func refreshSelectCount() {
        let selectArray = self.getSelectedFetchArray()
        self.countBtn.setTitle(String.init(format: "%d", selectArray.count), forState: .Normal)
    }

    lazy var collectionView: UICollectionView = {
        
        let flow = UICollectionViewFlowLayout.init()
//        let itemMargin = floor((UISCREENWIDTH - 40) / 3)
        
        flow.minimumLineSpacing = 10.0
        flow.minimumInteritemSpacing = 5
        flow.itemSize = self.itemSize
        flow.sectionInset = UIEdgeInsetsMake(10, 10, 20, 10)
        
        let collectionView = UICollectionView.init(frame: CGRectZero, collectionViewLayout: flow)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: String(UICollectionViewCell))
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.allowsMultipleSelection = true
        collectionView.registerClass(DSSFetchImgCell.self, forCellWithReuseIdentifier: String(DSSFetchImgCell))
            
        return collectionView
    }()
    
    lazy var cacheManger: PHCachingImageManager = {
        let manger = PHCachingImageManager.init()
        return manger
    }()
    
    lazy var countBtn : UIButton = {
        
        let button = UIButton.init(type: UIButtonType.Custom)
        button.setTitle("0", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        button.backgroundColor = UIColor.init(rgb: 0x1fbad6)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.bounds = CGRectMake(0, 0, 20, 20)
        button.addTarget(self, action: #selector(self.clickFinishBtn), forControlEvents: .TouchUpInside)
        return button
        
    }()
}

extension DSSSelectImgController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.fetchRes != nil) {
            return (self.fetchRes?.count)!
        }
        return 0;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(DSSFetchImgCell), forIndexPath: indexPath)
        let selected = self.isSelectedAt(indexPath)
        
        if let fetchImgCell = cell as? DSSFetchImgCell {
            
            fetchImgCell.didSelected = selected
            
            if let assetItem = self.getFetchItemAtIndexpath(indexPath) {
                
                fetchImgCell.assetIdentify = assetItem.localIdentifier
                self.cacheManger.requestImageForAsset(assetItem, targetSize: self.imageSize, contentMode: .AspectFit, options: nil, resultHandler: { (resImg: UIImage?, info:[NSObject : AnyObject]?) in
                    if fetchImgCell.assetIdentify == assetItem.localIdentifier {
                        fetchImgCell.imageView.image = resImg
                    }
                })
            }
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        let selectArray = self.getSelectedFetchArray()
        guard selectArray.count < self.maxImgCount else {
            self.showText("最多选择30张照片")
            return false
        }
        return true
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let imgCell = collectionView.cellForItemAtIndexPath(indexPath) as? DSSFetchImgCell else {
            return
        }
        
        imgCell.didSelected = true
        self.refreshSelectCount()
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        guard let imgCell = collectionView.cellForItemAtIndexPath(indexPath) as? DSSFetchImgCell else {
            return
        }
        
        imgCell.didSelected = false
        self.refreshSelectCount()
    }

    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        if let assetItem = self.getFetchItemAtIndexpath(indexPath) {
            self.cacheManger.stopCachingImagesForAssets([assetItem], targetSize: self.imageSize, contentMode: .AspectFit, options: nil)
            
        }
    }
    
    private func isSelectedAt(targetIndexpath: NSIndexPath) -> Bool {
        let selectArray = self.collectionView.indexPathsForSelectedItems()
        
        guard selectArray != nil else {
            return false
        }
        
        for indexItem in selectArray! {
            if indexItem.compare(targetIndexpath) == .OrderedSame {
                return true
            }
        }
        return false
    }
}
