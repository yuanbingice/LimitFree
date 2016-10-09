//
//  UILabel+Util.swift
//  LimitFree
//
//  Created by ice on 16/9/26.
//  Copyright © 2016年 k. All rights reserved.
//

import UIKit

/*
UILabel 的类扩展
*/

extension UILabel{
    
    //创建UILabel的方法
    class func createLabelFrame(frame: CGRect,title: String?,textAlignment: NSTextAlignment?) -> UILabel{
        
        let label = UILabel(frame: frame)
        
        label.text = title
    
        
        if let tmpAlignment = textAlignment{
            
            label.textAlignment = tmpAlignment
        }
        
        return label
    }
    
    
    
}