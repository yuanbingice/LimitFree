//  NearbyButton.swift
//  LimitFree  Created by ice on 16/9/27.
//  Copyright © 2016年 k. All rights reserved.

import UIKit

//自定制点积累
class NearbyButton: UIControl {
    
    private var imageView: UIImageView?
    
    private var textLabel: UILabel?
    
    //数据   //可以通过getter方法获取数据值  //利用属性观察器来赋值
    var model: LimitModel?{
        
        didSet{
            //显示数据
            let url = NSURL(string: (model?.iconUrl)!)
            imageView?.kf_setImageWithURL(url!)
            
            //文字
            textLabel?.text = model?.name
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let titleH: CGFloat = 20
        let w = bounds.size.width
        let h = bounds.size.height
        
        //初始化子视图
        imageView = UIImageView(frame: CGRectMake(0, 0, w, h-titleH))
        addSubview(imageView!)
        
        //文字
        textLabel = UILabel.createLabelFrame(CGRectMake(0, h-titleH, w, titleH), title: nil, textAlignment: .Center)
        textLabel?.font = UIFont.systemFontOfSize(12)
        addSubview(textLabel!)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
