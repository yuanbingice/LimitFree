//  DetailViewController.swift LimitFree
//  Created by ice on 16/9/27.
//  Copyright © 2016年 k. All rights reserved.

import UIKit
import CoreLocation

//app 的详情页面, 无论从哪点击的app  进入的都是这个页面

class DetailViewController: LFNavViewController {
    
    //用的id
    var appId: String?
    
    private var manger: CLLocationManager?
    
    //详情的数据
    private var detailModel: DetailModel?
    
    //下载详情是否成功
    private var detailSuccess: Bool?
    
    //下载附近是否成功
    private var nearBySuccess: Bool?
    
    //是否已经下载附近数据
    private var isNearByDown: Bool?
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var lastPriceLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var appImageView: UIImageView!
    
    @IBOutlet weak var sizeLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var rateLabel: UILabel!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var downloadButton: UIButton!
  
    @IBOutlet weak var imageScrollView: UIScrollView!
    
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var nearByScrollView: UIScrollView!

    
    //分享
    @IBAction func shareAction(sender: AnyObject) {
        
        
    }
    
    //收藏
    @IBAction func favoriteAction(sender: AnyObject) {
        
        //图片数据下载完成后才能收藏
        if appImageView.image != nil{
            
            //获取数据并赋值(收藏的数据)
            let model = CollectModel()
            model.applicationId = detailModel?.applicationId
            model.name = detailModel?.name
            model.headImage = appImageView.image
            
            
            let dbManager = LFDBManger()
            
            //闭包是根据 获得的flag 来执行不同的代码
            dbManager.addCollect(model, finishClosure: { (flag) -> Void in
                
                if flag == true{
                    
                    MyUtil.showAllertMsg("收藏成功", onViewController: self)
                    
                    //收藏后 改变按钮的状态
                    self.refreshAppState()
                    
                }else{
                    
                    MyUtil.showAllertMsg("收藏失败", onViewController: self)
                }
            })
        
        }else{
            
            MyUtil.showAllertMsg("数据正在加载中,请稍后收藏", onViewController: self)
        }
        
    }
    //下载
    @IBAction func downloadAction(sender: AnyObject) {
    
        //打开appstore
        if detailModel?.itunesUrl != nil{
            
            let url = NSURL(string: (detailModel?.itunesUrl)!)
            
            if UIApplication.sharedApplication().canOpenURL(url!){
                
                UIApplication.sharedApplication().openURL(url!)
            }
        }
        
    }

    //下载详情数据
    func downloadDetailData(){
        
        let urlString = String(format: kDetailUrl, appId!)
        
        let d = LFDownloader()
        
        d.delegate = self
        
        d.type = .Detail
        
        d.downloadWithURLString(urlString)
        
    }
    
    
    //判断是否收藏  //一进入详情页面 就 判断
    func verityAppState(){
        
        let dbManager = LFDBManger()
        
        //闭包也是  利用函数得出的flag 标记  来执行响应的代码
        dbManager.isAppFavorite(appId!) { (flag) -> Void in
            
            if flag == true{
            
                //如果收藏  // 改变按钮的状态,不能再点击
                self.refreshAppState()
            }
        }
        
    }
    
    //如果已经收藏,修改收藏按钮的显示
    func refreshAppState(){
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
        
            self.favoriteButton.setTitle("已收藏", forState: .Normal)
            self.favoriteButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
            self.favoriteButton.enabled = false
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //显示加载的进度
        ProgressHUD.showOnView(view)
        
        //创建导航条上的
        createMyNav()
        
        //下载详情
        downloadDetailData()
        
        //定位 ,,,会在代理方法内下载 附近的数据
        locate()
        
        verityAppState()  //核对 app的状态,如果收藏了,就讲收藏按钮置为 灰色并禁止点击
        
    }
    
    
    //定位   //需要在info.plist 写 NSLocationWhenInUseUsageDescription
    func locate(){
        
        manger = CLLocationManager()
        
        manger?.distanceFilter = 10  //隔10米进行定位
        manger?.desiredAccuracy = kCLLocationAccuracyBest  //最早的定位精度
        
        if manger?.respondsToSelector("requestWhenInUseAuthorization") == true {
            
            manger?.requestWhenInUseAuthorization()
        }
        
        manger?.delegate = self
        
        //开始定位
        manger?.startUpdatingLocation()
        
    }
    
    
    //导航
    func createMyNav(){
        
        addNavTitle("应用详情")
        
        //调用创建返回按钮的方法
        addBackBtn()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //显示详情的数据   //
    func showDetail(){
        
        let url = NSURL(string: (detailModel?.iconUrl)!)
        appImageView.kf_setImageWithURL(url!)
        
        nameLabel.text = detailModel?.name
        
        lastPriceLabel.text = "原价:" + (detailModel?.lastPrice)!
        
        //状态
        if detailModel?.priceTrend  == "limited"{
            
            statusLabel.text = "限免中"
        }else if detailModel?.priceTrend == "sales"{
            
            statusLabel.text = "降价中"
        }else if detailModel?.priceTrend == "free"{
         
            statusLabel.text = "免费中"
        }
        
        sizeLabel.text = (detailModel?.fileSize)! + "MB"
        
        //类型
        categoryLabel.text = MyUtil.transferCateName((detailModel?.categoryName)!)
        
        rateLabel.text = "评分: " + (detailModel?.starCurrent)!
        
        //app的截图
        let cnt = detailModel?.photos?.count
        let imageH: CGFloat = 80    //图片的高度
        let imageW: CGFloat = 80    //图片的宽度
        let marginX: CGFloat = 10   //图片的横向间距
        for i in 0..<cnt!{
            
            let frame = CGRectMake(CGFloat(imageW + marginX) * CGFloat(i), 0, imageW, imageH)
            let tmpImageView = UIImageView(frame: frame)
            
            //图片
            let pModel = detailModel?.photos![i]
            let url = NSURL(string: (pModel?.smallUrl)!)
            tmpImageView.kf_setImageWithURL(url!)
            
            
            let t = UITapGestureRecognizer(target: self, action: "tapImageAction:")
            tmpImageView.userInteractionEnabled = true
            tmpImageView.addGestureRecognizer(t)
        
            //设置tag值
            tmpImageView.tag = 100 + i
            
            imageScrollView.addSubview(tmpImageView)
        }
        
        
        imageScrollView.contentSize = CGSizeMake((imageW + marginX)*CGFloat(cnt!), 0)
        
        descLabel.text = detailModel?.desc
        
    }
    
    func tapImageAction(g: UIGestureRecognizer){
        
        let index = (g.view?.tag)! - 100
        
        let photoCtrl = PhotoViewController()
        photoCtrl.photoIndex = index
        
        photoCtrl.photoArray = detailModel?.photos
        
        photoCtrl.modalTransitionStyle = .FlipHorizontal
        presentViewController(photoCtrl, animated: true, completion: nil)
        
    }
    
    //详情的解析
    func parseDetailDate(data: NSData){
        let result =  try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
        
        if result.isKindOfClass(NSDictionary){
            
            let dict = result as! Dictionary<String,AnyObject>
            
            detailModel = DetailModel()
            detailModel!.setValuesForKeysWithDictionary(dict)
            //此时设置完detailModel?.photos 是一个数字组(里面又是字典)
            
            //将photos里面的字典转化成对象
            var pArray = Array<PhotoModel>()
            //遍历数组
            for pDict in (dict["photos"] as! NSArray){
                
                let model = PhotoModel()
                
                model.setValuesForKeysWithDictionary(pDict as! [String : AnyObject])
                //给小的模型赋值并组合起来
                pArray.append(model)
                
            }
            //将全部组合的小模型赋值给 detailModel?.photos
            detailModel?.photos = pArray
            
            //修改界面 //显示详情的数据
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.showDetail()
            })
        }
        
    }
    
    //附近数据的解析
    func parseNearByData(data: NSData){
        
        let result = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
        
        if result.isKindOfClass(NSDictionary){

            let dict = result as! Dictionary<String, AnyObject>
            var  modelArray = Array<LimitModel>()
            let array = dict["applications"] as! Array<Dictionary<String, AnyObject>>
            
            for appDict in array{
                
                let model = LimitModel()
                
                model.setValuesForKeysWithDictionary(appDict)
                
                modelArray.append(model)
            }
            
            //显示数据
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.showNearData(modelArray)
            })
        }
        
    }
    
    //显示附近的数据
    func showNearData(array: Array<LimitModel>){
        
        let btnW:CGFloat = 60  //按钮的宽度和高度
        let btnH:CGFloat = 80
        let marginX:CGFloat = 10  //按钮横向的间距
        
        for i in 0..<array.count{
            
            let model = array[i]
            
            let btn = NearbyButton(frame: CGRectMake((btnW+marginX)*CGFloat(i),0,btnW,btnH))
            
            btn.addTarget(self, action: "clickBtn:", forControlEvents: .TouchUpInside)
            
            btn.model = model
            nearByScrollView.addSubview(btn)
        }
    
        nearByScrollView.contentSize = CGSizeMake((btnH+marginX)*CGFloat(array.count),0)
        
    }
    
    //点击附近的app,进入相应的详情界面
    func clickBtn(btn: NearbyButton){
        
        //跳转详情
        let detailCtrl = DetailViewController()
        
        detailCtrl.appId = btn.model?.applicationId
        //防止进去附近的详情页面后 返回会显示标签栏
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailCtrl, animated: true)
    }
   
    
}


//MARK:LFDownloaderDelegate
extension DetailViewController:LFDownloaderDelegate{
    
    func downloader(downloder: LFDownloader, didFailWithError error: NSError) {
        
        if downloder.type == .Detail{
            
            detailSuccess = false
            
        }else if downloder.type == .NearBy{
            
            nearBySuccess = false
        }
        
        
        if detailSuccess == false && nearBySuccess == false{
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                ProgressHUD.hideAfterFailOnView(self.view)
            })
        }
    }
    
    func downloader(downloader: LFDownloader, didFinishWithData data: NSData) {
        
        if downloader.type == .Detail{
            
            //详情数据
            parseDetailDate(data)
            
            detailSuccess = true
            
        }else if downloader.type == .NearBy{
            //附近的数据
            parseNearByData(data)
            
            nearBySuccess =  true
        }
        //如果两个都失败,就是失败   否则就是下载成功
        if detailSuccess == false && nearBySuccess == false{
            
            //下载失败
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                ProgressHUD.hideAfterFailOnView(self.view)
            })
            
        }else{
            
            //下载成功
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                ProgressHUD.hideAfterSuccessOnView(self.view)
            })
            
        }
    }
    
    
}


//MARK: CLLocationManagerDelegate

extension DetailViewController: CLLocationManagerDelegate{
    
    //如果定位失败,可以利用此方法来判断
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    //更新定位
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let loc = locations.last
        
        //如果经纬度有值就可以获取
        if loc?.coordinate.latitude != nil && loc?.coordinate.longitude != nil && (isNearByDown != true){
            
            let urlString = String(format: kNearByUrl, (loc?.coordinate.longitude)!,(loc?.coordinate.latitude)!)
            
            let d = LFDownloader()
            
            d.delegate = self
            
            d.type = .NearBy
            
            d.downloadWithURLString(urlString)
            
            manager.stopUpdatingLocation()
            
            isNearByDown = true  //因为会重复定位, 但只需要一次下载数据
        }
    }
    
    
}