//
//  UIImage+Category.swift
//  WeiBo
//
//  Created by fangjs on 2016/11/24.
//  Copyright © 2016年 fangjs. All rights reserved.
//

import UIKit

extension UIImage {
     ///设置原型图片
     func circleImage() -> UIImage {
        //开启上下文
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        //获取上下文
        let ctx:CGContext = UIGraphicsGetCurrentContext()!
        //设置圆形区域
        let rect:CGRect = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
        ctx.addEllipse(in: rect)
        //裁剪
        ctx.clip()
        //将裁剪后的图片画上去
        draw(in: rect)
        //获取处理完的图片
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        //关闭上下文
        UIGraphicsEndImageContext()
        return image
    }
}
