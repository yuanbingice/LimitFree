//
//  LFDBManger.swift
//  LimitFree
//
//  Created by ice on 16/9/29.
//  Copyright © 2016年 k. All rights reserved.
//

import UIKit

//数据库的操作

class LFDBManger: NSObject {

    var myQueue: FMDatabaseQueue?
    
    class var shareManager: LFDBManger?{
        
        struct Static {

            static var onceToken: dispatch_once_t = 0
            static var instance: LFDBManger? = nil
        }
        
        dispatch_once(&Static.onceToken) { () -> Void in
            
            Static.instance = LFDBManger()
        }
        return Static.instance
    }
    
    
    override init() {
        
        //初始化数据库
        
        //1.文件的路径
        let cacheDir = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last
        
        let path = cacheDir?.stringByAppendingString("/collect.db")
        
        //print(path!)
        
        //创建队列
        myQueue = FMDatabaseQueue(path: path)
        
        
        //创建表格
        myQueue?.inDatabase({ (database) -> Void in
        
            let createSql = "create table if not exists collect (collectId integer primary key autoincrement, applicationId varchar(255), name varchar(255), headImage blob)"
            let flag = database.executeUpdate(createSql, withArgumentsInArray: nil)
        
            if flag != true{
            
                print(database.lastErrorMessage())
            }
       })
        
    }
    
    //收藏
    func addCollect(model: CollectModel, finishClosure: (Bool) -> Void){
        
        myQueue?.inDatabase({ (database) -> Void in
            
            let insertSql = "insert into collect (applicationId, name, headImage) values (?, ?, ?)"
            //UIImage转为data
            let data = UIImagePNGRepresentation(model.headImage!)
            let flag = database.executeUpdate(insertSql, withArgumentsInArray: [model.applicationId!, model.name!, data!])
            
            if flag != true{
                
                print(database.lastErrorMessage())
            }
            
            //使用闭包将 flag 传入详情页面(详情页面根据flag的不同执行不同的代码)
            finishClosure(flag)
        })
    }
    
    //判断某个应用是否 已收藏  //闭包用来将 flag 传过去(传值)  //这是因为闭包在其他线程执行
    func isAppFavorite(appId: String, resultClosure: (Bool -> Void)){
        
        myQueue?.inDatabase({ (database) -> Void in
            
            let sql = "select * from collect where applicationId = ?"
            //只有查询用executeQuery
            let rs = database.executeQuery(sql, withArgumentsInArray: [appId])
            
            if rs.next() {
                //已经收藏
                resultClosure(true)
                
            }else{
                
                //没有收藏
                resultClosure(false)
            }
            
            rs.close()
        })
        
    }
    
    //查询数据的方法  //闭包用来传参
    func searchAllCollectiData( resultClosure: (Array<CollectModel> -> Void)){
        
        myQueue?.inDatabase({ (database) -> Void in
            
            let sql = "select * from collect"
            
            //只有查询用executeQuery
            let rs = database.executeQuery(sql, withArgumentsInArray: nil)
            
            var tmpArray = Array<CollectModel>()
            while rs.next(){
                
                let model = CollectModel()
                
                model.collectId = Int(rs.intForColumn("collectId"))
                
                model.applicationId = rs.stringForColumn("applicationId")
                model.name = rs.stringForColumn("name")
                
                let data = rs.dataForColumn("headImage")
                
                model.headImage = UIImage(data: data)
                
                tmpArray.append(model)
                
            }
            
            resultClosure(tmpArray)
            
            rs.close()
        })
        
    }
    
    //删除的方法  //闭包用来传值,利用得到的flag 执行相应的代码
    func deleteWithAppId(appId: String, resuletClosure: (Bool -> Void)){
        
        myQueue?.inDatabase({ (database) -> Void in
            
            let sql = "delete from collect where applicationId = ?"
            let flag = database.executeUpdate(sql, withArgumentsInArray: [appId])
            
            if flag == false{
                
                print(database.lastErrorMessage())
            }
            
            resuletClosure(flag)
        })
        
    }
    
    
    
}
