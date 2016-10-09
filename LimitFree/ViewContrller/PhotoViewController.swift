
//  PhotoViewController.swift
//  LimitFree Created by ice on 16/9/27. Copyright © 2016年 k. All rights reserved.

import UIKit

class PhotoViewController: UIViewController {
    
    //点击图片的序号
    var photoIndex: Int?
    
    //所有图片的网址信息
    var photoArray: Array<PhotoModel>?
    
    //标题文字
    var titleLabel: UILabel?
    
    //滚动视图
    private var scrollView: UIScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createMyNav()
        
        //滚动视图上显示图片
        createScrollView()
       
    }
    
    
    //滚动视图上显示图片
    func createScrollView(){
        
        scrollView = UIScrollView(frame: CGRectMake(0, 200, kScreenWidth , 300))
        view.addSubview(scrollView!)
    
        let cnt = photoArray?.count
        let w = scrollView!.bounds.size.width
        let h = scrollView!.bounds.size.height
        for i in 0..<cnt!{
            
            let pModel = photoArray![i]
            
            let tmpImageView = UIImageView(frame: CGRectMake(kScreenWidth*CGFloat(i), 0, w, h))
            
            let url = NSURL(string: pModel.originalUrl!)
            
            if i != photoIndex!{
            
                tmpImageView.kf_setImageWithURL(url!)
                
            }else{
                
                //进入时 的显示的那张图片
                tmpImageView.kf_setImageWithURL(url!, placeholderImage: nil, optionsInfo: nil, progressBlock: { (receivedSize, totalSize) -> () in
                    
                    //下载进度条
                    ProgressHUD.showOnView(self.view)
                    
                    }, completionHandler: { (image, error, cacheType, imageURL) -> () in
                        
                    //下载完
                    ProgressHUD.hideOnView(self.view)
                })
            }
            
            scrollView?.addSubview(tmpImageView)
        }
        
        scrollView?.contentSize = CGSizeMake(CGFloat(cnt!)*w, 0)
        scrollView?.pagingEnabled = true
    
        //可以设置当前的显示页
        scrollView?.contentOffset = CGPoint(x: w*CGFloat(photoIndex!), y: 0)
        
        scrollView?.delegate = self
        
    }
    
    
    //自己加的类似导航的东西
    func createMyNav(){
    
        let bgImageView = UIImageView(frame: CGRectMake(0, 20, kScreenWidth, 44))
        bgImageView.image = UIImage(named: "navigationbar")
        view.addSubview(bgImageView)
        
        //文字
        let title = "第\(photoIndex!+1)页,共\((photoArray?.count)!)页"
        titleLabel = UILabel.createLabelFrame(CGRectMake(80, 0, 215, 44), title: title, textAlignment: .Center)
        bgImageView.addSubview(titleLabel!)
        
        //按钮
        let btn = UIButton.createBtn(CGRectMake(290, 4, 60, 36), title: "Done", bgImageName: "buttonbar_action", target: self, action: "doneAction")
        
        //加到图片视图上  需要开启交互
        bgImageView.userInteractionEnabled = true
        bgImageView.addSubview(btn)
        
    }
    
    
    func  doneAction(){
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK:设置状态栏的样式  //下面的方式是 只 修改当前视图控制器的状态栏样式
    override func prefersStatusBarHidden() -> Bool {  //状态栏的隐藏
        
        return false
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        //Default  白底黑子
        // LightContent  黑底白字
        
        return  .LightContent
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


//MARK:UIScrollViewDelegate
extension PhotoViewController:UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        
        let title = "第\(index + 1)页,共\((photoArray?.count)!)页"
        
        titleLabel?.text = title
    }
    
}


