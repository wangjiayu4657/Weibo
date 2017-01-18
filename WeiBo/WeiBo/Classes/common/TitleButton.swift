//
//  titleButton.swift
//  WeiBo
//
//  Created by fangjs on 2016/11/7.
//  Copyright © 2016年 fangjs. All rights reserved.
//

import UIKit

class TitleButton: UIButton {

   override init(frame: CGRect) {
        super.init(frame: frame)
        setImage(UIImage.init(named: "navigationbar_arrow_up"), for: UIControlState.normal)
        setImage(UIImage.init(named: "navigationbar_arrow_down"), for: UIControlState.selected)
        setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///布局子控件
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = titleLabel!.bounds.width
    }

}
