//
//  DSSMainViewController.swift
//  StorageApp
//
//  Created by ascii on 16/7/27.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSSMainViewController: DSSBaseViewController, UIAlertViewDelegate, SlideMenuDelegate {
    private static let ALERT_VIEW_SHOW_SLIDE_MENU     : String   = "ALERT_VIEW_SHOW_SLIDE_MENU"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.slideMenu.delegate = self
        self.navigationItem.title = "FIRST LINK"
        self.configNaviBarItem()
    }
    
    // MARK: - SlideMenuDelegate
    
    func slideMenuClick(obj: DSSSlideMenu, event: SlideMenuEvent, userInfo: [String : AnyObject]?) {
        print(event)
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
    
    // MARK: - Action
    
    func clickLeftNaviBarButton(sender: UIButton) {
        if DSSAccount.isLogin() {
//            let alert = UIAlertView.init(title: "Confirm",
//                                         message: "Logout?",
//                                         delegate: self,
//                                         cancelButtonTitle: "Cancel",
//                                         otherButtonTitles: "Confirm")
//            alert.describeName = DSSMainViewController.ALERT_VIEW_SHOW_SLIDE_MENU
//            alert.show()
            self.showSlideMenu()
        } else {
            self.presentLoginController()
        }
    }
    
    func clickRightNaviBarButton(sender: UIButton) {
        let editController = EditViewController.init(editType: kEditType.kEditTypeAdd, productID: nil)
        self.navigationController?.pushViewController(editController, animated: true)
    }
    
    // MARK: - loadView
    
    override func loadView() {
        super.loadView()
        
        UIApplication.sharedApplication().keyWindow!.addSubview(self.slideMenu)
    }
    
    // MARK: - Property
    
    lazy var slideMenu: DSSSlideMenu = {
        var bounds = UIScreen.mainScreen().bounds
        let frame = CGRectMake(-CGRectGetWidth(bounds), 0, CGRectGetWidth(bounds), CGRectGetHeight(bounds))
        let menu = DSSSlideMenu.init(frame: frame)
        menu.backgroundColor = UIColor.clearColor()
        return menu
    }()
}



