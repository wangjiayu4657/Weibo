//
//  MainViewController.swift
//  WeiBo
//
//  Created by fangjs on 2016/11/2.
//  Copyright © 2016年 fangjs. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupTabBarButton()
    }
    
    private func setupTabBarButton(){
        tabBar.addSubview(tabBarButton)
        
        let width = UIScreen.main.bounds.size.width / CGFloat(viewControllers!.count)
        let rect = CGRect(x: 0, y: 0, width: width, height: 49)
        //设置tabBarButton的位置
        
        //方法1.设置偏移量
        //tabBarButton.frame = rect.offsetBy(dx: width * 2, dy: 0)
        
        //方法2. 设置 center
        tabBarButton.frame = rect
        tabBarButton.center.x = tabBar.center.x
    }
    
    //添加所有自控制器
    private func addChildViewControllers() {
        //1.获取文件路径
        let path = Bundle.main.path(forResource: "MainVCSettings.json", ofType: nil)
        //2.转化为 data
        let jsondata = NSData.init(contentsOfFile: path!)
        
        if let jsonData = jsondata {
            do{
                 //3.序列化
                let dataArray = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
                //遍历数组
                for dict in dataArray as! [[String:String]]{
                    addChildViewController(dict["vcName"]!, title: dict["title"]!, image: dict["imageName"]!)
                }
            }catch{
                addChildViewController("HomeViewController", title: "首页", image: "tabbar_home")
                addChildViewController("MessageViewController", title: "消息", image: "tabbar_message_center")
                addChildViewController("NullViewController", title: "", image: "")
                addChildViewController("DiscoverViewController", title: "发现", image: "tabbar_discover")
                addChildViewController("ProfileViewController", title: "我", image: "tabbar_profile")
            }
        }
    }

    //动态添加子控制器
    private func addChildViewController(_ childControllerName: String,title:String,image:String) {
        
        //动态或去命名空间
        let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        //将字符串转换成任意类
        let cls:AnyClass = NSClassFromString(nameSpace + "." + childControllerName)!
        //将任意类装换成控制器类型
        let vcCls = cls as! UIViewController.Type
        //初始化控制球
        let vc = vcCls.init()
        
        vc.title = title;
        vc.tabBarItem.image = UIImage.init(named: image)
        vc.tabBarItem.selectedImage = UIImage.init(named: image + "_highlighted")
        
        let nav = UINavigationController()
        nav.addChildViewController(vc)
        
        addChildViewController(nav)
        
    }
    
    //MARK:-懒加载 button
    fileprivate lazy var tabBarButton:UIButton = {
        let btn = UIButton()
        
        //设置前景图片
        btn.setImage(UIImage.init(named: "tabbar_compose_icon_add"), for: UIControlState.normal)
        btn.setImage(UIImage.init(named: "tabbar_compose_icon_add_highlighted"), for: UIControlState.highlighted)
        
        //设置背景图片
        btn.setBackgroundImage(UIImage.init(named: "tabbar_compose_button"), for: UIControlState.normal)
        btn.setBackgroundImage(UIImage.init(named: "tabbar_compose_button_highlighted"), for: UIControlState.highlighted)
        
        btn.addTarget(self, action: #selector(tarBarButtonClick), for: UIControlEvents.touchUpInside)
        
        return btn
    }()
    
    // 监听加号按钮点击
    /**注意:  运行循环监听到事件后，向 VC 发送消息，动态执行方法，因此不能设置为 private*/
    func tarBarButtonClick() {
        print(#function)
        let composeVC = ComposeViewController()
        let nav = UINavigationController.init(rootViewController: composeVC)
        present(nav, animated: true, completion: nil)
    }
}
