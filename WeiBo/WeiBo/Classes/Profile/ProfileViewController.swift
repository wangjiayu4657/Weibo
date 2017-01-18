//
//  ProfileViewController.swift
//  WeiBo
//
//  Created by fangjs on 2016/11/2.
//  Copyright © 2016年 fangjs. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
 
        visitorView?.setupVisitorViewInfo(isHome: false, imageName: "visitordiscover_image_profile", message: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人")
        
    }
   
}
