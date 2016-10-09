//
//  SettingViewController.swift
//  LimitFree
//
//  Created by ice on 16/9/29.
//  Copyright © 2016年 k. All rights reserved.
//

import UIKit

class SettingViewController: LFNavViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createMyNav()
        createBtns()
        
    }

    func createMyNav(){
        
        addBackBtn()
        
        addNavTitle("设置")
    }
    
    func createBtns(){
    
        let imageArray = ["account_setting","account_favorite",
            "account_user","account_collect",
            "account_download","account_comment",
            "account_help","account_candou"]
        let titleArray = ["我的设置","我的关注",
                        "我的账号","我的收藏",
                        "我的下载","我的评论",
                        "我的帮助","蚕豆应用"]
        
        let colNumber: Int = 3
        let btnW: CGFloat = 60
        let btnH: CGFloat = 60
        let titleH: CGFloat = 20
        let offsetX: CGFloat = 50 //第一列按钮左侧间距
        let spaceX: CGFloat = (kScreenWidth-offsetX*2-btnW*CGFloat(colNumber))/(CGFloat(colNumber-1))  //按钮之间的间距
        
        let offsetY: CGFloat = 160 //第一行按钮上方间距
        let spaceY: CGFloat = 80
        for i in 0..<titleArray.count{
            
            let row = i/colNumber
            let col = i%colNumber
            
            let btnX = offsetX+(btnW+spaceX)*CGFloat(col)
            let btnY = offsetY + (btnH + titleH + spaceY)*CGFloat(row)
            
            //按钮
            let button = UIButton.createBtn(CGRectMake(btnX, btnY, btnW, btnH), title: nil, bgImageName: imageArray[i], target: self, action: "clickBtn:")
            button.tag = 200+i
            view.addSubview(button)
            
            //文字
            let label = UILabel.createLabelFrame(CGRectMake(btnX, btnY+btnH, btnW, titleH), title: titleArray[i], textAlignment: .Center)
            label.font = UIFont.systemFontOfSize(12)
            
            view.addSubview(label)
        }
    }
    
    func clickBtn(btn: UIButton){
        
        let index = btn.tag - 200
        
        if index == 3{
            
            //收藏
            let collectCtrl = CollectViewController()
            
            hidesBottomBarWhenPushed = true
            
            navigationController?.pushViewController(collectCtrl, animated: true)
            
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
