//
//  PopoverAnimator.swift
//  WeiBo
//
//  Created by fangjs on 2016/11/9.
//  Copyright © 2016年 fangjs. All rights reserved.
//

import UIKit



let PopoverAnimatorWillShowNotification = "PopoverAnimatorWillShowNotification"
let PopoverAnimatorWillDismissNotification = "PopoverAnimatorWillDismissNotification"

//负责专场动画的对象: PopoverAnimator
class PopoverAnimator: NSObject, UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning {
    
    //标题栏菜单是否已展开
    var isPresented:Bool = false
    //定义属性保存菜单的大小
    var presentedFrame = CGRect.zero
    
    //返回负责转场的控制器对象,UIPresentationController iOS8推出的专门用于负责转场动画的
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let PC =  PopoverPresentationController.init(presentedViewController: presented, presenting: presenting)
        PC.presentedFrame = presentedFrame
        return PC
    }
    //返回负责 Modal 动画的对象
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //要展开
        isPresented = true
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "PopoverAnimatorWillShowNotification"), object: self)
        return self
    }
    //返回负责 dismiss 动画的对象
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //要关闭
        isPresented = false
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "PopoverAnimatorWillDismissNotification"), object: self)
        return self
    }
    
    //返回动画时长
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    //转场动画实现函数,一旦实现这个方法,系统默认的转场动画就会失效,一切都由程序员自己实现
    //transitionContext:转场上下文,提供了转场需要的参数
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //如果需要展开
        if isPresented {
            //获取要展开的视图
            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
            //将要展示的视图添加到容器视图中
            transitionContext.containerView.addSubview(toView!)
            //设置要展示的视图的缩放尺寸, x 方向不变, y 方向缩放为0.0相当于被压扁了即高度为零
            toView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
            //设置锚点,默认锚点的位置为(0.5,0.5),让锚点向上偏移到0的位置(0.5,0.0),这样菜单会从上而下的展开,如果不设置的话,菜单是从中间位置向两边展开
            toView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            UIView.animate(withDuration: 0.5, animations: {
                //清空 ransform ,使其恢复原样
                toView?.transform = CGAffineTransform.identity
            }) { (_) in
                //一定要告诉控制器专场动画已结束
                transitionContext.completeTransition(true)
            }
        } else {
            //获取要fromView
            let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
            UIView.animate(withDuration: 0.2, animations: {
                fromView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.00001)
                }, completion: { (_) in
                    //一定要告诉控制器专场动画已结束
                    transitionContext.completeTransition(true)
            })
        }
    }
    
}


