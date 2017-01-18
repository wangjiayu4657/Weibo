//
//  visitorView.swift
//  WeiBo
//
//  Created by fangjs on 2016/11/4.
//  Copyright © 2016年 fangjs. All rights reserved.
//

import UIKit

typealias backBlock = ()->Void

/** 在定义可选协议时,要在可选内容的声明前加 @objc optional 关键字,并且在声明协议时在 protocol 关键字的前面加上@objc*/
@objc protocol VisitorViewDelegate {
    //可选方法
//   @objc optional func registerButtonClick()
    //必须要实现
   func loginButtonClick()
}

//扩展协议
//extension VisitorViewDelegate {
//    func test (){
//        print("hahha")
//    }
//}

class VisitorView: UIView {

    weak var delegate:VisitorViewDelegate?
    
    var myBlock:backBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //添加子控件
        addSubview()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //布局子控件
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //背景视图
        bgIconView.xmg_AlignInner(type: XMG_AlignType.Center, referView: self, size: nil)
        //遮盖
        coverIconView.xmg_Fill(referView: self)
        //小房子
        homeIconView.xmg_AlignInner(type: XMG_AlignType.Center, referView: self, size: nil)
        //内容
        contentLabel.xmg_AlignVertical(type: XMG_AlignType.BottomCenter, referView: bgIconView, size: nil,offset: CGPoint(x: 0, y: 10))
        //"哪个控件"的什么"属性" "等于" "另一个控件" 的什么"属性" "乘以多少" 再加上"多少"
        
        addConstraint(NSLayoutConstraint.init(item: contentLabel, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 0, constant: 224))
        //设置尺寸
        let size = CGSize.init(width: 100.0, height: 44.0)
        //注册按钮
        registerButton.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: contentLabel, size: size, offset: CGPoint(x: 0, y: 20))
        //登录按钮
        loginButton.xmg_AlignVertical(type: XMG_AlignType.BottomRight, referView: contentLabel, size: size, offset: CGPoint(x: 0, y: 20))
    }
    
    //添加子空间
    private func addSubview() {
        addSubview(bgIconView)
        addSubview(homeIconView)
        addSubview(coverIconView)
        addSubview(contentLabel)
        addSubview(registerButton)
        addSubview(loginButton)
    }
    
     /// 设置游客视图
     ///
     /// - parameter isHome:    是否是首页
     /// - parameter imageName: 图片名称
     /// - parameter message:   信息内容
    
     func setupVisitorViewInfo(isHome:Bool,imageName:String,message:String){
        bgIconView.isHidden = !isHome
        homeIconView.image = UIImage.init(named: imageName)
        contentLabel.text = message
        if isHome {
            startAnimation()
        }
    }
    
    //MARK: -设置动画
    private func startAnimation(){
        //1.创建动画
        let animation = CABasicAnimation.init(keyPath: "transform.rotation")
        //2.设置动画的属性
        animation.toValue = 2 * M_PI
        animation.duration = 20
        animation.repeatCount = MAXFLOAT
        // true 动画执行完后默认会从图层删除掉
        // false 下次你在通过-set 方法设定动画的属性时,它将再次使用你的动画,而非默认的动画
        animation.isRemovedOnCompletion = false
        //将动画添加到图层上
        bgIconView.layer.add(animation, forKey: nil)
        
    }
    
    //MARK: -懒加载子控件
    ///背景图片
    private lazy var bgIconView:UIImageView =  {
        let bgIcon = UIImageView.init(image: UIImage.init(named: "visitordiscover_feed_image_smallicon"))
        return bgIcon
    }()
    
    ///小房子
    private lazy var homeIconView:UIImageView = {
        let homeIcon = UIImageView.init(image: UIImage.init(named: "visitordiscover_feed_image_house"))
        
        return homeIcon
    }()
    
    ///遮盖图片
    private lazy var coverIconView:UIImageView = {
       let coverIcon = UIImageView.init(image: UIImage.init(named: "visitordiscover_feed_mask_smallicon"))
        return coverIcon
    }()
    
    ///内容日志 label
    private lazy var contentLabel:UILabel = {
        let conLabel = UILabel()
        conLabel.text = "卡机打发垃圾地方可骄傲的上大路发空间按开始对房价就短发接爱看"
        conLabel.font = UIFont.systemFont(ofSize: 15)
        conLabel.textColor = UIColor.darkGray
        conLabel.numberOfLines = 0
        return conLabel
    }()
    
    ///注册按钮
    private lazy var registerButton:UIButton = {
        let registerBtn = UIButton()
        registerBtn.setTitleColor(UIColor.orange, for: UIControlState.normal)
        registerBtn.setTitle("注册", for: UIControlState.normal)
        registerBtn.setBackgroundImage(UIImage.init(named: "visitordiscover_feed_mask_smallicon-1"), for: UIControlState.normal)
        registerBtn.addTarget(self, action: #selector(registerBtnClick), for: UIControlEvents.touchUpInside)
        return registerBtn
    }()
    
    ///登录按钮
    private lazy var loginButton:UIButton = {
       let loginBtn = UIButton()
        loginBtn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        loginBtn.setTitle("登录", for: UIControlState.normal)
        loginBtn.setBackgroundImage(UIImage.init(named: "visitordiscover_feed_mask_smallicon-1"), for: UIControlState.normal)
        loginBtn.addTarget(self, action: #selector(loginBtnClick), for: UIControlEvents.touchUpInside)
        return loginBtn
    }()
    
    //MARK: - 按钮的响应事件
    //通过代理方法回调
//    func registerBtnClick(){
//        delegate?.registerButtonClick()
//    }

    //通过闭包回调
    func registerBtnClick(){
        if let block = myBlock{
            block()
        }
    }

    func loginBtnClick(){
        delegate?.loginButtonClick()
    }

}
