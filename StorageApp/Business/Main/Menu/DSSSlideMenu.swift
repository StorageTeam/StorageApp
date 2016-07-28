//
//  DSSSlideMenu.swift
//  StorageApp
//
//  Created by ascii on 16/7/27.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import SnapKit

enum SlideMenuEvent: Int {
    case MenuAdd        = 0
    case MenuList
    case MenuLogout
    case MenuClose
}

protocol SlideMenuDelegate : NSObjectProtocol {
    func slideMenuClick(obj: DSSSlideMenu, event: SlideMenuEvent, userInfo: [String : AnyObject]?) -> Void
}

class DSSSlideMenu: UIView, UITableViewDelegate, UITableViewDataSource {
    weak internal var delegate: SlideMenuDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { (make) in
            make.left.top.bottom.equalTo(self)
            make.right.equalTo(self).offset(-115)
        }
        
        self.addSubview(self.rightView)
        self.rightView.snp_makeConstraints { (make) in
            make.right.top.bottom.equalTo(self)
            make.left.equalTo(self.tableView.snp_right)
        }
        
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(tapBgViewGesture))
        self.rightView.addGestureRecognizer(gesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(self.titleArray.count, self.iconArray.count)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 94
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.slideHeaderView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(String(UITableViewCell)) {
            cell.imageView?.image = UIImage.init(named: self.iconArray[indexPath.row])
            cell.textLabel?.text = self.titleArray[indexPath.row]
            cell.textLabel?.textColor = UIColor.whiteColor()
            cell.textLabel?.font = UIFont.boldSystemFontOfSize(15)
            cell.backgroundColor = UIColor.init(rgb: 0x141324)
            
            cell.selectedBackgroundView = {
                let view = UIView.init()
                view.backgroundColor = UIColor.init(rgb: 0x0a3953)
                return view
            }()
            return cell
        }
        return UITableViewCell.init()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.slideMenuClick(self, event: SlideMenuEvent.init(rawValue: indexPath.row)!, userInfo: nil)
    }
    
    // MARK: - Action
    
    func tapBgViewGesture() -> Void {
        self.delegate?.slideMenuClick(self, event: SlideMenuEvent.MenuClose, userInfo: nil)
    }
    
    // MARK: - Property
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRectZero, style: UITableViewStyle.Plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.allowsMultipleSelection = false
        tableView.backgroundColor = UIColor.init(rgb: 0x141324)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: String(UITableViewCell))
        return tableView
    }()
    
    lazy var rightView: UIView = {
        let view = UIView.init(frame: CGRectZero)
        view.backgroundColor = UIColor.clearColor()
        return view
    }()
    
    lazy var slideHeaderView: DSSSlideHeaderView = {
        let menu = DSSSlideHeaderView.init(frame: CGRectZero)
        menu.backgroundColor = UIColor.blackColor()
        return menu
    }()
    
    lazy var titleArray: Array = {
        return ["商品收集", "商品列表", "退出登录"]
    }()
    
    lazy var iconArray: Array = {
        return ["product_collect_icon", "product_collect_icon", "product_collect_icon"]
    }()
}







