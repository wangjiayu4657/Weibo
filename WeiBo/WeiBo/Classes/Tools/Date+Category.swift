//
//  Date+Category.swift
//  WeiBo
//
//  Created by fangjs on 2016/11/25.
//  Copyright © 2016年 fangjs. All rights reserved.
//

///时间格式
// 刚刚(一分钟内)
// X分钟前(一小时内)
// X小时前(当天)
// 昨天 HH:mm(昨天)
// MM-dd HH:mm(一年内)
// yyyy-MM-dd HH:mm(更早期)


import UIKit

extension Date {
    ///将服务器返回的时间字符串转换为 Date
    static func dateWithString(time:String) -> Date { 
        //创建 formatter
        let formatter = DateFormatter()
        //设置时间
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z yyyy"
        //设置时间的区域(真机必须设置,否则可能不能转换成功)
        formatter.locale = Locale.init(identifier: "en")
        //转换字符串,转换好的时间的去除时区的时间
        let createDate = formatter.date(from: time)!
        return createDate
    }
    
    ///返回对应格式的时间
    var descDate:String {
        
        //创建日历对象
        let calendar = Calendar.current
        
        //判断是否是今天
        if calendar.isDateInToday(self) {
            //获取当前时间与系统时间之间的时间差
            let sinceTime = Int(Date.init().timeIntervalSince(self))
            //判断是否是刚刚
            if sinceTime < 60 { return "刚刚" }
            //判断是否是 x 分钟之前
            if sinceTime < (60 * 60) { return "\(sinceTime/60) 分钟前" }
            //判断是否是 x 小时之前
            return "\(sinceTime / (60 * 60)) 小时前"
        }
        
        //判断是否是昨天,设置昨天的时间格式: (昨天 HH:mm)
        var formatterString = "HH:mm"
        if calendar.isDateInYesterday(self) {
            formatterString = "昨天 " + formatterString
        
        } else {
            //设置一年内的时间显示格式: (MM-dd HH:mm)
            formatterString = "MM:dd " + formatterString
            //设置更早时间的时间显示格式: (yyyy-MM-dd HH:mm)
            let comps = calendar.dateComponents([Calendar.Component.year], from: self, to: Date.init())
            if  comps.year! >= 1 {
                formatterString = "yyyy:" + formatterString
            }
        }
        
        //按指定的格式将时间转换为字符串
        let formatter = DateFormatter()
        //设置时间格式
        formatter.dateFormat = formatterString
        //设置时间的区域(真机必须设置,否则可能不会转化成功)
        formatter.locale = Locale.init(identifier: "en")
        //返回格式化的时间
        return formatter.string(from: self)
    }
}
