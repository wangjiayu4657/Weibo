//
//  UILabel+Category.swift
//  WeiBo
//
//  Created by fangjs on 2016/11/24.
//  Copyright © 2016年 fangjs. All rights reserved.
//

import UIKit

///自定义 UILabel
extension UILabel {
    class func createLabel(color:UIColor, fontSize:CGFloat) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textColor = color
        label.sizeToFit()
        return label
    }
}
