//
//  LimitModel.swif  LimitFree
//  Created by ice on 16/9/26.
//  Copyright © 2016年 k. All rights reserved.

import UIKit

class LimitModel: NSObject {

    var applicationId: String?
    var slug: String?
    var name: String?
    
    var releaseDate: String?
    var version: String?
    var desc: String?
    
    var categoryId: NSNumber?
    var categoryName: String?
    var iconUrl: String?
    
    var itunesUrl: String?
    var starCurrent: String?
    var starOverall: String?
    
    var ratingOverall: String?
    var downloads: String?
    var currentPrice: String?
    
    var lastPrice: String?
    var priceTrend: String?
    var expireDatetime: String?
    
    var releaseNotes: String?
    var updateDate: String?
    var fileSize: String?
    
    var ipa: String?
    var shares: String?
    var favorites: String?
    
    
    //解决属性和父类方法的冲突  //kvc调用这个方法时,将desc 赋值给 self.desc
    func setDescription(desc: String){
        
        self.desc = desc
    }
    
    //使用KVC设置对象属性值  防止出错*(找不到键)
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
}
