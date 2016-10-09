//  MainTabBarViewController.swift  LimitFree  Created by ice on 16/9/26.
//  Copyright © 2016年 k. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //可以文字的颜色
        tabBar.tintColor = UIColor(red: 83.0/255.0, green: 156.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        //appearance  (显示) 是统一设置某些控件的显示特性
        // UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:  UIColor.redColor()], forState: UIControlState.Selected)
        
        //创建子视图控制器
       createViewControllers()
        
    }
    
    func createViewControllers(){
        
        let titleArray = ["限免","降价","免费","专题","热榜"]
        
        let imageArray =
            ["tabbar_limitfree",
            "tabbar_reduceprice",
            "tabbar_appfree",
            "tabbar_subject",
            "tabbar_rank"]
        
        let ctrlArray =
            ["LimitFree.LimitFreeViewController",
            "LimitFree.ReduceViewController",
            "LimitFree.FreeViewController",
            "LimitFree.SubjectViewController",
            "LimitFree.RankViewController"]
        
        //LimitFree 工程名
        
        //接受导航器,标签栏管理
        var array = Array< UINavigationController>()
        
        for i in 0..<titleArray.count{
        
            let ctrlName = ctrlArray[i]
            let cls = NSClassFromString(ctrlName) as! UIViewController.Type
            let ctrl = cls.init()
            
            //文字图片
            ctrl.tabBarItem.title = titleArray[i]
            let imageName = imageArray[i]
            ctrl.tabBarItem.image = UIImage(named: imageName)
            
            //图片失真
            ctrl.tabBarItem.selectedImage = UIImage(named: imageName + "_press")?.imageWithRenderingMode(.AlwaysOriginal)
            
            let navCtrl = UINavigationController(rootViewController: ctrl)
            array.append(navCtrl)
            
        }
        //标签栏管理
        viewControllers = array
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
