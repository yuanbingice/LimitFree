//  DetailModel.swift  LimitFree  Created by ice on 16/9/27.
//  Copyright © 2016年 k. All rights reserved.


import UIKit

class DetailModel: NSObject {
    
    var applicationId: String?
    var appurl: String?
    var categoryId: NSNumber?
    
    var categoryName: String?
    var currentPrice: String?
    var currentVersion: String?
    //设置该键(description)时 利用该方法设置
    func setDescription(desc: String){
        
        self.desc = desc
    }
    
    var desc: String?
    var description_long: String?
    var downloads: NSObject?
    
    var expireDatetime: String?
    var fileSize: String?
    var iconUrl: String?
    
    var itunesUrl: String?
    var language: String?
    var lastPrice: String?
    
    var name: String?
    var newversion: String?
    var photos: Array<PhotoModel>?  ////////
    
    var priceTrend: String?
    var ratingOverall: String?
    var releaseDate: String?
    
    var releaseNotes: String?
    var sellerId: String?
    var sellerName: String?
    
    var slug: String?
    var starCurrent: String?
    var starOverall: String?
    
    var systemRequirements: String?
    var updateDate: String?
    
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
}

//DetailModel数据模型中photos 是一个数组(包含字典),所以在定义一数组中内容的小模型
class PhotoModel: NSObject {
    
    var originalUrl: String?
    var smallUrl: String?
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
        
    }
    
}
