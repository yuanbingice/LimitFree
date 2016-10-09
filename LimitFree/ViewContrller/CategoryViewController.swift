//
//  CategoryViewController.swift
//  LimitFree
//
//  Created by ice on 16/9/28.
//  Copyright © 2016年 k. All rights reserved.
//

import UIKit


//代理和协议 来实现页面的传值,,,此页面选中的时候调用   代理方法 -> 具体实现在下个页面
protocol CategoryViewControllerDelegate: NSObjectProtocol{
    
    //分类 cateId      分类的名称 cateName
    func didClickCateId(cateId : String, cateName: String)  //代理方法,利用传进的参数,改变limit界面的显示内容
    
}


//分类的类型
public enum CategoryType: Int{
    
    case LimitFree  //限免
    
    case Reduce     //降价
    
    case Free       //免费
}


//分类界面
class CategoryViewController: LFBaseViewController {
    //类型
    var type: CategoryType?
    
    //代理属性
    weak var delegate: CategoryViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //父类设置表格视图时 将下面的标签栏的高度减了
        tableView?.frame.size.height = kScreenHeight - 64
        
        creatMyNav()
        
    }
    
    //导航  
    func creatMyNav(){
        
        //返回按钮
        addBackBtn()
        
        var titleStr = ""
        
        if type == .LimitFree{
            
            titleStr = "限免-分类"
            
        }else if type == .Reduce{
            
            titleStr = "降价-分类"
            
        }else if type == .Free{
            
            titleStr = "免费-分类"
        }
        
        //标题文字  //类型的不同,标题也会不同
        addNavTitle(titleStr)
        
    }
    
    
    //重写父类的下载方法
    override func downloadData() {
        
        ProgressHUD.showOnView(view)
        
        var urlString: String? = nil
        
         //区分接口的不同,类型不同 接口不同
        if type == .LimitFree{
            
            urlString = kCategoryLimitUrl
            
        }else if type == .Reduce{
            
            urlString = kCategoryReduceUrl
            
        }else if type == .Free{
            
            urlString = kCategoryFreeUrl
        }
        
    
        if urlString != nil{
        
            let d = LFDownloader()
            
            d.delegate = self
            
            d.downloadWithURLString(urlString!)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MRRK: LFDownloaderDelegate
extension CategoryViewController: LFDownloaderDelegate{
    
    func downloader(downloder: LFDownloader, didFailWithError error: NSError) {
        
        ProgressHUD.hideAfterFailOnView(view)
    }
    
    
    func downloader(downloader: LFDownloader, didFinishWithData data: NSData) {
        
        let result = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
        
        if result.isKindOfClass(NSDictionary){
            
            let dict = result as! Dictionary<String, AnyObject>
            
            let array = dict["category"] as! Array<Dictionary<String, AnyObject>>
            
            for cateDict in array{
            
                //排除其中一个
                let cateId = cateDict["categoryId"]
                let cateStr = "\(cateId!)"
                if cateStr == "0"{
                    continue
                }
                
                let model = CategoryModel()
                model.setValuesForKeysWithDictionary(cateDict)
                
                dataArray.addObject(model)
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.tableView?.reloadData()
                
                ProgressHUD.hideAfterSuccessOnView(self.view)
                
            })
            
        }
        
    }
}

extension CategoryViewController{
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 80
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellId = "categoryCellId"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? CategoryCell
        
        if cell == nil{
            cell = NSBundle.mainBundle().loadNibNamed("CategoryCell", owner: nil, options: nil).last as? CategoryCell

        }
        
        let model = dataArray[indexPath.row] as! CategoryModel
        
        cell?.configModel(model, type: type!)
        
        return cell!
    }
    
    //选中某行返回limit界面,并改变界面的显示内容(利用代理)
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let model = dataArray[indexPath.row] as! CategoryModel
        
        let cateId = "\(model.categoryId!)"
        let cateName = MyUtil.transferCateName(model.categoryName!)
        
        //点击后调用代理方法  // 具体实现在 代理人中实现  //代理方法,利用传进的参数,改变limit界面的显示内容
        delegate?.didClickCateId(cateId, cateName: cateName)
        //退回前面的界面
        navigationController?.popViewControllerAnimated(true)
        
    }
    

    
}

