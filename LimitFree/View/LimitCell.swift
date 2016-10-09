//
//  LimitCell.swift
//  LimitFree
//
//  Created by ice on 16/9/26.
//  Copyright © 2016年 k. All rights reserved.
//

import UIKit


//limit 界面的自定义cell

class LimitCell: UITableViewCell {
    
    @IBOutlet weak var bgImageView: UIImageView!
    
    @IBOutlet weak var appImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
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
        
        //将视图的转为圆角矩形 //需要将裁剪置为true
        appImageView.layer.cornerRadius = 10
        appImageView.clipsToBounds = true
        
        appImageView.kf_setImageWithURL(url!)
        
        //self.layer.cornerRadius = 6
        
        //名字
        nameLabel.text = "\(index)." + model.name!
        
        //日期
        let index = model.expireDatetime?.endIndex.advancedBy(-2)
        let expireDateStr = model.expireDatetime?.substringToIndex(index!)
        
        //字符串转时间
        let df = NSDateFormatter()
        
        //HH 24小时制 hh 12小时制
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //转成时间
        let expireDate = df.dateFromString(expireDateStr!)
        
        //日历对象
        let cal = NSCalendar.currentCalendar()
        /*
        计算两个日期时间 的时间差
        
        参数一:需要的时间差包含的单元(年/月/日/时/分/秒)
        参数二:开始时间
        参数三:结束时间
        参数四;选项(0)
        */
        
        let unit = NSCalendarUnit(rawValue: NSCalendarUnit.Hour.rawValue | NSCalendarUnit.Minute.rawValue | NSCalendarUnit.Second.rawValue)
        
        let dateComps = cal.components(unit, fromDate: NSDate(), toDate: expireDate!, options: NSCalendarOptions.MatchStrictly)
        
        timeLabel.text = String(format: "剩余:%02ld:%02ld:%02ld", dateComps.hour,dateComps.minute,dateComps.second)
        
        //原价
        let priceStr = "￥:" + model.lastPrice!
        lastPriceLabel.text = priceStr
        
        //横线
        if lineView == nil{
            lineView = UIView(frame: CGRectMake(0,10,60,1))
            lineView!.backgroundColor = UIColor.blackColor()
            lastPriceLabel.addSubview(lineView!)
        }
        
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
