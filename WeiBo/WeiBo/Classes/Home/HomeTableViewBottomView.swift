//
//  HomeTableViewBottomView.swift
//  WeiBo
//
//  Created by fangjs on 2016/11/28.
//  Copyright © 2016年 fangjs. All rights reserved.
/**  HomeTableViewCell中的底部工具条 */

import UIKit

class HomeTableViewBottomView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.lightGray
        
        //初始化 UI 界面
        setUpSubView()
    }
    
    ///初始化 UI 界面
    private func setUpSubView() {
        
        //添加子控件
        addSubview(retweetButton)
        addSubview(unlikeButton)
        addSubview(commonButton)
        //布局子控件(均等平铺)
        xmg_HorizontalTile(views: [retweetButton,unlikeButton,commonButton], insets: UIEdgeInsets())
    }
    
    //MARK:- 懒加载
    ///转发
    private lazy var retweetButton:UIButton = UIButton.createButton(imageName: "timeline_icon_retweet", title: "转发")
    ///赞
    private lazy var unlikeButton:UIButton =  UIButton.createButton(imageName: "timeline_icon_unlike", title: "赞")
    ///评论
    private lazy var commonButton:UIButton = UIButton.createButton(imageName: "timeline_icon_comment", title: "评论")
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
