//
//  CollectViewController.swift
//  LimitFree  Created by ice on 16/9/29.
//  Copyright © 2016年 k. All rights reserved.
//

import UIKit

//收藏app 的页面

class CollectViewController: LFNavViewController {
    
    //数据源---收藏的app
    private var dataArray: NSMutableArray?
    
    private var scrollView: UIScrollView?
    
    private var pageCtrl: UIPageControl?
    
    //是否删除的状态
    private var isDelete = false

    override func viewDidLoad() {
        super.viewDidLoad()

        createMyNav()
        
        
        automaticallyAdjustsScrollViewInsets = false
        
        scrollView = UIScrollView(frame: CGRectMake(0, 64, kScreenWidth, kScreenHeight-64))
        
        scrollView?.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        scrollView?.pagingEnabled = true
        view.addSubview(scrollView!)
        
        //分页控件
        pageCtrl = UIPageControl(frame: CGRectMake(80, kScreenHeight-60, 200, 20))
        //pageCtrl?.backgroundColor = UIColor.redColor()
        
        pageCtrl?.pageIndicatorTintColor = UIColor.blackColor()
        view.addSubview(pageCtrl!)

        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        //查询数据
        let dbManager = LFDBManger()
        
        //执行函数,.执行完后会执行闭包的代码  //相当搜索完后 给闭包赋值(就是将的搜索到的数组 传过来,在此页面进行一些操作)
        
        dbManager.searchAllCollectiData { (array) -> Void in
            
            self.dataArray = NSMutableArray(array: array)
            
            //显示UI //显示收藏的app
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.showCollectData()
            })
        }
        
    }
    
    //显示收藏的数据
    func showCollectData(){
        
        //清空一下之前的子视图 // 否则重复创建子视图
        for tmpView in (scrollView?.subviews)!{
            
            if tmpView.isKindOfClass(CollectButton){
                
                tmpView.removeFromSuperview()
            }
        }
        
        
        //遍历数据源数组显示
        if dataArray?.count > 0{
            
            let cnt = (dataArray?.count)!
        
            for i in 0..<cnt{
                
                //计算页数
                let page = i / 9
                
                let colNumber = 3
                let btnW: CGFloat = 80
                let btnH: CGFloat = 100
                let offsetX: CGFloat = 30  //第一列的x值
                let spaceX: CGFloat = (kScreenWidth-CGFloat(colNumber)*btnW-offsetX*2-20)/CGFloat(colNumber-1) //列间距
                
                let offsetY: CGFloat = 66 //第一行的y值
                let spaceY: CGFloat = 60 //行间距
                
                //计算按钮的行和列
                let rowAndCol = i%9

                let row = rowAndCol/colNumber
                let col = rowAndCol%colNumber
                
                let btnX = offsetX + CGFloat(col) * (btnW + spaceX) + kScreenWidth * CGFloat(page)
                let btnY = offsetY + CGFloat(row) * (btnH + spaceY)
                
                let btn = CollectButton(frame: CGRectMake(btnX, btnY, 0, 0))
                
                //显示数据  //改变model的值,会对视图和albel赋值
                btn.model = dataArray![i] as? CollectModel
                
                //设置 按钮的 删除状态
                btn.isDelete = isDelete
                btn.addTarget(self, action: "clickBtn:", forControlEvents: .TouchUpInside)
                scrollView!.addSubview(btn)
                
                //设置代理
                btn.delegate = self
                btn.btnIndex = i
            }
            
            //滚动范围
            let pageCnt = (cnt + 8) / 9
            scrollView?.contentSize = CGSizeMake(CGFloat(pageCnt)*kScreenWidth, 0)
            scrollView?.delegate = self
            
            //设置分页控件的总数,和开始的显示
            pageCtrl?.numberOfPages = pageCnt
            pageCtrl?.currentPage = 0
            
        }else{
            
            //没有收藏
            MyUtil.showAllertMsg("还没有任何收藏的数据", onViewController: self)
        }
        
    }
    
    //点击收藏的app进入到app详情
    func clickBtn(btn: CollectButton){
        
        
        if isDelete == false{  //非编辑状态才可以进入app详情
        
            let detailCtrl = DetailViewController()
            
            detailCtrl.appId = btn.model?.applicationId
            
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(detailCtrl, animated: true)
            
            hidesBottomBarWhenPushed = false
        }
        
    }
    
    
    func createMyNav(){
        addBackBtn()
        
        addNavTitle("我的收藏")
        
        addNavButton("编辑", target: self, action: "editAction:", isLeft: false)
        
    }
    
    //哪个调用了 addtaget 方法  就传过来是哪种参数
    func editAction(btn: UIButton){
        
        if isDelete == false{
            //进入删除状态
            btn.setTitle("完成", forState: .Normal)
            
            
            //改变按钮的属性
            for tmpView in (scrollView?.subviews)!{
                
                //滑动视图的子视图中会有 水平和竖直的提示条
                if tmpView.isKindOfClass(CollectButton){
                    
                    let btn = tmpView as! CollectButton
                    btn.isDelete = true
                }
            }
            isDelete = true
            
        }else{
            
            //退出删除状态
            if isDelete == true{
                //进入删除状态
                btn.setTitle("编辑", forState: .Normal)
                
                
                //改变按钮的属性
                for tmpView in (scrollView?.subviews)!{
                    
                    //滑动视图的子视图中会有 水平和竖直的提示条
                    if tmpView.isKindOfClass(CollectButton){
                        
                        let btn = tmpView as! CollectButton
                        btn.isDelete = false
                    }
                    
                }
                
                isDelete = false
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

//MARK: CollectButtonDelegate
extension CollectViewController: CollectButtonDelegate{
    
    func didDeleteBtnAtIndex(index: Int) {
        
        //1...从数据库删除
        let model = dataArray![index] as! CollectModel
        
        let dbManager = LFDBManger()
        
        dbManager.deleteWithAppId(model.applicationId!) { (flag) -> Void in
            
            if flag == true{
                //2...从数据源数组中删除
                self.dataArray?.removeObjectAtIndex(index)
                //3...重新显示
                self.showCollectData()
                
            }else{
                
                MyUtil.showAllertMsg("删除失败", onViewController: self)
            }
        }
        

    }
    
}

//MARK: UIScrollViewDelegate
extension CollectViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        
        pageCtrl?.currentPage = index
    }
}