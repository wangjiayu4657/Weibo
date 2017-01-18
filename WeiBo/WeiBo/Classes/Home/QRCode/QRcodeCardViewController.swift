//
//  QRcodeCardViewController.swift
//  WeiBo
//
//  Created by fangjs on 2016/11/14.
//  Copyright © 2016年 fangjs. All rights reserved.
//

import UIKit

class QRcodeCardViewController: UIViewController {
    //MARK:- 懒加载
    private lazy var imageView:UIImageView = UIImageView()
    private lazy var contentLabel:UITextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //0.设置背景颜色
        view.backgroundColor = UIColor.white
        //1.设置标题h
        navigationItem.title = "我的名片"
        //1.1设置导航栏的背景色
        navigationController?.navigationBar.barTintColor = UIColor.white
        //2.添加名片容器
        view.addSubview(imageView)
        //3.布局名片容器
        imageView.xmg_AlignVertical(type: XMG_AlignType.Center, referView: view, size: CGSize(width: 300, height: 300))
        //4.设置二维码
        
        contentLabel.xmg_AlignVertical(type: XMG_AlignType.TopCenter, referView: imageView, size: CGSize(width: 300, height: 30))
        contentLabel.text = "王家玉"

        setupGeneraterQRCode()
    }
    
    
    private func setupGeneraterQRCode() {
        
        view.endEditing(true)
        guard let content = contentLabel.text else { return }
        
        if content.characters.count > 0 {
            DispatchQueue.global().async {
                let image = content.generateQRCodeWithLogo(logo: UIImage.init(named: "nange.jpg"))
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
        
       
    }
    
    
    
    
}
