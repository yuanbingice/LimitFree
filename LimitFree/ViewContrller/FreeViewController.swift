//
//  FreeViewController.swift
//  LimitFreeCreated by ice on 16/9/26.
//  Copyright © 2016年 k. All rights reserved.
//

import UIKit

//免费界面

class FreeViewController: LFBaseViewController {
    
    //分类的id
    private var cateId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createMyNav()
        
        addRefresh()
      
    }
    
    //导航
    func createMyNav(){
        
        //分类
        addNavButton("分类", target: self, action: "gotoCategory", isLeft: true)
        
        //标题
        addNavTitle("免费")
        
        //设置
        addNavButton("设置", target: self, action: "gotoSetPage", isLeft: false)
    }
    //分类
    func gotoCategory(){
        
        let cateCtrl = CategoryViewController()
        
        cateCtrl.type = .Free
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
    
    override func downloadData() {
        
        ProgressHUD.showOnView(view)
        var urlString = String(format: kFreeUrl, curPage)
        
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

extension FreeViewController: LFDownloaderDelegate{
    
    func downloader(downloder: LFDownloader, didFailWithError error: NSError) {
        
        ProgressHUD.hideAfterFailOnView(view)
    }
    
    func downloader(downloader: LFDownloader, didFinishWithData data: NSData) {
        //下拉第一页 清空数组
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
            
            //刷新UI
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.tableView?.reloadData()
                
                self.tableView?.headerView?.endRefreshing()
                self.tableView?.footerView?.endRefreshing()
                
                ProgressHUD.hideAfterSuccessOnView(self.view)
            })
        }
        
    }
    
}



//MARK: CategoryViewControllerDelegate
extension FreeViewController: CategoryViewControllerDelegate{
    
    func didClickCateId(cateId: String, cateName: String) {
        
        //标题
        var titleStr = "免费-" + cateName
        
        if cateName == "全部"{
         
            titleStr = "免费"
        }
        
        addNavTitle(titleStr)
        
        //重新下载数据
        self.cateId = cateId
        
        curPage = 1
        
        downloadData()
    }
    
    
}

//MARK:tableviewDelegate

extension FreeViewController{
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 100
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellId = "freeCellId"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? FreeCell
        
        if cell == nil{
            
            cell = NSBundle.mainBundle().loadNibNamed("FreeCell", owner: nil, options: nil).last as? FreeCell
        }
        
        let model = dataArray[indexPath.row] as! LimitModel
        
        cell?.config(model, atIndex: indexPath.row+1)
        
        return cell!
    }
    
    //点击进入详情页面
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let model = dataArray[indexPath.row] as! LimitModel
        
        let detailCtrl = DetailViewController()
        
        detailCtrl.appId = model.applicationId
        
        hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(detailCtrl, animated: true)
        
        hidesBottomBarWhenPushed = false
        
    }
    
}
