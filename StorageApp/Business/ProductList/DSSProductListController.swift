//
//  ViewController.swift
//  StorageApp
//
//  Created by ascii on 16/6/22.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSSProductListController: DSSBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let loginCon = DSSLoginController()
        self.navigationController?.presentViewController(loginCon, animated: true, completion: { 
            
        });
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

