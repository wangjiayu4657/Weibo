//
//  user.swift
//  WeiBo
//
//  Created by fangjs on 2016/11/15.
//  Copyright © 2016年 fangjs. All rights reserved.
//  单例

import UIKit


class UserAccount: NSObject,NSCoding {
    ///access_token:用户授权的唯一票据，用于调用微博的开放接口，同时也是第三方应用验证微博用户登录的唯一票据，第三方应用应该用该票据和自己应用内的用户建立唯一影射关系，来识别登录状态，不能使用本返回值里的UID字段来做登录识别。
    var access_token:String?
    
    ///access_token的生命周期，单位是秒数。
    var expires_in:NSNumber? {
        didSet{
            expires_date = Date(timeIntervalSinceNow: expires_in as! TimeInterval)
        }
    }
    ///过期时间
    var expires_date:Date?
    ///授权用户的UID，本字段只是为了方便开发者，减少一次user/show接口调用而返回的，第三方应用不能用此字段作为用户登录状态的识别，只有access_token才是用户授权的唯一票据。
    var uid:String?
    ///用户昵称
    var screen_name:String?
    ///用户头像地址（大图），180×180像素
    var avatar_large:String?
    ///指定构造函数,将字典转为模型
    init(dict:[String:AnyObject]){
        //注意: 如果直接在初始化时赋值, 不会调用didSet
        super.init()
        //使用 KVC 之前要先调用super.init()给属性分配内存空间
        setValuesForKeys(dict)
    }
    
    ///若是类属性中找不到对应的key值，会产生崩溃，可以在类中重写setvalueforUnderdefinekey来实现
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print(key)
    }
    
    ///打印字典中的值
    override var description: String {
        //定义属性数组
        let keys = ["access_token","expires_in","uid","screen_name","avatar_large"]
        //根据属性数组,将属性转为字典
        let dict = dictionaryWithValues(forKeys: keys)
        //将字典转为字符串
        return "\(dict)"
    }
    
    ///判断用户是否已登录
    class func userLogin()-> Bool {
        return UserAccount.readAccount() != nil
    }
    
    ///获取用户信息
    func loadUserInfo(finished:@escaping (_ account:UserAccount?,_ error:Error?)->()){
        
        let path = "2/users/show.json"
        let parameter = ["access_token":access_token!,"uid":uid!]
        NetWorkTools.shareNetWorkTools().get(path, parameters: parameter, progress: { (_) in

            }, success: { (_, JSON) in
                if let dict = JSON as? [String:AnyObject] {
                    self.screen_name = dict["screen_name"] as? String
                    self.avatar_large = dict["avatar_large"] as? String
                    finished(self, nil)
                    return
                }
                finished(nil, nil)

        }) { (_, error) in
            finished(nil, error)
        }
}
    
    // MARK:- 保存和读取
    ///保存授权模型信息
    func saveAccount() {
        //拼接路径
        let filePath = "userAccount.plist".cacheDirPath()
        NSKeyedArchiver.archiveRootObject(self, toFile: filePath)
    }
    ///读取授权模型信息
    static var account:UserAccount?
    class func readAccount()-> UserAccount?{
        //判断account是否过期
        if account?.expires_date?.compare(Date()) == ComparisonResult.orderedAscending { return nil }
        //判断是否已加载过,如果加载过就直接返回,否则从沙河加载
        if account != nil { return account }
        //拼接路径
        let filePath = "userAccount.plist".cacheDirPath()
        //加载授权模型
        account = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? UserAccount
        
        return account
    }
    
    //MARK:- NSCoding协议
    ///归档
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(expires_in, forKey: "expires_in")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expires_date, forKey: "expires_date")
        aCoder.encode(screen_name, forKey: "screen_name")
        aCoder.encode(avatar_large, forKey: "avatar_large")
    }
    ///解归档
    required init?(coder aDecoder: NSCoder) {
       access_token =  aDecoder.decodeObject(forKey: "access_token") as? String
       expires_in = aDecoder.decodeObject(forKey: "expires_in") as? NSNumber
       uid = aDecoder.decodeObject(forKey: "uid") as? String
       expires_date = aDecoder.decodeObject(forKey: "expires_date") as? Date
       screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
       avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
    }
 
}

