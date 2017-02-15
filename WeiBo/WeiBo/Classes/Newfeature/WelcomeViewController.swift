//
//  WelcomeViewController.swift
//  WeiBo
//
//  Created by fangjs on 2016/11/22.
//  Copyright © 2016年 fangjs. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //设置界面
        setUpUI()
        
        //加载头像
        loadIcon()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
        //设置偏移量
        let offsetY:CGFloat = UIScreen.main.bounds.height
        iconView.transform = CGAffineTransform.init(translationX: 0, y: offsetY)
        //执行动画
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: UIViewAnimationOptions.init(rawValue: 0), animations: { [weak self] in
            self!.iconView.transform = CGAffineTransform.identity
            }) {[weak self] (_) in
                UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.init(rawValue: 0), animations: {
                    self!.messageLabel.alpha = 1.0
                    }, completion: { (_) in
                      NotificationCenter.default.post(name: NSNotification.Name(rawValue: changeViewControllerNotification), object: true)
                })
        }
    }
    
    ///加载头像
    private func loadIcon() {
        if let iconUrl = UserAccount.readAccount()?.avatar_large {
            let url = URL.init(string: iconUrl)
            
            let image = UIImage.init(named: "avatar_default_big")?.circleImage()
            iconView.sd_setImage(with: url, placeholderImage: image)
           
        }
    }
    
    ///布局界面
    private func setUpUI() {
        //添加子控件
        view.addSubview(bgIcon)
        view.addSubview(iconView)
        view.addSubview(messageLabel)
        
        //布局子控件
        bgIcon.xmg_Fill(referView: view)
        iconView.xmg_AlignInner(type: XMG_AlignType.TopCenter, referView: view, size: CGSize.init(width: 100, height: 100), offset: CGPoint(x: 0, y: 150))
        messageLabel.xmg_AlignVertical(type: XMG_AlignType.BottomCenter, referView: iconView, size: nil, offset: CGPoint.init(x: 0, y: 20))
    }
   
    ///背景视图
    private lazy var bgIcon:UIImageView = UIImageView.init(image: UIImage.init(named: "ad_background"))
    ///头像视图
    private lazy var iconView:UIImageView = {
       let icon = UIImageView()
        
        icon.image = UIImage.init(named: "avatar_default_big")?.circleImage()
        icon.layer.masksToBounds = true
        icon.layer.cornerRadius = 50.0
        return icon
    }()
    ///文本
    private lazy var messageLabel:UILabel = {
        let message = UILabel.createLabel(color: UIColor.black, fontSize: 17)
        message.text = "欢迎回来"
        message.alpha = 0.0
        return message
    }()

}
