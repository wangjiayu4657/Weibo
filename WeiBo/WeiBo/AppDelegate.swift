    //
//  AppDelegate.swift
//  WeiBo
//
//  Created by fangjs on 2016/11/2.
//  Copyright © 2016年 fangjs. All rights reserved.
//

import UIKit

/// 更改跟控制器的通知名称
let changeViewControllerNotification = "changeViewControllerNotification"

    
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().tintColor = UIColor.orange
        UITabBar.appearance().tintColor = UIColor.orange
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        
        window?.backgroundColor = UIColor.white
        
        window?.rootViewController = defaultViewController()
        
        window?.makeKeyAndVisible()
        
        //注册通知监听,是否需要更改根控制器
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNotification), name: NSNotification.Name(rawValue: changeViewControllerNotification), object: nil)
        
        return true
    }
    
    ///判断需要加载哪个控制器作为启动时的跟控制器
    private func defaultViewController() -> UIViewController{
        if UserAccount.userLogin() {
          return checkoutCurrentVersion() ? NewfeatureCollectionViewController() : WelcomeViewController()
        }
        return MainViewController()
    }
    
    ///监听通知
    func receiveNotification(notify:Notification) {
    
        if notify.object as! Bool {
          window?.rootViewController = MainViewController()
        } else {
          window?.rootViewController = WelcomeViewController()
        }
    }
    
    //移除通知
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //检查是否有新的版本号
    private func checkoutCurrentVersion() -> Bool {
        //获取版本号
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        //获取以前版本
        let oldVersion = UserDefaults.standard.object(forKey: "CFBundleShortVersionString") as? String ?? "1.0"
        
        //比较版本号(如果当前版本号大于以前版本号则说明有新版本)
        if currentVersion?.compare(oldVersion) == ComparisonResult.orderedDescending {
            //如果有新的版本号则存储
            UserDefaults.standard.set(currentVersion, forKey: "CFBundleShortVersionString")
            return true
        }
        
        //没有新版本
        return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

