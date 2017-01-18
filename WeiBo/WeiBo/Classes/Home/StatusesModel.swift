//
//  StatusesModel.swift
//  WeiBo
//
//  Created by fangjs on 2016/11/23.
//  Copyright © 2016年 fangjs. All rights reserved.
/** 数据模型 */

import UIKit
import SDWebImage

class StatusesModel: NSObject {
    ///微博创建时间
    var created_at:String? {
        didSet {
            //将时间字符串转换为 Date
            let date = Date.dateWithString(time: created_at!)
            //将转化好的对应格式的时间字符串赋值给created_at
            created_at = date.descDate
        }
    }
    ///微博ID
    var id:Int = 0
    ///微博信息内容
    var text:String?
    ///微博来源
    var source:String? {
        didSet {
            if let sourceString = source  {
                if sourceString == "" { return }
                //先将 String 转换为 NSString
                let sourceString = sourceString as NSString
                //获取要截取字符串的起始位置
                let startLocation: Int = sourceString.range(of: ">").location + 1
                //获取要截取字符串的结束位置
                let endLocation: Int  = sourceString.range(of: "</").location
                //获取要截取字符串的长度
                let length: Int  = endLocation - startLocation
                //截取并拼接字符串
                source = "来自: " + sourceString.substring(with: NSRange.init(location: startLocation, length: length))
            }
        }
    }
    ///缩略图片地址，没有时不返回此字段
    var pic_urls:[[String:AnyObject]]? {
        didSet {
            //初始化数组
            storePicURLs = [URL]()
            bigStorePicURLs = [URL]()
            //遍历pic_urls
            for  dict in pic_urls! {
                //取出图片的地址
                let url = dict["thumbnail_pic"] as! String
                //将图片地址字符串转换为 URL并存在数组storePicURLs中
                storePicURLs?.append(URL.init(string: url)!)
                //获取大图地址
                bigStorePicURLs?.append(URL.init(string: url.replacingOccurrences(of: "thumbnail", with: "large"))!)
            }
        }
    }
    
    var storePicURLs:[URL]?
    var bigStorePicURLs:[URL]?
    ///User 模型
    var user:User?
    ///转发微博
    var retweeted_status:StatusesModel?
    //如果有转发,原创就没有配图
    /// 定义一个计算属性, 用于返回原创获取配图的URL数组 or 转发获取的配图数组(缩略图)
    var pictureURLs:[URL]? {
        return retweeted_status == nil ? storePicURLs : retweeted_status?.storePicURLs
    }
    /// 定义一个计算属性, 用于返回原创获取配图的URL数组 or 转发获取的配图数组(大图)
    var biPictureURLs:[URL]? {
        return retweeted_status == nil ? bigStorePicURLs : retweeted_status?.bigStorePicURLs
    }
    
    ///获取当前登录用户及其所关注（授权）用户的最新微博
    class func loadInfo(sinceId: Int,maxId:Int,finished:@escaping (_ statuse:[StatusesModel]?,_ error:Error?)->()) {
        let path = "2/statuses/home_timeline.json"
        var parameters = ["access_token":UserAccount.readAccount()!.access_token!]
        //下拉刷新,如果 sinceId > 0 则说明有新的微博
        if sinceId > 0 {
            parameters["since_id"] = "\(sinceId)"
        }
        if maxId > 0 {
            //max_id: 会返回小于等于max_id的微博,maxId-1 是将重复的微博过滤
            parameters["max_id"] = "\(maxId - 1)"
        }
        NetWorkTools.shareNetWorkTools().get(path, parameters: parameters, progress: { (_) in

            }, success: { (_, JSON) in
                //先把 JSON:Any? 类型转换为字典[String:AnyObject]类型
              let dict = JSON as! [String:AnyObject]
                //将字典类型转换为数组[[String:AnyObject]] 类型
              let models = dictToModel(states: dict["statuses"] as! [[String:AnyObject]])
                //缓存缩略图
                cacheImageURL(list: models, finished: finished)
        }) { (_, error) in
            finished(nil, error)
        }
    }
    
    ///缓存要展示的缩略图
    class func cacheImageURL(list:[StatusesModel], finished:@escaping (_ statuse:[StatusesModel]?,_ error:Error?)->()) {
        //下拉刷新时如果没有新数据,则回调结束刷新动画
        if list.count == 0 {
            finished(list, nil)
            return
        }
        //创建一个组
        let group = DispatchGroup.init()
        //遍历list:[StatusesModel]取出数组中的StatusesModel模型
        for statuse in list {
            //如果不满足条件就执行 else 中的语句
            guard statuse.pictureURLs != nil else { continue }
            //遍历pictureURLs[URL]取出数组中的 url
            for url in statuse.pictureURLs! {
                //将当前的下载操作添加到group中
                group.enter()
                //缓存图片
                SDWebImageManager.shared().downloadImage(with: url, options: SDWebImageOptions.init(rawValue: 0), progress: nil, completed: { (_, _, _, _, _) in
                    //离开当前group
                    group.leave()
                })
            }
        }
        //当所有操作完成离开当前 group时, group 会发送一个通知notify,然后通知调用者
        group.notify(queue: DispatchQueue.main, execute: {
            finished(list, nil)
        })
    }
    
    ///字典转模型
    init(dictionary:[String:AnyObject]) {
        super.init()
        setValuesForKeys(dictionary)
    }
    
    ///当找不到对应的 key 时执行这个方法,不重写这个方法的话,如果找不到对应的 key 时会崩溃
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if "user" == key {
            user = User.init(dictionary: value as! [String : AnyObject])
            return
        }
        if "retweeted_status" == key {
            retweeted_status = StatusesModel.init(dictionary: value as! [String : AnyObject])
            return
        }
        super.setValue(value, forKey: key)
    }
    
    let list = ["created_at","id","text","source","pic_urls"]
    ///根据 list 中的 key打印字典中的对应的值
    override var description:String {
        let dict = dictionaryWithValues(forKeys: list)
        return "\(dict)"
    }
    
    /// 将字典数组转换为模型数组
    private class func dictToModel(states:[[String:AnyObject]]) ->[StatusesModel] {
        //声明一个[StatusesModel]类型的数组
        var models = [StatusesModel]()
        //遍历数组,将数组内的字典转化为模型并存储在数组中
        for dict in states {
            models.append(StatusesModel(dictionary: dict))
        }
        return models
    }

}
