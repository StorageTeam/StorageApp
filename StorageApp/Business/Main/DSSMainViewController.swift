//
//  DSSMainViewController.swift
//  StorageApp
//
//  Created by ascii on 16/7/27.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSSMainViewController: DSSBaseViewController, UIAlertViewDelegate, SlideMenuDelegate, CurrentLocationDelegate {
    private static let ALERT_VIEW_SHOW_SLIDE_MENU     : String   = "ALERT_VIEW_SHOW_SLIDE_MENU"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNaviBarItem()
        
        self.slideMenu.delegate   = self
        self.navigationItem.title = "FIRST LINK"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
    
    // MARK: - CurrentLocationDelegate
    
    func didClickChangeLocation(curLocation: String?) {
        if let text = curLocation {
            var dataSource = [DSSSupplierModel]()
            var model: DSSSupplierModel! = nil
            for idx in 0...10 {
                model = DSSSupplierModel.init()
                model.itemID = Int64.init(idx)
                model.name = "美国Wal-Mart Wakmart大厦" + String.init(idx)
                model.isSelected = false
                
                if idx == 4 {
                    model.isSelected = true
                }
                
                dataSource.append(model)
            }
            
            self.locationListView.setDataSource(dataSource)
            self.showLocationListView()
        }
    }
    
    // MARK: - UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if let name = alertView.describeName {
            switch name {
            case DSSMainViewController.ALERT_VIEW_SHOW_SLIDE_MENU:
                if buttonIndex == 1 {
                    DSSAccount.logout()
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
        let editController = EditViewController.init(editType: kEditType.kEditTypeAdd, productID: nil)
        self.navigationController?.pushViewController(editController, animated: true)
    }
    
    func segmentedControlAction(sender: AnyObject) {
        // switch view show
        if(self.segmentControl.selectedSegmentIndex == 0) {
            self.curLocationView.hidden   = false
            self.scanCollectButton.hidden = false
            self.buildingView.hidden      = true
        } else if(self.segmentControl.selectedSegmentIndex == 1) {
            self.curLocationView.hidden   = true
            self.scanCollectButton.hidden = true
            self.buildingView.hidden      = false
        }
    }
    
    // MARK: - Method
    
    func configNaviBarItem() -> Void{
        self.navigationItem.leftBarButtonItem  = UIBarButtonItem.init(image: UIImage.init(named: "LeftBarIcon"), style: .Done, target: self, action: #selector(clickLeftNaviBarButton))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "RightBarIcon"), style: .Done, target: self, action: #selector(clickRightNaviBarButton))
    }
    
    func showSlideMenu() -> Void {
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
    
    func showLocationListView() -> Void {
        UIView.animateWithDuration(0.5) {
            self.locationListView.frame = self.view.bounds
        }
    }
    
    func hideLocationListView(completion: ((Bool) -> Void)?) -> Void {
        let bounds = self.view.bounds
        let frame = CGRectMake(0, CGRectGetHeight(bounds), CGRectGetWidth(bounds), CGRectGetHeight(bounds))
        UIView.animateWithDuration(0.5,
                                   animations: {
                                    self.slideMenu.frame = frame
        }) { (isFinish) in
            completion?(isFinish)
        }
    }
    
    func pushProductAddController() -> Void {
        print("pushProductAddController")
    }
    
    func pushProductListController() -> Void {
        let controller = DSSProductListController.init()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showLogoutAlert() -> Void {
        let alert = UIAlertView.init(title: "Confirm",
                                     message: "Logout?",
                                     delegate: self,
                                     cancelButtonTitle: "Cancel",
                                     otherButtonTitles: "Confirm")
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
        
        let borderWidth : CGFloat = 286
        self.bgImgView.addSubview(self.locationViewBgView)
        self.locationViewBgView.snp_makeConstraints { (make) in
            make.top.equalTo(self.segmentControl.snp_bottom).offset(55)
            make.size.equalTo(CGSizeMake(borderWidth, borderWidth))
            make.centerX.equalTo(self.bgImgView)
        }
        self.locationViewBgView.layer.cornerRadius = borderWidth/2
        
        self.locationViewBgView.addSubview(self.curLocationView)
        self.curLocationView.snp_makeConstraints { (make) in
            make.center.equalTo(self.locationViewBgView)
            make.size.equalTo(CGSizeMake(borderWidth - 20, borderWidth - 20))
        }
        self.curLocationView.layer.cornerRadius = (borderWidth - 20)/2
        
        self.bgImgView.addSubview(self.scanCollectButton)
        self.scanCollectButton.snp_makeConstraints { (make) in
            make.top.equalTo(self.curLocationView.snp_bottom).offset(45)
            make.size.equalTo(CGSizeMake(300, 45))
            make.centerX.equalTo(self.bgImgView)
        }
        
        self.bgImgView.addSubview(self.buildingView)
        self.buildingView.snp_makeConstraints { (make) in
            make.top.equalTo(self.segmentControl.snp_bottom).offset(54)
            make.size.equalTo(CGSizeMake(285, 380))
            make.centerX.equalTo(self.bgImgView)
        }
        
        self.view.addSubview(self.locationListView)
        self.locationListView.snp_makeConstraints { (make) in
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
    
    lazy var locationViewBgView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.clearColor()
        view.layer.borderWidth = 10
        view.layer.borderColor = UIColor(red: 31.0/255.0, green: 186.0/255.0, blue: 214.0/255.0, alpha: 0.4).CGColor
        return view
    }()
    
    lazy var curLocationView: DSSCurrentLocationView = {
        let view = DSSCurrentLocationView.init(frame: CGRectZero)
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
        return button
    }()
    
    lazy var buildingView: DSSBuildingImgView = {
        let view = DSSBuildingImgView.init(frame: CGRectZero)
        view.backgroundColor = UIColor.whiteColor()
        view.layer.cornerRadius = 14
        view.hidden = true
        return view
    }()
    
    lazy var locationListView: DSSSupplierListView = {
        let view = DSSSupplierListView.init(frame: CGRectZero)
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.2)
        return view
    }()
}


