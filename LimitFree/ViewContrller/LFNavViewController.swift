//
//  LFNavViewController.swift
//  LimitFree
//  Created by ice on 16/9/26.
//  Copyright © 2016年 k. All rights reserved.
//

import UIKit

//基础的视图控制器,其他的继承 ,,, 会继承导航条标题(addNavTitle) 和 导航条上按钮的方法(addNavButton)  //子类可以直接调用

class LFNavViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
    }
    
    //创建导航条的标题视图
    func addNavTitle(title: String){
        
        let label = UILabel.createLabelFrame(CGRectMake(0, 0, 215, 44), title: title, textAlignment: .Center)
        
        label.font = UIFont.boldSystemFontOfSize(24)
        label.tintColor = UIColor(red: 58.0/255.0, green:95.0/255.0 , blue: 145.0/255.0, alpha: 1.0)
        
        //ViewController都会有navigationItem,只有当ViewController有导航器时,才会显示,没有则不显示
        navigationItem.titleView = label
        
    }
    
    //(接口)创建导航台条上按钮(左右之分)
    func addNavButton(title: String, target: AnyObject?, action: Selector, isLeft: Bool){
        
        addNavButton(title, target: target, action: action, isLeft: isLeft, imageName: "buttonbar_action")
        
    }
    
    //私有 创建按钮的方法
    private func addNavButton(title: String, target: AnyObject?, action: Selector, isLeft: Bool, imageName: String){
        
        let btn = UIButton.createBtn(CGRectMake(0, 0, 60, 36), title: title, bgImageName: imageName, target: target, action: action)
        
        let barButton = UIBarButtonItem(customView: btn)
        
        //左侧按钮和右侧按钮的区别
        if isLeft{
            
            navigationItem.leftBarButtonItem = barButton
            
        }else{
            
            navigationItem.rightBarButtonItem = barButton
        }
        
    }
    
    //(外部可以调用的方法)返回按钮的方法
    func addBackBtn(){
        
        addNavButton("返回", target: self, action: "backAction", isLeft: true, imageName: "buttonbar_back")
        
    }
    
    func backAction(){
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
