//
//  DSABaseViewController.swift
//  StorageApp
//
//  Created by ascii on 16/6/23.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import PKHUD
import SnapKit

class DSSBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(18)]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.configDefaultLeftBar()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !DSSAccount.isLogin() {
            self.presentLoginController()
        }
    }
    
    func presentLoginController() -> Void {
        let controller = DSSLoginController()
        self.navigationController?.presentViewController(controller, animated: true, completion: {});

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Back Bar
    
    func configDefaultLeftBar() -> Void {
        if let viewControllers = self.navigationController?.viewControllers {
            if viewControllers.count <= 1 {
                if let naviController = self.navigationController as? DSSNavigationController {
                    self.navigationItem.leftBarButtonItem  = UIBarButtonItem.init(image: UIImage.init(named: "LeftBarIcon"),
                                                                                  style: .Done,
                                                                                  target: naviController,
                                                                                  action: #selector(naviController.clickLeftNaviBarButton))
                }
            } else {
                self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "common_back"),
                                                                             style: UIBarButtonItemStyle.Plain,
                                                                             target: self,
                                                                             action: #selector(self.clickDefaultLeftBar))
            }
        }
    }
    
    func clickDefaultLeftBar() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - HUD
    
    func showText(text: String?) {
        HUD.flash(.Label(text), delay: 2)
    }
    
    func showHUD(){
        HUD.show(.Progress)
    }
    
    func hidHud(animated: Bool){
        HUD.hide(animated: animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
