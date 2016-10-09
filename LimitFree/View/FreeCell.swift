//
//  LimitCell.swift
//  LimitFree
//
//  Created by ice on 16/9/26.
//  Copyright © 2016年 k. All rights reserved.
//

import UIKit


//limit 界面的自定义cell

class FreeCell: UITableViewCell {
    
    @IBOutlet weak var bgImageView: UIImageView!
    
    @IBOutlet weak var appImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    //评分
    @IBOutlet weak var rateLabel: UILabel!
    
    @IBOutlet weak var lastPriceLabel: UILabel!
    
    @IBOutlet weak var myStarView: StarView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var shareLabel: UILabel!
    
    @IBOutlet weak var favoriteLabel: UILabel!
    
    @IBOutlet weak var downloadLabel: UILabel!
    
    
    //价格的横线
    private var lineView:UIView?
    
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
        //appImageView.layer.cornerRadius = 10
        appImageView.kf_setImageWithURL(url!)
        
        //self.layer.cornerRadius = 6
        
        //名字
        nameLabel.text = "\(index)." + model.name!
        
        //评分
        rateLabel.text = "评分:" + model.starCurrent!

        
        //原价
        let priceStr = "RMB:" + model.lastPrice!
        lastPriceLabel.text = priceStr
        
        let attrStr = NSMutableAttributedString(string: priceStr)
        attrStr.addAttributes([NSStrikethroughStyleAttributeName: NSNumber(int: 1)], range: NSMakeRange(0, attrStr.length))
        
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
