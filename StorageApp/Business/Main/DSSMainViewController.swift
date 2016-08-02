//
//  DSSMainViewController.swift
//  StorageApp
//
//  Created by ascii on 16/7/27.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSSMainViewController: DSSBaseViewController, UIAlertViewDelegate, SlideMenuDelegate, CurrentSupplierDelegate, DSSDataCenterDelegate {
    private static let SUPPLIERLIST_REQUEST : Int          = 0

    private static let ALERT_VIEW_SHOW_SLIDE_MENU : String = "ALERT_VIEW_SHOW_SLIDE_MENU"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNaviBarItem()
        
        self.slideMenu.delegate   = self
        self.navigationItem.title = "FIRST LINK"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if DSSAccount.isLogin() && self.viewModel.isEmpty() {
            DSSMainViewService.requestList(DSSMainViewController.SUPPLIERLIST_REQUEST, delegate: self)
        }
    }
    
    override func configDefaultLeftBar() {

    }
    
    // MARK: - DSSDataCenterDelegate
    func networkDidResponseSuccess(identify: Int, header: DSSResponseHeader, response: [String : AnyObject], userInfo: [String : AnyObject]?) {
        if header.code == DSSResponseCode.Normal {
            if identify == DSSMainViewController.SUPPLIERLIST_REQUEST {
                let items = DSSMainViewService.parseList(response)
                
                switch identify {
                case DSSMainViewController.SUPPLIERLIST_REQUEST:
                    self.viewModel.supplierArray = items
                    self.curSupplierView.setSupplierName(self.viewModel.getSelSupplierName())
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
    
    // MARK: - SlideMenuDelegate
    
    func slideMenuClick(obj: DSSSlideMenu, event: SlideMenuEvent, userInfo: [String : AnyObject]?) {
        weak var wkSelf = self
        switch event {
        case .MenuAdd:
            self.hideSlideMenu({ (done) in
                wkSelf?.pushProductAddController()
            })
            break
        case .MenuList:
            self.hideSlideMenu({ (done) in
                wkSelf?.pushProductListController()
            })
            break
        case .MenuLogout:
            self.hideSlideMenu({ (done) in
                wkSelf?.showLogoutAlert()
            })
            break
        case .MenuClose:
            self.hideSlideMenu(nil)
            break
        }
    }
    
    // MARK: - CurrentSupplierDelegate
    
    func didClickChangeSupplier(curSupplier: String?) {
//        if let text = curSupplier {
            self.supplierListView.setDataSource(self.viewModel.supplierArray)
            self.showSupplierListView()
//        }
    }
    
    // MARK: - UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if let name = alertView.describeName {
            switch name {
            case DSSMainViewController.ALERT_VIEW_SHOW_SLIDE_MENU:
                if buttonIndex == 1 {
                    DSSAccount.logout()
                    self.viewModel.clearData()
                    self.presentLoginController()
                }
            default:
                break
            }
        }
    }
    
    // MARK: - Action
    
    func clickLeftNaviBarButton(sender: UIButton) {
        if DSSAccount.isLogin() {
            self.showSlideMenu()
        } else {
            self.presentLoginController()
        }
    }
    
    func clickRightNaviBarButton(sender: UIButton) {
        self.pushProductAddController()
    }
    
    func segmentedControlAction(sender: AnyObject) {
        // switch view show
        if(self.segmentControl.selectedSegmentIndex == 0) {
            self.curSupplierView.hidden    = false
            self.supplierViewBgView.hidden = false
            self.scanCollectButton.hidden  = false
            self.buildingView.hidden       = true
        } else if(self.segmentControl.selectedSegmentIndex == 1) {
            self.curSupplierView.hidden    = true
            self.supplierViewBgView.hidden = true
            self.scanCollectButton.hidden  = true
            self.buildingView.hidden       = false
        }
    }
    
    func clickHideSupplierListButton(sender: UIButton) -> Void {
        if let itemID = self.viewModel.getSelSupplierID() {
            DSSMainViewService.modifyDefaultSupplier(-1, supplierID: itemID, delegate: self)
        }
        self.curSupplierView.setSupplierName(self.viewModel.getSelSupplierName())
        
        self.hideSupplierListView(nil)
    }
    
    // MARK: - Method
    
    func configNaviBarItem() -> Void{
        self.navigationItem.leftBarButtonItem  = UIBarButtonItem.init(image: UIImage.init(named: "LeftBarIcon"), style: .Done, target: self, action: #selector(clickLeftNaviBarButton))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "RightBarIcon"), style: .Done, target: self, action: #selector(clickRightNaviBarButton))
    }
    
    func showSlideMenu() -> Void {
        self.slideMenu.setAccount(DSSAccount.getHeadURL(), nickname: DSSAccount.getNickname())
        UIView.animateWithDuration(0.5) {
            self.slideMenu.frame = UIScreen.mainScreen().bounds
        }
    }
    
    func hideSlideMenu(completion: ((Bool) -> Void)?) -> Void {
        let bounds = self.slideMenu.bounds
        let frame = CGRectMake(-CGRectGetWidth(bounds), 0, CGRectGetWidth(bounds), CGRectGetHeight(bounds))
        UIView.animateWithDuration(0.5,
                                   animations: {
                                    self.slideMenu.frame = frame
        }) { (isFinish) in
            completion?(isFinish)
        }
    }
    
    func showSupplierListView() -> Void {
        UIView.animateWithDuration(0.5) {
            self.supplierListView.frame = self.view.bounds
        }
    }
    
    func hideSupplierListView(completion: ((Bool) -> Void)?) -> Void {
        let bounds = self.view.bounds
        let frame = CGRectMake(0, CGRectGetHeight(bounds), CGRectGetWidth(bounds), CGRectGetHeight(bounds))
        UIView.animateWithDuration(0.5,
                                   animations: {
                                    self.supplierListView.frame = frame
        }) { (isFinish) in
            completion?(isFinish)
        }
    }
    
    func pushProductAddController() -> Void {
        weak var wkSelf = self
        let scanController = FKScanController.init(supplierID: self.viewModel.getSelSupplierID(), finish: { (resStr) in
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
        editItem.supplierId = self.viewModel.getSelSupplierID()
        editItem.address    = self.viewModel.getSelSupplierName()
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
    
    func showLogoutAlert() -> Void {
        let alert = UIAlertView.init(title: "",
                                     message: "是否确定退出登录?",
                                     delegate: self,
                                     cancelButtonTitle: "取消",
                                     otherButtonTitles: "确定")
        alert.describeName = DSSMainViewController.ALERT_VIEW_SHOW_SLIDE_MENU
        alert.show()

    }
    
    // MARK: - loadView
    
    override func loadView() {
        super.loadView()
        
        UIApplication.sharedApplication().keyWindow!.addSubview(self.slideMenu)
        
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
        self.bgImgView.addSubview(self.supplierViewBgView)
        self.supplierViewBgView.snp_makeConstraints { (make) in
            make.top.equalTo(self.segmentControl.snp_bottom).offset(offset)
            make.size.equalTo(CGSizeMake(borderWidth, borderWidth))
            make.centerX.equalTo(self.bgImgView)
        }
        self.supplierViewBgView.layer.cornerRadius = borderWidth/2
        
        self.supplierViewBgView.addSubview(self.curSupplierView)
        self.curSupplierView.snp_makeConstraints { (make) in
            make.center.equalTo(self.supplierViewBgView)
            make.size.equalTo(CGSizeMake(borderWidth - 20, borderWidth - 20))
        }
        self.curSupplierView.layer.cornerRadius = (borderWidth - 20)/2
        
        offset = (DSSConst.IS_iPhone4() ? 40 : 55)
        self.bgImgView.addSubview(self.scanCollectButton)
        self.scanCollectButton.snp_makeConstraints { (make) in
            make.top.equalTo(self.curSupplierView.snp_bottom).offset(offset)
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
        
        self.view.addSubview(self.supplierListView)
        self.supplierListView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view.snp_bottom)
            make.size.equalTo(CGSizeMake(CGRectGetWidth(UIScreen.mainScreen().bounds), CGRectGetHeight(UIScreen.mainScreen().bounds) - 64))
        }
    }
    
    // MARK: - Property
    
    lazy var slideMenu: DSSSlideMenu = {
        let bounds = UIScreen.mainScreen().bounds
        let frame = CGRectMake(-CGRectGetWidth(bounds), 0, CGRectGetWidth(bounds), CGRectGetHeight(bounds))
        let menu = DSSSlideMenu.init(frame: frame)
        menu.backgroundColor = UIColor.clearColor()
        return menu
    }()
    
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
    
    lazy var supplierViewBgView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.clearColor()
        view.layer.borderWidth = 10
        view.layer.borderColor = UIColor(red: 31.0/255.0, green: 186.0/255.0, blue: 214.0/255.0, alpha: 0.4).CGColor
        return view
    }()
    
    lazy var curSupplierView: DSSCurrentSupplierView = {
        let view = DSSCurrentSupplierView.init(frame: CGRectZero)
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
        view.layer.cornerRadius = 14
        view.hidden = true
        return view
    }()
    
    lazy var supplierListView: DSSSupplierListView = {
        let view = DSSSupplierListView.init(frame: CGRectZero)
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.2)
        view.listHeaderView.actionButton.addTarget(self, action: #selector(clickHideSupplierListButton), forControlEvents: .TouchUpInside)
        return view
    }()
    
    lazy var viewModel: DSSMainViewModel = {
        let viewModel = DSSMainViewModel.init()
        return viewModel
    }()
}



