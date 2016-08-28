//
//  DSSNavigationController.swift
//  StorageApp
//
//  Created by ascii on 16/8/25.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSSNavigationController: UINavigationController, SlideMenuDelegate, UIAlertViewDelegate {
    private static let ALERT_VIEW_SHOW_SLIDE_MENU : String = "ALERT_VIEW_SHOW_SLIDE_MENU"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let controller = DSSShopViewController.init()
        self.viewControllers = [controller]
        
        self.slideMenu.delegate   = self
        UIApplication.sharedApplication().windows.first?.addSubview(self.slideMenu)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - SlideMenuDelegate
    
    func slideMenuClick(obj: DSSSlideMenu, event: SlideMenuEvent, userInfo: [String : AnyObject]?) {
        weak var wkSelf = self
        switch event {
        case .MenuProductAdd:
            self.hideSlideMenu({ (done) in
//                wkSelf?.pushProductAddController()
            })
            break
        case .MenuProductList:
            self.hideSlideMenu({ (done) in
//                wkSelf?.pushProductListController()
            })
            break
        case .MenuLogout:
            self.hideSlideMenu({ (done) in
                wkSelf?.showLogoutAlert()
            })
            break
        case .MenuDeliverTask:
            let controller = DSSDeliverMissionController.init()
            self.viewControllers = [controller]
            break;
        case .MenuClose:
            self.hideSlideMenu(nil)
            break
        default:
            break
        }
    }
    
    // MARK: - UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if let name = alertView.describeName {
            switch name {
            case DSSNavigationController.ALERT_VIEW_SHOW_SLIDE_MENU:
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
    
    // MARK: - Method
    
    func showSlideMenu() -> Void {
        self.slideMenu.setAccount(DSSAccount.getHeadURL(), nickname: DSSAccount.getNickname(), roleType: DSSAccount.getRoleType())
        UIView.animateWithDuration(0.5) {
            UIApplication.sharedApplication().windows.first?.bringSubviewToFront(self.slideMenu)
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
    
    func showLogoutAlert() -> Void {
        let alert = UIAlertView.init(title: "",
                                     message: "是否确定退出登录?",
                                     delegate: self,
                                     cancelButtonTitle: "取消",
                                     otherButtonTitles: "确定")
        alert.describeName = DSSNavigationController.ALERT_VIEW_SHOW_SLIDE_MENU
        alert.show()
    }
    
    func presentLoginController() -> Void {
        let controller = DSSLoginController()
        self.navigationController?.presentViewController(controller, animated: true, completion: {});
        
    }
    
    // MARK: - Property
    
    lazy var slideMenu: DSSSlideMenu = {
        let bounds = UIScreen.mainScreen().bounds
        let frame = CGRectMake(-CGRectGetWidth(bounds), 0, CGRectGetWidth(bounds), CGRectGetHeight(bounds))
        let menu = DSSSlideMenu.init(frame: frame)
        menu.backgroundColor = UIColor.clearColor()
        return menu
    }()

}
