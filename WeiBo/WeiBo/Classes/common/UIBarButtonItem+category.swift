//
//  UIBarButtonItem+category.swift
//  WeiBo
//
//  Created by fangjs on 2016/11/7.
//  Copyright © 2016年 fangjs. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    //class 就相当于 oc 中的 "+" 类方法
    class func createNavBarButtonItem(imageName:String,target:Any?,action:Selector)->UIBarButtonItem{
        let btn = UIButton()
        btn.setImage(UIImage.init(named: imageName), for: UIControlState.normal)
        btn.setImage(UIImage.init(named: imageName + "_highlighted"), for: UIControlState.highlighted)
        btn.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        btn.sizeToFit()
        return UIBarButtonItem(customView: btn)
    }
    
    convenience init(imageName:String,target:Any?,action:String?) {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: imageName), for: UIControlState.normal)
        btn.setImage(UIImage.init(named: imageName + "_highlighted"), for: UIControlState.highlighted)
        if action != nil {
            btn.addTarget(target, action: Selector(action!), for: UIControlEvents.touchUpInside)
        }
        btn.sizeToFit()
        self.init(customView: btn)
    }
}
