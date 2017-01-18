//
//  HomeTableViewCell.swift
//  WeiBo
//
//  Created by fangjs on 2016/11/24.
//  Copyright © 2016年 fangjs. All rights reserved.
/** 微博首页面上的 cell */

import UIKit
import SDWebImage


///设置最大宽度
let width:CGFloat = UIScreen.main.bounds.width
let height:CGFloat = UIScreen.main.bounds.height

enum HomeTableViewCellType:String {
    //原创微博的 cell
    case normalCell = "normalCell"
    //转发微博的 cell
    case forwardCell = "forwardCell"
    
    //根据retweeted_status是否为空,返回对应 cell 重用的标识
    static func cellIdentifier(statuse:StatusesModel) -> String {
        return statuse.retweeted_status == nil ? HomeTableViewCellType.normalCell.rawValue : HomeTableViewCellType.forwardCell.rawValue
    }
}

class HomeTableViewCell: UITableViewCell {

    //MARK:- 属性声明
    ///配图的宽度约束
    var pictureViewWidthCons:NSLayoutConstraint?
    ///配图的高度约束
    var pictureViewHeightCons:NSLayoutConstraint?
    ///保存图片与转发正文之间的间距
    var pictureViewTopCons:NSLayoutConstraint?
    ///根据模型设置属性值
    var statuse:StatusesModel? {
        didSet {
            //给 topView 的 statuse 模型赋值
            topView.statuse = statuse
            //正文
            contentLabel.text = statuse?.text
            //计算配图尺寸
            pictureView.statuse = statuse?.retweeted_status != nil ? statuse?.retweeted_status : statuse
            let size = pictureView.caculateImageSize()
            pictureViewWidthCons?.constant = size.width
            pictureViewHeightCons?.constant = size.height
            //如果没有图片的话那么就将图片距离转发正文的间距清除
            pictureViewTopCons?.constant = (size.height == 0 ? 0 : margin)
        }
    }
    
    //MARK:- 方法的声明及实现
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //初始化 UI 界面
        setUpUI()
    }

    ///初始化 UI 界面
    func setUpUI() {
        //加载子控件
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(bottomToolBar)
        contentView.addSubview(pictureView)
        
        //布局子控件
        topView.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: contentView, size: CGSize.init(width: width, height: 60), offset: CGPoint.init(x: 0, y: margin))
        contentLabel.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: topView, size: nil, offset: CGPoint.init(x: margin, y: 2 * margin))
         contentLabel.xmg_AlignVertical(type: XMG_AlignType.BottomRight, referView: topView, size: nil, offset: CGPoint.init(x: -margin, y: 2 * margin))
        bottomToolBar.xmg_AlignVertical(type: XMG_AlignType.BottomCenter, referView: pictureView, size: CGSize.init(width: width, height: 44), offset: CGPoint.init(x: 0, y: margin))
    }
    
    ///计算行高
    func caculateCellHeight(statuse:StatusesModel) -> CGFloat {
        //给属性赋值从而调用statuse的 didSet 方法
        self.statuse = statuse
        //强制更新
        self.layoutIfNeeded()
        //返回底部工具条的最大 y 值
        return bottomToolBar.frame.maxY
    }

    //MARK:- 懒加载
    ///顶部视图
    private lazy var topView:HomeTableViewTopView = HomeTableViewTopView()
    ///正文
    lazy var contentLabel:UILabel = {
        let label = UILabel.createLabel(color: UIColor.darkGray, fontSize: 14)
        label.numberOfLines = 0
        //设置最大宽度
        label.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 2 * margin
        return label
    }()
    ///配图视图
    lazy var pictureView:HomeTableViewPictureView = HomeTableViewPictureView()
    ///底部工具条
    lazy var bottomToolBar:HomeTableViewBottomView = HomeTableViewBottomView()

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





