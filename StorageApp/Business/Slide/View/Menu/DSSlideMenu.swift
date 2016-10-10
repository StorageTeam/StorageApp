//
//  DSSlideMenu.swift
//  StorageApp
//
//  Created by ascii on 16/7/27.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import SnapKit

/**
 菜单功能列表
 
 - MenuProductAdd:    商品搜集
 - MenuProductList:   商品列表
 - MenuBuyTask:       采购任务
 - MenuBuyRecord:     采购清单
 - MenuDeliverTask:   发货任务
 - MenuDeliverRecord: 发货记录
 - MenuLogout:        退出登录
 - MenuClose:         关闭菜单
 */
enum SlideMenuEvent: Int {
    case MenuProductAdd        = 0
    case MenuProductList
    case MenuBuyTask
    case MenuBuyRecord
    case MenuDeliverTask
    case MenuDeliverRecord
    case MenuLogout
    case MenuClose
}

protocol SlideMenuDelegate : NSObjectProtocol {
    func slideMenuClick(obj: DSSlideMenu, event: SlideMenuEvent, userInfo: [String : AnyObject]?) -> Void
}

class DSSlideMenu: UIView, UITableViewDelegate, UITableViewDataSource {
    weak internal var delegate: SlideMenuDelegate?
    private var menus: [DSMenuMdoel]
    
    override init(frame: CGRect) {
        self.menus    = [DSMenuMdoel]()
        
        super.init(frame: frame)
        
        self.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { (make) in
            make.left.top.bottom.equalTo(self)
            make.right.equalTo(self).offset(-100)
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
    
    func setAccount(headURL: String?, nickname: String?, roleType: RoleType) -> Void {
        if let url = headURL {
            self.slideHeaderView.headerView.dss_setImage(url, placeholder: nil)
        } else {
            self.slideHeaderView.headerView.image = UIImage.init(named: "login_placeholder")
        }
        if let nick = nickname {
            self.slideHeaderView.nicknameLabel.text = nick
        }
        
        self.menus = self.makeMenuDataWithRole(roleType)
        self.tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menus.count
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
            let menuModel = self.menus[indexPath.row]
            
            cell.imageView?.image = menuModel.image
            cell.textLabel?.text = menuModel.title
            cell.textLabel?.textColor = UIColor.whiteColor()
            cell.textLabel?.font = UIFont.boldSystemFontOfSize(13)
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
        let menuModel = self.menus[indexPath.row]
        self.delegate?.slideMenuClick(self, event: menuModel.event!, userInfo: nil)
    }
    
    // MARK: - Action
    
    func tapBgViewGesture() -> Void {
        self.delegate?.slideMenuClick(self, event: SlideMenuEvent.MenuClose, userInfo: nil)
    }
    
    // MARK: - Method
    
    func makeMenuDataWithRole(roleType: RoleType) -> [DSMenuMdoel] {
        var menus = [DSMenuMdoel]()
        
        var imageNames  = [NSString]()
        var titles      = [NSString]()
        var events      = [SlideMenuEvent]()
        if roleType.isBuyerAble() {
            titles.append("商品搜集")
            events.append(SlideMenuEvent.MenuProductAdd)
            imageNames.append("menu_collect_icon")
            
            titles.append("商品列表")
            events.append(SlideMenuEvent.MenuProductList)
            imageNames.append("menu_product_list_icon")
        }
        
        if roleType.isDeliverAble() {
//            titles.append("采购任务")
//            events.append(SlideMenuEvent.MenuBuyTask)
//            imageNames.append("menu_buy_icon")
            
            titles.append("采购记录")
            events.append(SlideMenuEvent.MenuBuyRecord)
            imageNames.append("menu_buy_record")
            
//            titles.append("发货任务")
//            events.append(SlideMenuEvent.MenuDeliverTask)
//            imageNames.append("menu_deliver_icon")
            
            titles.append("发货记录")
            events.append(SlideMenuEvent.MenuDeliverRecord)
            imageNames.append("menu_deliver_record")
        }
        
        titles.append("退出登录")
        events.append(SlideMenuEvent.MenuLogout)
        imageNames.append("menu_logout_icon")
        
        for idx in 0 ..< min(min(imageNames.count, titles.count), events.count) {
            if let img = UIImage.init(named: imageNames[idx] as String) {
                let model = DSMenuMdoel.init()
                model.image = img
                model.title = titles[idx] as String
                model.event = events[idx] as SlideMenuEvent
                
                menus.append(model)
            }
        }
        
        return menus
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
    
    lazy var slideHeaderView: DSSlideHeaderView = {
        let menu = DSSlideHeaderView.init(frame: CGRectZero)
        menu.backgroundColor = UIColor.init(rgb: 0x232236)
        return menu
    }()
}







