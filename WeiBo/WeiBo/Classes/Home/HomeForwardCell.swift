
//
//  HomeForwardCell.swift
//  WeiBo
//
//  Created by fangjs on 2016/11/29.
//  Copyright © 2016年 fangjs. All rights reserved.
/** HomeTableViewCell的子类: 用来显示及布局转发的微博配图 */

import UIKit

class HomeForwardCell: HomeTableViewCell {
    
    /// 重写父类属性的didSet并不会覆盖父类的操作
    /// 只需要在重写方法中, 做自己想做的事即可
    /// 注意点: 如果父类是didSet, 那么子类重写也只能重写didSet
    override var statuse:StatusesModel? {
        didSet {
            let name = statuse?.user?.name ?? ""
            let text = statuse?.retweeted_status?.text ?? ""
            forwardLabel.text = name + ": " + text
        }
    }
    
    override func setUpUI() {
        super.setUpUI()
        
        //添加子控件
        contentView.insertSubview(forwardButton, belowSubview: pictureView)
        contentView.insertSubview(forwardLabel, aboveSubview: forwardButton)
        
        //布局子控件
        forwardButton.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: contentLabel, size: nil, offset: CGPoint.init(x: -margin, y: margin))
        forwardButton.xmg_AlignVertical(type: XMG_AlignType.TopRight, referView: bottomToolBar, size: nil)
        
        forwardLabel.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: forwardButton, size: nil, offset: CGPoint.init(x: margin, y: margin))
        
        //调整图片的位置
        let cons = pictureView.xmg_AlignVertical(type: XMG_AlignType.BottomCenter, referView: forwardLabel, size: CGSize.zero, offset: CGPoint.init(x: 0, y: margin))
        pictureViewWidthCons = pictureView.xmg_Constraint(constraintsList: cons, attribute: NSLayoutAttribute.width)
        pictureViewHeightCons = pictureView.xmg_Constraint(constraintsList: cons, attribute: NSLayoutAttribute.height)
        pictureViewTopCons = pictureView.xmg_Constraint(constraintsList: cons, attribute: NSLayoutAttribute.top)  
    }
    
    //MARK:- 懒加载
    ///转发正文
    private lazy var forwardLabel:UILabel = {
        let label = UILabel.createLabel(color: UIColor.darkGray, fontSize: 14)
        label.numberOfLines = 0
        //设置最大宽度
        label.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 2 * margin
        return label
    }()
    ///转发背景
    private lazy var forwardButton:UIButton = {
       let btn = UIButton()
       btn.backgroundColor = UIColor.init(white: 0.95, alpha: 1.0)
       return btn
    }()

}
