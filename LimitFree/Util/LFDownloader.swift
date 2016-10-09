
// LFDownloader.swift  LimitFree Created by ice on 16/9/26.
//  Copyright © 2016年 k. All rights reserved.

import UIKit



//下载的类型
public enum DownloadType: Int{
    
    case Default
    case Detail   //详情数据
    case NearBy    //详情页的附近
}


protocol LFDownloaderDelegate:NSObjectProtocol{
    
    //下载失败
    func downloader(downloder: LFDownloader, didFailWithError error: NSError)
    
    //下载成功
    func downloader(downloader: LFDownloader, didFinishWithData data: NSData)
    
}


class LFDownloader: NSObject {
    
    //下载类型
    var type: DownloadType = .Default
    
    weak var delegate: LFDownloaderDelegate?
    
    //获取缓存文件的路径
    func cachePath(urlString: String) -> String{
        
        let fileName = NSString(string: urlString).MD5Hash() //加密
        
        let docDicr = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last
        
        return docDicr! + "/" + fileName
    }
    
    
    //判断是否存在缓存
    func urlStringDataCached(urlString: String, timeOut: NSTimeInterval) -> Bool{
        
        let path = cachePath(urlString)
        
        let fm = NSFileManager.defaultManager()
        
        //利用文件管理者,,,判断文件是否存在
        if fm.fileExistsAtPath(path) {
            
            let dict = try! fm.attributesOfItemAtPath(path)
            
            let cerateDate = dict[NSFileCreationDate] as! NSDate
            
            //计算时间差
            let timeTnterval = NSDate().timeIntervalSinceDate(cerateDate)
            
            if timeTnterval < timeOut{
                return true
            }
        }
        
        return false
    }

    //下载方法
    func downloadWithURLString(urlString: String){
        
        //判断是否有缓存,且超时时间为24小时
        if urlStringDataCached(urlString, timeOut: 30){
            
            //如果有缓存 就读缓存文件
            
            let path = cachePath(urlString)
        
            //读文件
            let data = NSData(contentsOfFile: path)
            delegate?.downloader(self, didFinishWithData: data!)
            
            
        }else{
            
            //没有缓存 发送网络请求
            let url = NSURL(string: urlString)
            
            let request = NSURLRequest(URL: url!)
            
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
                
                //此处对self没有弱引用,,,因为这块下载是一个新的线程(异步),所以在LimitFreeViewController中调用downloadData()方法中创建的 d 实例在方法完成后直接释放d实例,,,而下载这块在另一个线程中运行,所以此时强解包self  会崩溃   //若果是强引用,d就不会释放,也不会崩溃
                if let tmpError = error{
                    //下载失败
                    
                    self.delegate?.downloader(self, didFailWithError: tmpError)
                    
                }else{
                    
                    let httpResponse = response as! NSHTTPURLResponse
                    
                    if httpResponse.statusCode == 200{
                        
                        //下载成功
                        self.delegate?.downloader(self, didFinishWithData: data!)
                        
                        //存缓存
                        let path = self.cachePath(urlString)
                        
                        try! data?.writeToFile(path, options: NSDataWritingOptions.DataWritingAtomic)
                        
                    }else{
                        
                        //下载失败
                        let tmpError = NSError(domain: urlString, code: httpResponse.statusCode, userInfo: ["msg": "下载失败"])
                        
                        self.delegate?.downloader(self, didFailWithError: tmpError)
                    }
                }
            }
            
            task.resume()
        }
    }
    
}
