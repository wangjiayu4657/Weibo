//
//  NetWorkTools.swift
//  WeiBo
//
//  Created by fangjs on 2016/11/16.
//  Copyright © 2016年 fangjs. All rights reserved.
//

import UIKit
import AFNetworking

class NetWorkTools: AFHTTPSessionManager {

    ///初始化一个单例
    static let tools:NetWorkTools = {
        // 注意: baseURL一定要以/结尾
        let url = URL(string: "https://api.weibo.com/")
        let tool = NetWorkTools(baseURL: url)
        // 设置AFN能够接收得数据类型
        tool.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain") as? Set<String>
        return tool
    }()
    
    ///获取单例的方法
    class func shareNetWorkTools()-> NetWorkTools{
        return tools
    }
 
}
