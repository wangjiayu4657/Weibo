//
//  User.swift
//  WeiBo
//
//  Created by fangjs on 2016/11/23.
//  Copyright © 2016年 fangjs. All rights reserved.
/** 用户信息数据模型 */

import UIKit

class User: NSObject {
    /// 用户ID
    var id: Int = 0
    /// 友好显示名称
    var name: String?
    /// 用户头像地址（中图），50×50像素
    var profile_image_url: String?{
        didSet {
            if let urlStr = profile_image_url {
                imageURL = URL.init(string: urlStr)
            }
        }
    }
    ///保存转化为URL用户头像的地址
    var imageURL:URL?
    /// 时候是认证, true是, false不是
    var verified: Bool = false
    /// 用户的认证类型，-1：没有认证，0，认证用户，2,3,5: 企业认证，220: 达人
    var verified_type: Int = -1 {
        didSet{
            switch verified_type {
            case 0:
                verifiedImage = UIImage.init(named: "avatar_vip")?.circleImage()
            case 2,3,5:
                verifiedImage = UIImage.init(named: "avatar_enterprise_vip")?.circleImage()
            case 220:
                verifiedImage = UIImage.init(named: "avatar_grassroot")?.circleImage()
            default:
                verifiedImage = nil
            }
        }
    }
    ///根据用的认证类型来设置对应的图片
    var verifiedImage:UIImage?
    ///会员等级
    var mbrank: Int = 0 {
        didSet {
            if mbrank > 0 && mbrank < 7 {
                mbrankImage = UIImage.init(named: "common_icon_membership_level\(mbrank)")
            }
        }
    }
    ///根据会员等级设置对应的图标
    var mbrankImage:UIImage?
    
    ///字典转模型
    init(dictionary:[String:AnyObject]) {
        super.init()
        setValuesForKeys(dictionary)
    }
    ///当找不到对应的 key 时执行这个方法,不重写这个方法的话,如果找不到对应的 key 时会崩溃
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    let list = ["id","name","profile_image_url","verified","verified_type","mbrank"]
    ///根据 list 中的 key打印字典中的对应的值
    override var description:String {
        let dict = dictionaryWithValues(forKeys: list)
        return "\(dict)"
    }
}
