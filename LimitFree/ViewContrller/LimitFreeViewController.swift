//  LimitFreeViewController.swift  LimitFree Created by ice on 16/9/26.
//  Copyright © 2016年 k. All rights reserved.

import UIKit

//限免界面

class LimitFreeViewController: LFBaseViewController{
    
    //分类的类型
    private var cateId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTabelView()
        
        createMyNav()
        
        addRefresh()
    
        downloadData()
        
    }
    
    //下载数据
    override func downloadData(){
        
        //下载时显示自定义的试图
        ProgressHUD.showOnView(view)
        
        var urlString = String(format: kLimitUrl , curPage)
        
        //如果有分类,网址变化
        if cateId != nil{
            
            urlString = urlString.stringByAppendingString("&category_id=\(cateId!)")
        }
        
        let d = LFDownloader()
        
        d.delegate = self
        
        d.downloadWithURLString(urlString)
    }
    //创建导航
    func createMyNav(){
        
        //子类里面,直接调用父类中的方法(创建导航条上的标题,左右按钮)  //各子类会不同,所以传入不同的参数
        addNavButton("分类", target: self, action: "gotoCategory", isLeft: true)
        
        addNavTitle("限免")
        
        addNavButton("设置", target: self, action: "gotoSetPage", isLeft: false)

    }
    
    //导航按钮的响应方法  //跳转到分类界面
    func gotoCategory(){
        
        let categoryVC = CategoryViewController()
        
        categoryVC.type = .LimitFree
        
        //设置代理  ... self来实现
        categoryVC.delegate = self
        
        hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(categoryVC, animated: true)
        
        hidesBottomBarWhenPushed = false
        
    }
    
    func gotoSetPage(){
        
        let setCtrl = SettingViewController()
        
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(setCtrl, animated: true)
        hidesBottomBarWhenPushed = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:LFDownloaderDelegate
extension LimitFreeViewController:LFDownloaderDelegate{

    func downloader(downloder: LFDownloader, didFailWithError error: NSError) {
        
        //下载失败后,展示失败的视图 并 隐藏
        ProgressHUD.hideAfterFailOnView(view)
        
        print(error)
    }
    
    func downloader(downloader: LFDownloader, didFinishWithData data: NSData) {
        
        //JSON解析
        
//        let str = NSString(data: data, encoding: NSUTF8StringEncoding)
//        
//        print(str!)
        
        //这段代码要写在下载结束的地方
        if curPage == 1{   //刚开始将数据清空,,,后面的都加载数组中
            
            dataArray.removeAllObjects()
            
        }
        
        let result = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
        
        if result.isKindOfClass(NSDictionary){
            
            let dict = result as! Dictionary<String, AnyObject>
            
            let array = dict["applications"] as! Array<Dictionary<String, AnyObject>>
            
            for appDict in array{
                
                let model = LimitModel()
                
                //利用kvc赋值
                model.setValuesForKeysWithDictionary(appDict)
                dataArray.addObject(model)
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.tableView!.reloadData()
                
                //结束刷新,,,结束头 脚视图的刷新
                self.tableView?.headerView?.endRefreshing()
                self.tableView?.footerView?.endRefreshing()
                
                ProgressHUD.hideAfterSuccessOnView(self.view)
            
            })
        }
    }
    
    
}


//MARK:UITableViewDataSource
extension LimitFreeViewController{
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 100
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     
        let cellId = "limitCellId"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? LimitCell
        
        if cell == nil{
            
            cell = NSBundle.mainBundle().loadNibNamed("LimitCell", owner: nil, options: nil).last as? LimitCell
        }
        
        //设置点击的的显示
        cell?.selectionStyle = .None
        
        let model = dataArray[indexPath.row]
        
        cell?.config(model as! LimitModel, atIndex: indexPath.row + 1)
        
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailCtrl = DetailViewController()
        
        let model = dataArray[indexPath.row] as! LimitModel
        
        //跳转之前隐藏tabbar
        hidesBottomBarWhenPushed = true
        
        detailCtrl.appId = model.applicationId
        navigationController?.pushViewController(detailCtrl, animated: true)
        
        //跳转之后前面的届满显示tabbar
        hidesBottomBarWhenPushed = false
    }
    
}


//MARK: CategoryViewControllerDelegate
extension LimitFreeViewController: CategoryViewControllerDelegate{
    
    //代理的具体实现
    func didClickCateId(cateId: String, cateName: String) {
        
        //标题文字
        var titleStr = "限免-" + cateName
        
        if cateName == "全部"{
         
            titleStr = "限免"
        }
        
        addNavTitle(titleStr)
    
        //显示的数据,重新下载数据
        self.cateId = cateId
        
        curPage = 1      // 会清空dataArray中的数据
        downloadData()  //cateId 有值时,下载方法中的接口会发生变化
        
    }
    
}



