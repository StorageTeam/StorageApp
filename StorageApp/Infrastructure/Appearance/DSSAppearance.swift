//
//  DSSAppearance.swift
//  StorageApp
//
//  Created by ascii on 16/6/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import Foundation

class DSSAppearance: NSObject {
    
    class func configAppearance() {
        DSSAppearance.configStatusBar()
        DSSAppearance.configNavigationBar()
    }
    
    private class func configStatusBar() {
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
    }
    
    private class func configNavigationBar() {
        UINavigationBar.appearance().translucent = false
        
        UINavigationBar.appearance().tintColor = UIColor.blackColor()
        UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName  : UIColor.blackColor(),
                                                            NSFontAttributeName             : UIFont.systemFontOfSize(18)]
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.blackColor(),
                                                                NSFontAttributeName         : UIFont.systemFontOfSize(15)]
                                                            , forState: UIControlState.Normal)
    }
}
