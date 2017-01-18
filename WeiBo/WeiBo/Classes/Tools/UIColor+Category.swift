//
//  UIColor+Category.swift
//  WeiBo
//
//  Created by wangjiayu on 2016/12/7.
//  Copyright © 2016年 fangjs. All rights reserved.
//

import UIKit

extension UIColor {
    
    ///返回随机颜色
    class func randomColor() -> UIColor {
        return UIColor.init(red: randomNumber(), green: randomNumber(), blue: randomNumber(), alpha: 1.0)
    }
    ///返回随机数字
    class func randomNumber() -> CGFloat {
        return CGFloat(arc4random_uniform(256)) / CGFloat(255)
    }
    
    
}
