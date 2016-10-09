//
//  CollectButton.swift
//  LimitFreeCreated by ice on 16/9/29.
//  Copyright © 2016年 k. All rights reserved.
//

import UIKit

//用来传值
protocol CollectButtonDelegate: NSObjectProtocol{
    
    //删除
    func didDeleteBtnAtIndex(index: Int)
}

//收藏页面中的显示
class CollectButton: UIControl {

    private var imageView: UIImageView?
    
    private var titleLabel: UILabel?
    
    private var deleteBtn: UIButton?

    weak var delegate: CollectButtonDelegate?
    
    //按钮的序号
    var btnIndex: Int?
    
    //删除状态
    var isDelete: Bool?{   //利用属性观察器 来改变 删除按钮的隐藏状态
        
        didSet{
            if  isDelete == true{
                
                //进入删除状态
                
                deleteBtn?.hidden = false
                
            }else{
                //退出删除状态
                
                deleteBtn?.hidden = true
            }
            
        }
    }
    
    //数据, 数据变化时 赋值图片和标题
    var model: CollectModel?{
        
        didSet{
            
            imageView?.image = model?.headImage
            
            titleLabel?.text = model?.name
        }
        
    }
    
    override init(frame: CGRect) {
        
        var tmpFrame = frame
        tmpFrame.size = CGSizeMake(80, 100)  //确定控件的大小
        super.init(frame: tmpFrame)
        
        imageView = UIImageView(frame: CGRectMake(20, 20, 60, 60))
        addSubview(imageView!)
        
        
        titleLabel = UILabel.createLabelFrame(CGRectMake(20, 80, 60, 20), title: nil, textAlignment: .Center)
        titleLabel?.font = UIFont.systemFontOfSize(12)
        addSubview(titleLabel!)
        
        
        deleteBtn = UIButton.createBtn(CGRectMake(0, 0, 40, 40), title: nil, bgImageName: "close", target: self, action: "deleteAction")
        deleteBtn?.hidden = true  //删除按钮 默认隐藏
        addSubview(deleteBtn!)
        
    }
    //删除操作 // 利用代理,在具体的代理页面中实现
    func deleteAction(){
        
        delegate?.didDeleteBtnAtIndex(btnIndex!)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
