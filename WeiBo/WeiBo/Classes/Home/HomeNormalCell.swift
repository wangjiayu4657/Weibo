//
//  HomeNormalCell.swift
//  WeiBo
//
//  Created by fangjs on 2016/11/29.
//  Copyright © 2016年 fangjs. All rights reserved.
/** HomeTableViewCell的子类: 用来显示及布局原始微博配图 */

import UIKit

class HomeNormalCell: HomeTableViewCell {

    override func setUpUI() {
        super.setUpUI()
        
        let cons = pictureView.xmg_AlignVertical(type: XMG_AlignType.BottomCenter, referView: contentLabel, size: CGSize.zero, offset: CGPoint.init(x: 0, y: margin))
        pictureViewWidthCons = pictureView.xmg_Constraint(constraintsList: cons, attribute: NSLayoutAttribute.width)
        pictureViewHeightCons = pictureView.xmg_Constraint(constraintsList: cons, attribute: NSLayoutAttribute.height)
        pictureViewTopCons = pictureView.xmg_Constraint(constraintsList: cons, attribute: NSLayoutAttribute.top)
    }
}
