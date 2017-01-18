//
//  OAuthViewController.swift
//  WeiBo
//
//  Created by fangjs on 2016/11/16.
//  Copyright © 2016年 fangjs. All rights reserved.
/** OAuth 授权界面 */

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {
    
    let WB_App_Key = "3763300011"
    let WB_App_Secret = "b55fcac191a8c4d40d470597af380d7a"
    let WB_redirect_uri = "http://www.520it.com"
    
    ///懒加载
    private lazy var webView:UIWebView = {
        let wView = UIWebView()
        wView.delegate = self
        return wView
    }()

    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //初始化导航条上的按钮
        setupNavgationItem()
        
        //初始化 webView
        setupWebView()
    }

    ///初始化 webView
    private func setupWebView() {
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_redirect_uri)"
        let url:URL = URL(string: urlStr)!
        let request:URLRequest = URLRequest(url: url)
        webView.loadRequest(request)
    }
    
    ///初始化导航条
    private func setupNavgationItem() {
        navigationItem.title = "授权界面"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.plain, target: self, action: #selector(closeBtn))
    }
    
    ///关闭按钮响应事件
    func closeBtn() {
        dismiss(animated: true, completion: nil)
    }
}

//MARK:- UIWebViewDelegate代理函数的实现
extension OAuthViewController:UIWebViewDelegate {
    ///返回 true 正常加载,返回 false 不加载
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let urlStr = request.url?.absoluteString
        let codeStr = "code="
        //判断是否是授权回调界面,如果不是就继续加载
        if !(urlStr?.hasPrefix(WB_redirect_uri))! {
            //继续加载
            return true
        }
        //判断是否授权成功
        if (request.url?.query?.hasPrefix(codeStr))! {
            //取出已经授权的 RequestToken
            let code = request.url?.query?.substring(from: codeStr.endIndex)
            //利用已经授权的 RequestToken换区 AccessToken
            loadAccessToken(code: code!)
            
        } else {
            //授权失败
            //关闭授权界面
            closeBtn()
        }

        return false
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.showInfo(withStatus: "加载中...")
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    ///换取 AccessToken
    private func loadAccessToken(code:String) {
        // 定义路径
        let path = "oauth2/access_token"
        //封装参数
        let parameters = ["client_id":WB_App_Key, "client_secret":WB_App_Secret, "grant_type":"authorization_code", "code":code, "redirect_uri":WB_redirect_uri]
        //发送 post 请求
        NetWorkTools.shareNetWorkTools().post(path, parameters: parameters, progress: nil, success: {  (_, JSON) in
            //获取AccessToken
            let user = UserAccount(dict: JSON as! [String : AnyObject])
            //获取用户信息
            user.loadUserInfo(finished: { (account, error) in
                //如果获取用户信息成功就存储
                if account != nil {
                    account!.saveAccount()
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: changeViewControllerNotification), object: false)
                }
            })
            
            }) { (_, error) in
                SVProgressHUD.showError(withStatus: error as! String)
        }
    }
}
