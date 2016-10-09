//
//  StarView.swift
//  LimitFree
//
//  Created by ice on 16/9/26.
//  Copyright © 2016年 k. All rights reserved.
//

import UIKit

class StarView: UIView {
    
    //前景图片
    private var fgImageView: UIImageView?
    
    //视图如果是通过xib初始化,调用这个方法
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        print(__FUNCTION__)
        
        //初始化图片设置  //通过xib创建后 直接创建背景和前景图片
        createImageView()
    }
    
    
    func createImageView(){
        
        //背景图片
        let bgImageView = UIImageView(frame: CGRectMake(0, 0, 65, 23))
        bgImageView.image = UIImage(named: "StarBackground")
        addSubview(bgImageView)
        
        //前景图片
        fgImageView = UIImageView(frame: CGRectMake(0, 0, 65, 23))
        fgImageView?.image = UIImage(named: "StarsForeground")
        
        //设置停靠模式 .保留左边的部分
        fgImageView?.contentMode = .Left
        fgImageView?.clipsToBounds = true
        
        addSubview(fgImageView!)
    }
    
    //设置星级
    func setRating(rating: String){
        
        let rateValue = CGFloat(NSString(string: rating).floatValue)
        
        fgImageView?.frame.size.width = 65 * (rateValue / 5.0)
        
    }
    

}
