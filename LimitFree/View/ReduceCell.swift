//  LimitCell.swift  LimitFree
//  Created by ice on 16/9/26.
//  Copyright © 2016年 k. All rights reserved.

import UIKit

//reduce 界面的自定义cell

class ReduceCell: UITableViewCell {
    
    @IBOutlet weak var bgImageView: UIImageView!
    
    @IBOutlet weak var appImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var lastPriceLabel: UILabel!
    
    @IBOutlet weak var myStarView: StarView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var shareLabel: UILabel!
    
    @IBOutlet weak var favoriteLabel: UILabel!
    
    @IBOutlet weak var downloadLabel: UILabel!
    

    
    //显示数据
    func config(model: LimitModel, atIndex index: Int){
        
        //背景图片
        if index % 2 == 0{
            
            bgImageView.image = UIImage(named: "cate_list_bg1")
            
        }else{
            
            bgImageView.image = UIImage(named: "cate_list_bg2")
        }
        
        //应用的图片
        let url = NSURL(string: model.iconUrl!)
        appImageView.kf_setImageWithURL(url!)
        
        //名字
        nameLabel.text = "\(index)." + model.name!
        
        //现价
        priceLabel.text = "现价:" + model.currentPrice!
   
        
        //原价
        let priceStr = "￥:" + model.lastPrice!
        lastPriceLabel.text = priceStr
        
        /*
            参数一: 显示的字符串
            参数二: 字符串的样式
        */
        let attrStr = NSAttributedString(string: priceStr, attributes: [NSStrikethroughStyleAttributeName: NSNumber(int: 1),NSStrikethroughColorAttributeName: UIColor.redColor()])
        lastPriceLabel.attributedText = attrStr
        
        //星级
        
        myStarView.setRating(model.starCurrent!)
        
        //类型  //利用工具类中的定义方法转为中文
        categoryLabel.text = MyUtil.transferCateName(model.categoryName!)
        
        shareLabel.text = "分享:" + model.shares! + "次"
        
        favoriteLabel.text = "收藏:" + model.favorites! + "次"
        
        downloadLabel.text = "下载:" + model.downloads! + "次"
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
