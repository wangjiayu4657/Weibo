//
//  HomeRefreshControl.swift
//  WeiBo
//
//  Created by fangjs on 2016/11/30.
//  Copyright © 2016年 fangjs. All rights reserved.
//

import UIKit

class HomeRefreshControl: UIRefreshControl {
    
    override init() {
        super.init()
        
        setUpUI()
    }
    
    ///初始化界面
    private func setUpUI() {
        //添加子控件
        addSubview(refreshView)
        //布局子控件
        refreshView.xmg_AlignInner(type: XMG_AlignType.Center, referView: self, size: CGSize.init(width: 160, height: 60))
        
        //监听偏移量
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    //MARK:- 懒加载
    private lazy var refreshView:HomeRefreshView = HomeRefreshView.refreshView()

    ///下拉刷新箭头上下翻转的标识
    private var rotationArrowFlag = true
    ///正在加载数据的标识
    private var loadingIconFlag =  true
    ///监听 tableView 的偏移量
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        let offsetY = frame.origin.y
        //判断是否触发刷新数据
        if isRefreshing && loadingIconFlag {
            loadingIconFlag = false
            refreshView.startLoadingAnimation()
            return
        }
        //过滤不需要的数据(如 0)
        if offsetY >= 0 { return }
        //如果偏移量小于或等于-50则下拉控件的刷新箭头翻转一次
        if offsetY <= -60 && rotationArrowFlag {
            rotationArrowFlag = false
            refreshView.rotationArrowAnimation(flag: rotationArrowFlag)
        } else if offsetY > -60 && !rotationArrowFlag { //如果偏移量大于-50则下拉控件的刷新箭头在反翻转一次
            rotationArrowFlag = true
            refreshView.rotationArrowAnimation(flag: rotationArrowFlag)
        }
    }
    
    override func endRefreshing() {
        super.endRefreshing()
    
        //清除动画
        refreshView.stopLoadingAnimation()
        //标识位置位
        loadingIconFlag = true
    }
    
    ///移除监听者
    deinit {
        removeObserver(self, forKeyPath: "frame")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

///下拉刷新控件
class HomeRefreshView:UIView  {
    ///下拉刷新视图
    @IBOutlet weak var tipView: UIView!
    ///下拉刷新的箭头图标
    @IBOutlet weak var arrowIcon: UIImageView!
    ///正在刷新的旋转图标
    @IBOutlet weak var loadingIcon: UIImageView!
    
    ///加载 xib 文件
    fileprivate class func refreshView () -> HomeRefreshView {
        return Bundle.main.loadNibNamed("HomeRefreshView", owner: nil, options: nil)!.last as! HomeRefreshView
    }
    
    ///旋转箭头
    fileprivate func rotationArrowAnimation(flag:Bool) {
        var angle = M_PI
        angle += flag ? 0.01 : -0.01
        UIView.animate(withDuration: 0.25) {
            self.arrowIcon.transform = self.arrowIcon.transform.rotated(by: CGFloat(angle))
        }
    }
    
    ///开始加载数据动画
    fileprivate func startLoadingAnimation() {
        //隐藏下拉刷新的视图,显示正在加载数据的视图
        tipView.isHidden = true
        //1.创建动画
        let animation = CABasicAnimation.init(keyPath: "transform.rotation")
        //2.设置动画的属性
        animation.toValue = 2 * M_PI
        animation.duration = 1
        animation.repeatCount = MAXFLOAT
        // true 动画执行完后默认会从图层删除掉
        // false 下次你在通过-set 方法设定动画的属性时,它将再次使用你的动画,而非默认的动画
        animation.isRemovedOnCompletion = false
        //将动画添加到图层上
        loadingIcon.layer.add(animation, forKey: nil)
    }
    ///结束加载数据动画
    fileprivate func stopLoadingAnimation() {
        tipView.isHidden = false
        loadingIcon.layer.removeAllAnimations()
    }
}
