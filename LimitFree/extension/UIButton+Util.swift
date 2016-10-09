//
//  UIButton+Util.swift
//  LimitFree
//
//  Created by ice on 16/9/26.
//  Copyright © 2016年 k. All rights reserved.
//

import UIKit

//按钮的扩展
extension UIButton{
    
    class func createBtn(frame: CGRect, title:String?,bgImageName: String?, target: AnyObject?, action: Selector) -> UIButton{
        
        //因为要设置背景图片,所以使用自定义的 .Custom
        let btn = UIButton(type: .Custom)
        
        btn.frame = frame
        
        if let tmpTitle = title{
            
            btn.setTitle(tmpTitle, forState: .Normal)
            
            btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        }
        
        if let imageName = bgImageName{
            //自定义按钮可以设置背景图片
            btn.setBackgroundImage(UIImage(named: imageName), forState: .Normal)
            
        }
        
        if target != nil && action != nil{
        
            btn.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        }
        
        
        return btn
        
    }
    
}