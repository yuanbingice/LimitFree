//  LFBaseViewController.swift  LimitFree  Created by ice on 16/9/28.
//  Copyright © 2016年 k. All rights reserved.

import UIKit

//视图共同的父类
class LFBaseViewController: LFNavViewController {
    
    var tableView: UITableView?
    
    //数据源数组
    lazy var dataArray = NSMutableArray()
    
    var curPage: Int = 1
    
    //创建表格
    func createTabelView(){
        
        automaticallyAdjustsScrollViewInsets = false
        
        tableView = UITableView(frame: CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49), style: .Plain)
        
        tableView?.delegate = self
        tableView?.dataSource = self
        view.addSubview(tableView!)
        
    }
    
    //分页的功能
    func addRefresh(){
        
        //下拉刷新
        tableView?.headerView = XWRefreshNormalHeader(target: self, action: "loadFirstPage")
        
        //上拉加载更多
        tableView?.footerView = XWRefreshAutoNormalFooter(target: self, action: "loadNextPage")
    }
    
    //下载数据  // 子类重写(override)这个方法
    func downloadData(){
        
        print("子类必须实现这个方法:\(__FUNCTION__)")
    }
    
    //下拉刷新
    func loadFirstPage(){
        
        curPage = 1
        
        downloadData()
        
    }
    
    //上拉加载更多
    func loadNextPage(){
        
        curPage += 1
        
        downloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createTabelView() //表格
        
        downloadData()  //下载
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}

//MARK: UITableViewDelegate //子类重写该方法
extension LFBaseViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("子类必须实现这个方法:\(__FUNCTION__)")
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
}

