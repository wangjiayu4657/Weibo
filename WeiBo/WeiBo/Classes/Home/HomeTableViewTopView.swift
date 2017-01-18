//
//  HomeTableViewTopView.swift
//  WeiBo
//
//  Created by fangjs on 2016/11/28.
//  Copyright © 2016年 fangjs. All rights reserved.
/**  HomeTableViewCell中的顶部自定义的 view */

import UIKit

class HomeTableViewTopView: UIView {
    
    var statuse:StatusesModel? {
        didSet {
            nameLabel.text = statuse?.user?.name
            timeLabel.text = statuse?.created_at
            sourceLabel.text = statuse?.source
            iconView.sd_setImage(with: statuse?.user?.imageURL, placeholderImage: UIImage.init(named: "avatar_default_big")?.circleImage())
            verifiedView.image = statuse?.user?.verifiedImage
            vipView.image = statuse?.user?.mbrankImage
            sourceLabel.text = statuse?.source
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //初始化 UI 界面
        setUpSubView()
    }
    
    ///初始化 UI 界面
    private func setUpSubView() {
        
        //添加子控件
        addSubview(iconView)
        addSubview(verifiedView)
        addSubview(nameLabel)
        addSubview(vipView)
        addSubview(timeLabel)
        addSubview(sourceLabel)

        //布局子控件(均等平铺)
        iconView.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: self, size: CGSize(width: 50, height: 50), offset: CGPoint(x: margin, y: margin))
        verifiedView.xmg_AlignInner(type: XMG_AlignType.BottomRight, referView: iconView, size: CGSize(width: 14, height: 14), offset: CGPoint(x: margin, y: margin))
        nameLabel.xmg_AlignHorizontal(type: XMG_AlignType.TopRight, referView: iconView, size: nil, offset: CGPoint.init(x: margin, y: 0))
        vipView.xmg_AlignHorizontal(type: XMG_AlignType.TopRight, referView: nameLabel, size: nil, offset: CGPoint.init(x: margin, y: 0))
        timeLabel.xmg_AlignHorizontal(type: XMG_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPoint.init(x: margin, y: 0))
        sourceLabel.xmg_AlignHorizontal(type: XMG_AlignType.TopRight, referView: timeLabel, size: nil, offset: CGPoint.init(x: margin, y: 0))
    }
    
    //MARK:- 懒加载
    ///头像
    private lazy var iconView:UIImageView = UIImageView()
    ///认证图标
    private lazy var verifiedView:UIImageView = UIImageView()
    ///昵称
    private lazy var nameLabel:UILabel = UILabel.createLabel(color: UIColor.darkGray, fontSize: 14)
    ///会员图标
    private lazy var vipView:UIImageView = UIImageView(image: UIImage(named: "common_icon_membership"))
    ///时间
    private lazy var timeLabel:UILabel = UILabel.createLabel(color: UIColor.darkGray, fontSize: 12)
    ///来源
    private lazy var sourceLabel:UILabel = UILabel.createLabel(color: UIColor.darkGray, fontSize: 12)
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
