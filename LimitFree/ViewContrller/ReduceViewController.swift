//  ReduceViewController.swift  LimitFree
//  Created by ice on 16/9/26.
//  Copyright © 2016年 k. All rights reserved.

import UIKit

//降价界面

class ReduceViewController: LFBaseViewController {
    
    //分类的id
    private var cateId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //添加分页的功能(上啦, 下拉)
        addRefresh()
        
        createMyNav()
    }
    
    //导航
    func createMyNav(){

        addNavButton("分类", target: self, action:"gotoCategory", isLeft: true)
        
        addNavTitle("降价")
        
        addNavButton("设置", target: self, action: "gotoSetPage", isLeft: false)
    }
    
    //分类
    func gotoCategory(){
        
        let cateCtrl = CategoryViewController()
        
        cateCtrl.type = .Reduce
        
        cateCtrl.delegate = self
        
        hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(cateCtrl, animated: true)
        
        hidesBottomBarWhenPushed = false
        
    }
    
    func gotoSetPage(){
        
        let setCtrl = SettingViewController()
        
        hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(setCtrl, animated: true)
        
        hidesBottomBarWhenPushed = false
        
    }
    
    //下载
    override func downloadData() {
       
        ProgressHUD.showOnView(view)
        
        var urlString = String(format: kReduceUrl, curPage)
        
        if cateId != nil{
            
            urlString = urlString.stringByAppendingString("&category_id=\(cateId!)")
        }
        
        let d = LFDownloader()
        
        d.delegate = self
        
        d.downloadWithURLString(urlString)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: LFDownloaderDelegate

extension ReduceViewController: LFDownloaderDelegate{
    
    func downloader(downloder: LFDownloader, didFailWithError error: NSError) {
        
        ProgressHUD.hideAfterFailOnView(view)
    }
    
    //下载成功后解析数据
    func downloader(downloader: LFDownloader, didFinishWithData data: NSData) {
        
        //如果是下拉刷新 需要清空数据源数组 //再解析添加数据
        if curPage == 1{
            
            dataArray.removeAllObjects()
        }
        
        let result = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
        
        if result.isKindOfClass(NSDictionary){
            
            let dict = result as! Dictionary<String, AnyObject>
            
            let array = dict["applications"] as! Array<Dictionary<String, AnyObject>>
            
            for appDict in array{
                
                let model = LimitModel()
                
                model.setValuesForKeysWithDictionary(appDict)
                
                dataArray.addObject(model)
            }
            
            //修改UI
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.tableView?.reloadData()
                
                self.tableView?.headerView?.endRefreshing()
                self.tableView?.footerView?.endRefreshing()
            
                ProgressHUD.hideAfterSuccessOnView(self.view)
                
            })
        }
        
    }
}
//MARK: UITableView代理
extension ReduceViewController{
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 100
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellId = "reduceCellId"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? ReduceCell
        
        if cell == nil{
            
            cell = NSBundle.mainBundle().loadNibNamed("ReduceCell", owner: nil, options: nil).last as? ReduceCell
        }
        
        cell?.selectionStyle = .None
        
        let model = dataArray[indexPath.row] as! LimitModel
        
        cell?.config(model, atIndex: indexPath.row+1)
        
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let model = dataArray[indexPath.row] as! LimitModel
        
        let detailCtrl = DetailViewController()
        
        detailCtrl.appId = model.applicationId
        
        hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(detailCtrl, animated: true)
        
        hidesBottomBarWhenPushed = false
        
    }
    
}

//MARK: CategoryViewControllerDelegate
extension ReduceViewController: CategoryViewControllerDelegate{
    
    func didClickCateId(cateId: String, cateName: String) {
        
        //标题
        var titleStr = "降价-" + cateName
        
        if cateName == "全部"{
            
            titleStr = "降价"
        }
        addNavTitle(titleStr)
        
        //请求数据
        
        self.cateId = cateId
        
        curPage = 1
        
        downloadData()
        
    }
    
    
}