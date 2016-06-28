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
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if DSSAccount.isLogin() {
            print("user login")
        } else {
            let controller = DSSLoginController()
            self.navigationController?.presentViewController(controller, animated: true, completion: {});
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .Edit, target: self, action: #selector(clickButton))
    }
    
    func clickButton(sender: UIButton){
        print("push eidt")
        let editController = EditViewController()
        self.navigationController?.pushViewController(editController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Method
}

