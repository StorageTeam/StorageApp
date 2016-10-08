//
//  DSMainViewController.swift
//  StorageApp
//
//  Created by ascii on 16/7/27.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSMainViewController: DSBaseViewController, CurrentShopDelegate, DSDataCenterDelegate {
    private static let SHOP_LIST_REQUEST: Int = 1
    private static let RECEIVE_ORDER_STATUS_REQUEST: Int = 2
    private static let PURCHASE_RECORDS_REQUEST: Int = 3
    
    private static let NOTIFICATION_REFRESH_INTERVAL: Double = 10.0
    
    private var purchaseRecordsRequestTimer: NSTimer?
    private var purchaseRecordsDisplayTimer: NSTimer?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.purchaseRecordsRequestTimer = nil
        self.purchaseRecordsDisplayTimer = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.purchaseRecordsRequestTimer?.invalidate()
        self.purchaseRecordsDisplayTimer?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configRightNaviBarItem()
        
        self.view.backgroundColor = UIColor.init(rgb: 0xffffff)
        self.buyMissionController.naviController = self.navigationController
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configBarTitleView()
        
        self.requestReceiveOrderStatus()
        self.requestPurchaseRecords()
        self.requestShopList()
    }
    
    // MARK: - Request
    
    func requestReceiveOrderStatus() -> Void {
        if DSAccount.isLogin() {
            DSMainService.requestReceiveOrderStatus(DSMainViewController.RECEIVE_ORDER_STATUS_REQUEST, delegate: self)
        }
    }
    
    func requestPurchaseRecords() -> Void {
        if DSAccount.isLogin() {
            DSMainService.requestPurchaseRecords(DSMainViewController.PURCHASE_RECORDS_REQUEST, delegate: self)
        }
    }
    
    func requestShopList() -> Void {
        if DSAccount.isLogin() && self.viewModel.isEmpty() {
            DSMainService.requestShopList(DSMainViewController.SHOP_LIST_REQUEST, delegate: self)
        }
    }
    
    // MARK: - DSDataCenterDelegate
    func networkDidResponseSuccess(identify: Int, header: DSResponseHeader, response: [String : AnyObject], userInfo: [String : AnyObject]?) {
        if header.code == DSResponseCode.Normal {
            if identify == DSMainViewController.SHOP_LIST_REQUEST {
                let items = DSMainService.parseShopList(response)
                
                switch identify {
                case DSMainViewController.SHOP_LIST_REQUEST:
                    self.viewModel.shopListArray = items
                    self.curShopView.setShopName(self.viewModel.getSelShopName())
                    break
                default:
                    break
                }
            } else if (identify == DSMainViewController.RECEIVE_ORDER_STATUS_REQUEST) {
                self.setReceiveOrderStatus(DSMainService.parseOrderStatus(response))
            } else if (identify == DSMainViewController.PURCHASE_RECORDS_REQUEST) {
                self.viewModel.purchaseRecordArray = DSMainService.parsePurchaseRecords(response)
                self.displayPurchaseRecord()
            }
        } else if header.code == DSResponseCode.AccessError {
            self.presentStartController()
        }
    }
    
    func networkDidResponseError(identify: Int, header: DSResponseHeader?, error: String?, userInfo: [String : AnyObject]?) {
        if let errorString = error {
            self.showText(errorString)
        }
    }
    
    // MARK: - CurrentShopDelegate
    
    func didClickChangeShop(curShop: String?) {
        self.shopListView.setDataSource(self.viewModel.shopListArray)
        self.showshopListView()
    }
    
    // MARK: - Action
    
    func clickScanCollectButton(sender: UIButton) {
        weak var wkSelf = self
        let scanController = FKScanController.init(supplierID: self.viewModel.getSelShopID(), finish: { (qrCode) in
            let takeProductPhotoController = DSTakePhotoController.init(title: "拍照", takeDonePicture: { (productImages:[UIImage]) in
                let takePricePhotoController = DSTakePhotoController.init(title: "拍照", takeDonePicture: { (priceImages:[UIImage]) in
                    self.pushProductEditController(qrCode, productImages: productImages, priceImages: priceImages)
                    }, cancel: {
                        self.pushProductEditController(qrCode, productImages: productImages, priceImages: nil)
                })
                takePricePhotoController.stepTipLabel.text = "    第2步：请拍摄价签照片"
                takePricePhotoController.actionView.finishBtn.setTitle("完成", forState: .Normal)
                takePricePhotoController.hidesBottomBarWhenPushed = true
                wkSelf?.replaceLastController(takePricePhotoController)
                
                }, cancel: {
                    self.pushProductEditController(qrCode, productImages: nil, priceImages: nil)
            })
            takeProductPhotoController.stepTipLabel.text = "    第1步：请拍摄商品照片"
            takeProductPhotoController.actionView.finishBtn.setTitle("下一步", forState: .Normal)
            takeProductPhotoController.hidesBottomBarWhenPushed = true
            wkSelf?.replaceLastController(takeProductPhotoController)
        })
        scanController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(scanController, animated: true)
    }
    
    func pushProductEditController(qrCode: String, productImages: [UIImage]?, priceImages: [UIImage]?) {
        let item = EditSourceItem.init()
        item.shopId     = self.viewModel.getSelShopID()
        item.address    = self.viewModel.getSelShopName()
        item.upc        = qrCode
        
        let editController = EditViewController.init(source: item, productImages: productImages, priceImages: priceImages)
        editController.hidesBottomBarWhenPushed = true
        
        self.replaceLastController(editController)
    }
    
    func replaceLastController(pushController: UIViewController) {
        var controllers = self.navigationController?.viewControllers
        guard controllers?.count >= 2 else {
            return
        }
        controllers?.removeLast()
        controllers?.append(pushController)
        self.navigationController?.setViewControllers(controllers!, animated: true)
    }
    
    func clickSegmentedControlAction(sender: AnyObject) {
        // switch view show
        if(self.segmentControl.selectedSegmentIndex == 0) {
            self.buyMissionController.view.hidden       = true
        } else if(self.segmentControl.selectedSegmentIndex == 1) {
            self.buyMissionController.view.hidden       = false
        }
    }
    
    func clickHideShopListButton(sender: UIButton) -> Void {
        if let itemID = self.viewModel.getSelShopID() {
            DSMainService.modifyDefaultShop(-1, shopID: itemID, delegate: self)
        }
        self.curShopView.setShopName(self.viewModel.getSelShopName())
        
        self.hideshopListView(nil)
    }
    
    func clickSwitchAction(sender: UISwitch) {
        DSMainService.modifyReceiveOrder(0, isReceive: sender.on, delegate: self);
        self.setReceiveOrderStatus(sender.on)
    }
    
    // MARK: - Method
    
    private func configRightNaviBarItem() -> Void {
        let rightBarItem = UIBarButtonItem.init(customView: self.statusLabel)
        
        let switchContainer = UIView.init(frame: CGRectMake(0, 0, 44, CGRectGetHeight((self.navigationController?.navigationBar.frame)!)))
        self.statusSwitch.center = CGPointMake(switchContainer.bounds.size.width/2, switchContainer.bounds.size.height/2)
        switchContainer.addSubview(self.statusSwitch)
        let leftBarItem = UIBarButtonItem.init(customView: switchContainer)
        
        let fixedSpaceBarItem = UIBarButtonItem.init(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        fixedSpaceBarItem.width = -14;
        
        self.navigationItem.rightBarButtonItems = [fixedSpaceBarItem, leftBarItem, rightBarItem]
    }
    
    private func setReceiveOrderStatus(isOn: Bool) {
        if isOn {
            self.statusSwitch.on = true
            self.statusLabel.text = "接单"
        } else {
            self.statusSwitch.on = false
            self.statusLabel.text = "不接单"
        }
        self.buyMissionController.refreshEmptyView(isOn)
    }
    
    private func configBarTitleView() -> Void {
        if DSAccount.getRoleType().isDeliverAble() {
            self.segmentControl.frame = CGRectMake(0, 0, 160, 26)
            self.navigationItem.titleView = self.segmentControl
        } else {
            self.navigationItem.title = "FIRST LINK"
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(18)]
        }
    }
    
    private func showshopListView() -> Void {
        UIView.animateWithDuration(0.3) {
            self.shopListView.frame = self.view.bounds
        }
    }
    
    func hideshopListView(completion: ((Bool) -> Void)?) -> Void {
        let bounds = self.view.bounds
        let frame = CGRectMake(0, CGRectGetHeight(bounds), CGRectGetWidth(bounds), CGRectGetHeight(bounds))
        UIView.animateWithDuration(0.3,
                                   animations: {
                                    self.shopListView.frame = frame
        }) { (isFinish) in
            completion?(isFinish)
        }
    }
    
    func displayPurchaseRecord() -> Void {
        if let record = self.viewModel.popFirstPurchaseRecord() {
            self.notificationView.textLabel.text = record
            
            self.purchaseRecordsDisplayTimer = NSTimer.scheduledTimerWithTimeInterval(DSMainViewController.NOTIFICATION_REFRESH_INTERVAL,
                                                                                      target: self,
                                                                                      selector: #selector(self.displayPurchaseRecord),
                                                                                      userInfo: nil,
                                                                                      repeats: false)
        } else {
            self.purchaseRecordsRequestTimer = NSTimer.scheduledTimerWithTimeInterval(DSMainViewController.NOTIFICATION_REFRESH_INTERVAL,
                                                                                      target: self,
                                                                                      selector: #selector(self.requestPurchaseRecords),
                                                                                      userInfo: nil,
                                                                                      repeats: false)
        }
    }
    
    // MARK: - loadView
    
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(self.notificationView)
        self.notificationView.snp_makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(50)
        }
        
        self.view.addSubview(self.graySeperatorView)
        self.graySeperatorView.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.notificationView.snp_bottom)
            make.height.equalTo(10)
        }
        
        let borderWidth : CGFloat = (DSConst.IS_Screen_320() ? 240 : 286)
        self.view.addSubview(self.curShopBgView)
        self.curShopBgView.snp_makeConstraints { (make) in
            make.top.equalTo(self.graySeperatorView.snp_bottom).offset(30)
            make.size.equalTo(CGSizeMake(borderWidth, borderWidth))
            make.centerX.equalTo(self.view)
        }
        
        self.curShopBgView.addSubview(self.curShopView)
        self.curShopView.snp_makeConstraints { (make) in
            make.center.equalTo(self.curShopBgView)
            make.size.equalTo(CGSizeMake(borderWidth - 20, borderWidth - 20))
        }
        self.curShopView.layer.cornerRadius = (borderWidth - 20)/2

        self.view.addSubview(self.tipLabel)
        self.tipLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.curShopBgView.snp_bottom).offset(12)
            make.centerX.equalTo(self.view)
        }
        
        self.view.addSubview(self.scanCollectButton)
        self.scanCollectButton.snp_makeConstraints { (make) in
            make.top.equalTo(self.tipLabel.snp_bottom).offset(12)
            make.left.equalTo(self.view).offset(44)
            make.right.equalTo(self.view).offset(-44)
            make.height.equalTo(45)
        }
        
        self.view.addSubview(self.photoCollectButton)
        self.photoCollectButton.snp_makeConstraints { (make) in
            make.top.equalTo(self.scanCollectButton.snp_bottom).offset(10)
            make.left.equalTo(self.view).offset(44)
            make.right.equalTo(self.view).offset(-44)
            make.height.equalTo(45)
        }

        self.view.addSubview(self.buyMissionController.view)
        self.buyMissionController.view.snp_makeConstraints { (make) in
            make.top.equalTo(self.graySeperatorView.snp_bottom)
            make.left.right.bottom.equalTo(self.view)
        }
        
        self.view.addSubview(self.shopListView)
        self.shopListView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view.snp_bottom)
            make.size.equalTo(CGSizeMake(CGRectGetWidth(UIScreen.mainScreen().bounds), CGRectGetHeight(UIScreen.mainScreen().bounds) - 64))
        }
    }
    
    // MARK: - Property
    
    lazy var segmentControl: UISegmentedControl = {
        let control = UISegmentedControl.init(items: ["商品收集", "商品采购"])
        control.selectedSegmentIndex = 0
        control.clipsToBounds      = true
        control.layer.cornerRadius = 2
        control.layer.borderWidth  = 1
        control.layer.borderColor  = UIColor.init(rgb: 0x1fbad6).CGColor
        control.tintColor          = UIColor.init(rgb: 0x1fbad6)
        
        control.setTitleTextAttributes([NSForegroundColorAttributeName  : UIColor.init(rgb: 0xffffff)
                                      , NSFontAttributeName             : UIFont.systemFontOfSize(12)],
                                       forState: UIControlState.Selected)
        control.setTitleTextAttributes([NSForegroundColorAttributeName  : UIColor.init(rgb: 0x1fbad6)
                                      , NSFontAttributeName             : UIFont.systemFontOfSize(12)],
                                       forState: UIControlState.Normal)
        
        control.addTarget(self, action: #selector(self.clickSegmentedControlAction), forControlEvents:.ValueChanged)
        return control
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel.init()
        label.text = "不接单"
        label.frame = CGRectMake(0, 0, 46, CGRectGetHeight((self.navigationController?.navigationBar.frame)!))
        label.textAlignment = .Right
        label.font = UIFont.systemFontOfSize(14)
        label.textColor = UIColor.init(rgb: 0x1fbad6)
        return label
    }()
    
    lazy var statusSwitch: UISwitch = {
        let switchBtn = UISwitch.init()
        switchBtn.transform = CGAffineTransformMakeScale(0.75, 0.75)
        switchBtn.addTarget(self, action: #selector(self.clickSwitchAction), forControlEvents: .ValueChanged)
        return switchBtn
    }()
    
    lazy var notificationView: DSNotificationView = {
        let view = DSNotificationView.init()
        view.backgroundColor = UIColor.whiteColor()
        view.textLabel.text = "正在向服务器请求数据..."
        return view
    }()
    
    lazy var graySeperatorView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.init(rgb: 0xf4f4f4)
        return view
    }()
    
    lazy var curShopBgView: UIView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "curShopListBgIcon"))
        imgView.userInteractionEnabled = true
        return imgView
    }()
    
    lazy var curShopView: DSCurrentShopView = {
        let view = DSCurrentShopView.init(frame: CGRectZero)
        view.backgroundColor = UIColor.whiteColor()
        view.delegate = self
        return view
    }()
    
    lazy var tipLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x666666)
        label.font = UIFont.systemFontOfSize(12)
        label.text = "当您录入的商品产生订单时\n将优先获得采购任务"
        label.textAlignment = NSTextAlignment.Center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var scanCollectButton: UIButton = {
        var button = UIButton.init(type: UIButtonType.Custom)
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        button.setTitle("  扫码采集", forState: .Normal)
        button.layer.cornerRadius = 6
        button.backgroundColor = UIColor.init(rgb: 0x1fbad6)
        button.setImage(UIImage.init(named: "product_collect_icon"), forState: .Normal)
        button.addTarget(self, action: #selector(self.clickScanCollectButton), forControlEvents: .TouchUpInside)
        return button
    }()
    
    lazy var photoCollectButton: UIButton = {
        var button = UIButton.init(type: UIButtonType.Custom)
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        button.setTitle("  相册采集", forState: .Normal)
        button.setTitleColor(UIColor.init(rgb: 0x1fbad6), forState: .Normal)
        button.layer.cornerRadius = 6
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.init(rgb: 0x1fbad6).CGColor
        button.setImage(UIImage.init(named: "photo_collect_icon"), forState: .Normal)
        return button
    }()
    
    lazy var buyMissionController: DSBuyMissionController = {
        let controller = DSBuyMissionController.init()
        controller.view.hidden = true
        return controller
    }()
    
    lazy var shopListView: DSShopListView = {
        let view = DSShopListView.init(frame: CGRectZero)
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.2)
        view.listHeaderView.actionButton.addTarget(self, action: #selector(self.clickHideShopListButton), forControlEvents: .TouchUpInside)
        return view
    }()
    
    lazy var viewModel: DSShopViewModel = {
        let viewModel = DSShopViewModel.init()
        return viewModel
    }()
}



