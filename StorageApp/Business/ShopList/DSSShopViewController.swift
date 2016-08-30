//
//  DSSShopViewController.swift
//  StorageApp
//
//  Created by ascii on 16/7/27.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSSShopViewController: DSSBaseViewController, CurrentShopDelegate, DSSDataCenterDelegate {
    private static let SHOPLIST_REQUEST : Int          = 0
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNaviBarItem()
        
        self.navigationItem.title = "FIRST LINK"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(18)]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if DSSAccount.isLogin() && self.viewModel.isEmpty() {
            DSSShopService.requestList(DSSShopViewController.SHOPLIST_REQUEST, delegate: self)
        }
    }
    
    // MARK: - DSSDataCenterDelegate
    func networkDidResponseSuccess(identify: Int, header: DSSResponseHeader, response: [String : AnyObject], userInfo: [String : AnyObject]?) {
        if header.code == DSSResponseCode.Normal {
            if identify == DSSShopViewController.SHOPLIST_REQUEST {
                let items = DSSShopService.parseList(response)
                
                switch identify {
                case DSSShopViewController.SHOPLIST_REQUEST:
                    self.viewModel.shopArray = items
                    self.curShopView.setShopName(self.viewModel.getSelShopName())
                    break
                default:
                    break
                }
            }
        } else if header.code == DSSResponseCode.AccessError {
            self.presentLoginController()
        }
    }
    
    func networkDidResponseError(identify: Int, header: DSSResponseHeader?, error: String?, userInfo: [String : AnyObject]?) {
        if let errorString = error {
            self.showText(errorString)
        }
    }
    
    // MARK: - CurrentShopDelegate
    
    func didClickChangeShop(curShop: String?) {
        self.shopListView.setDataSource(self.viewModel.shopArray)
        self.showshopListView()
    }
    
    // MARK: - Action
    
    func clickRightNaviBarButton(sender: UIButton) {
        self.pushProductAddController()
    }
    
    func segmentedControlAction(sender: AnyObject) {
        // switch view show
        if(self.segmentControl.selectedSegmentIndex == 0) {
            self.curShopView.hidden    = false
            self.shopViewBgView.hidden = false
            self.scanCollectButton.hidden  = false
            self.buildingView.hidden       = true
        } else if(self.segmentControl.selectedSegmentIndex == 1) {
            self.curShopView.hidden    = true
            self.shopViewBgView.hidden = true
            self.scanCollectButton.hidden  = true
            self.buildingView.hidden       = false
        }
    }
    
    func clickHideShopListButton(sender: UIButton) -> Void {
        if let itemID = self.viewModel.getSelShopID() {
            DSSShopService.modifyDefaultShop(-1, shopID: itemID, delegate: self)
        }
        self.curShopView.setShopName(self.viewModel.getSelShopName())
        
        self.hideshopListView(nil)
    }
    
    // MARK: - Method
    
    func configNaviBarItem() -> Void {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "RightBarIcon"), style: .Done, target: self, action: #selector(clickRightNaviBarButton))
    }
    
    func showshopListView() -> Void {
        UIView.animateWithDuration(0.5) {
            self.shopListView.frame = self.view.bounds
        }
    }
    
    func hideshopListView(completion: ((Bool) -> Void)?) -> Void {
        let bounds = self.view.bounds
        let frame = CGRectMake(0, CGRectGetHeight(bounds), CGRectGetWidth(bounds), CGRectGetHeight(bounds))
        UIView.animateWithDuration(0.5,
                                   animations: {
                                    self.shopListView.frame = frame
        }) { (isFinish) in
            completion?(isFinish)
        }
    }
    
    func pushProductAddController() -> Void {
        weak var wkSelf = self
        let scanController = FKScanController.init(supplierID: self.viewModel.getSelShopID(), finish: { (resStr) in
            let takePhotoController = DSSTakePhotoController.init(title: "拍照", takeDonePicture: { (images:[UIImage]) in
                
                    self.photoDoneToPushEdit(resStr, images: images)
                }, cancel: {
                    
                self.photoDoneToPushEdit(resStr, images: nil)
            })
            takePhotoController.hidesBottomBarWhenPushed = true
            wkSelf?.removeLastPushNew(takePhotoController)
        })
        scanController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(scanController, animated: true)
    }
    
    func photoDoneToPushEdit(scanStr: String, images: [UIImage]?) {
        
        let editItem = EditSourceItem.init()
        editItem.shopId     = self.viewModel.getSelShopID()
        editItem.address    = self.viewModel.getSelShopName()
        editItem.upc        = scanStr
        
        let editController = EditViewController.init(source: editItem, images: images)
        editController.hidesBottomBarWhenPushed = true
        
       self.removeLastPushNew(editController)
    }
    
    func removeLastPushNew(pushController: UIViewController) {
        var controllers = self.navigationController?.viewControllers
        guard controllers?.count >= 2 else {
            return
        }
        controllers?.removeLast()
        controllers?.append(pushController)
        self.navigationController?.setViewControllers(controllers!, animated: true)
    }
    
    func pushProductListController() -> Void {
        let controller = DSSProductListController.init()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    // MARK: - loadView
    
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(self.bgImgView)
        self.bgImgView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        self.bgImgView.addSubview(self.segmentControl)
        self.segmentControl.snp_makeConstraints { (make) in
            make.top.equalTo(self.bgImgView).offset(25)
            make.size.equalTo(CGSizeMake(216, 28))
            make.centerX.equalTo(self.bgImgView)
        }
        
        let borderWidth : CGFloat = (DSSConst.IS_iPhone4() ? 240 : 286)
        var offset = (DSSConst.IS_iPhone4() ? 30 : 50)
        self.bgImgView.addSubview(self.shopViewBgView)
        self.shopViewBgView.snp_makeConstraints { (make) in
            make.top.equalTo(self.segmentControl.snp_bottom).offset(offset)
            make.size.equalTo(CGSizeMake(borderWidth, borderWidth))
            make.centerX.equalTo(self.bgImgView)
        }
        self.shopViewBgView.layer.cornerRadius = borderWidth/2
        
        self.shopViewBgView.addSubview(self.curShopView)
        self.curShopView.snp_makeConstraints { (make) in
            make.center.equalTo(self.shopViewBgView)
            make.size.equalTo(CGSizeMake(borderWidth - 20, borderWidth - 20))
        }
        self.curShopView.layer.cornerRadius = (borderWidth - 20)/2
        
        offset = (DSSConst.IS_iPhone4() ? 40 : 55)
        self.bgImgView.addSubview(self.scanCollectButton)
        self.scanCollectButton.snp_makeConstraints { (make) in
            make.top.equalTo(self.curShopView.snp_bottom).offset(offset)
            make.size.equalTo(CGSizeMake(280, 45))
            make.centerX.equalTo(self.bgImgView)
        }
        
        offset = (DSSConst.IS_iPhone4() ? 35 : 50)
        let size = (DSSConst.IS_iPhone4() ? CGSizeMake(260, 320) : CGSizeMake(260, 340))
        self.bgImgView.addSubview(self.buildingView)
        self.buildingView.snp_makeConstraints { (make) in
            make.top.equalTo(self.segmentControl.snp_bottom).offset(offset)
            make.size.equalTo(size)
            make.centerX.equalTo(self.bgImgView)
        }
        
        self.view.addSubview(self.shopListView)
        self.shopListView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view.snp_bottom)
            make.size.equalTo(CGSizeMake(CGRectGetWidth(UIScreen.mainScreen().bounds), CGRectGetHeight(UIScreen.mainScreen().bounds) - 64))
        }
    }
    
    // MARK: - Property
    
    lazy var bgImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.userInteractionEnabled = true
        imgView.image = DSSImage.dss_bgImage(CGSizeMake(CGRectGetWidth(UIScreen.mainScreen().bounds)
            , CGRectGetHeight(UIScreen.mainScreen().bounds) - 64))
        return imgView
    }()
    
    lazy var segmentControl: UISegmentedControl = {
        let control = UISegmentedControl.init(items: ["商品收集", "商品采购"])
        control.selectedSegmentIndex = 0
        control.clipsToBounds      = true
        control.layer.cornerRadius = 14
        control.layer.borderWidth  = 1
        control.layer.borderColor  = UIColor.init(rgb: 0x383a4a).CGColor
        control.tintColor          = UIColor(red: 31.0/255.0, green: 186.0/255.0, blue: 214.0/255.0, alpha: 0.5)
        
        control.setTitleTextAttributes([NSForegroundColorAttributeName  : UIColor.init(rgb: 0xdddddd)
                                      , NSFontAttributeName             : UIFont.systemFontOfSize(14)],
                                       forState: UIControlState.Selected)
        control.setTitleTextAttributes([NSForegroundColorAttributeName  : UIColor.init(rgb: 0xaaaaaa)
                                      , NSFontAttributeName             : UIFont.systemFontOfSize(14)],
                                       forState: UIControlState.Normal)
        
        control.addTarget(self, action: #selector(segmentedControlAction), forControlEvents:.ValueChanged)
        return control
    }()
    
    lazy var shopViewBgView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.clearColor()
        view.layer.borderWidth = 10
        view.layer.borderColor = UIColor(red: 31.0/255.0, green: 186.0/255.0, blue: 214.0/255.0, alpha: 0.4).CGColor
        return view
    }()
    
    lazy var curShopView: DSSCurrentShopView = {
        let view = DSSCurrentShopView.init(frame: CGRectZero)
        view.backgroundColor = UIColor.whiteColor()
        view.delegate = self
        return view
    }()
    
    lazy var scanCollectButton: UIButton = {
        var button = UIButton.init(type: UIButtonType.Custom)
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        button.setTitle(" 扫码采集", forState: .Normal)
        button.titleLabel?.textColor = UIColor.init(rgb: 0xffffff)
        button.layer.cornerRadius = 6
        button.backgroundColor = UIColor(red: 31.0/255.0, green: 186.0/255.0, blue: 214.0/255.0, alpha: 0.9)
        button.setImage(UIImage.init(named: "product_collect_icon"), forState: .Normal)
        button.addTarget(self, action: #selector(self.clickRightNaviBarButton), forControlEvents: .TouchUpInside)
        return button
    }()
    
    lazy var buildingView: DSSBuildingImgView = {
        let view = DSSBuildingImgView.init(frame: CGRectZero)
        view.backgroundColor = UIColor.whiteColor()
        view.layer.cornerRadius = 10
        view.hidden = true
        return view
    }()
    
    lazy var shopListView: DSSShopListView = {
        let view = DSSShopListView.init(frame: CGRectZero)
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.2)
        view.listHeaderView.actionButton.addTarget(self, action: #selector(clickHideShopListButton), forControlEvents: .TouchUpInside)
        return view
    }()
    
    lazy var viewModel: DSSShopViewModel = {
        let viewModel = DSSShopViewModel.init()
        return viewModel
    }()
}



