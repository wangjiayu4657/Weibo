//
//  UIButton+Category.swift
//  WeiBo
//
//  Created by fangjs on 2016/11/24.
//  Copyright © 2016年 fangjs. All rights reserved.
//

import UIKit

extension UIButton {
    class func createButton(imageName:String, title:String) -> UIButton{
        let btn = UIButton()
        btn.setImage(UIImage.init(named: imageName), for: UIControlState.normal)
        btn.setBackgroundImage(UIImage.init(named: "timeline_card_bottom_background"), for: UIControlState.normal)
        btn.setTitle(title, for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, margin, 0, 0)
        return btn
    }
}
