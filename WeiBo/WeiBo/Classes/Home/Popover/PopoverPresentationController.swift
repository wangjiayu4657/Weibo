//
//  PopoverPresentationController.swift
//  WeiBo
//
//  Created by fangjs on 2016/11/8.
//  Copyright © 2016年 fangjs. All rights reserved.
//

import UIKit

class PopoverPresentationController: UIPresentationController {
    
    var presentedFrame = CGRect.zero
    
    /// 实例化负责转场的控制器
    ///
    /// - parameter presentedViewController:  被展示的控制器
    /// - parameter presentingViewController: 发起转场的控制器, xcode6是nil,xcode7是野指针
    ///
    /// - returns: 负责专场的控制器
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
            super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    /*
     即将布局容器视图上的子视图时调用
     containerView : 容器视图,放置展现出来的视图
     presentedView : 被展示的视图
     */
    override func containerViewWillLayoutSubviews() {
        //设置展现出来的视图的大小
        if presentedFrame == CGRect.zero {
            presentedView?.frame = CGRect(x: 80, y: 50, width: 250, height: 350)
        } else {
            presentedView?.frame = presentedFrame
        }
        //添加遮盖
        containerView?.insertSubview(coverView, at: 0)
    }
    
    //MARK:- 懒加载
    private lazy var coverView:UIView = {
        //创建蒙版
       let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        view.frame = UIScreen.main.bounds
        //监听点击事件
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeCoverView))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    //关闭弹窗
    func closeCoverView(){
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
}
