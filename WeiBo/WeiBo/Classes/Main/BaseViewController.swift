//
//  BaseViewController.swift
//  WeiBo
//
//  Created by fangjs on 2016/11/4.
//  Copyright © 2016年 fangjs. All rights reserved.
//

import UIKit
import AFNetworking

class BaseViewController: UITableViewController,VisitorViewDelegate {
    
    let login:Bool = UserAccount.userLogin()
    var visitorView:VisitorView?
    
    override func loadView() {
        login ? super.loadView() : setupVisitor()
    }
    
    private func setupVisitor() {
        visitorView = VisitorView()
        visitorView?.delegate = self
        visitorView?.myBlock = backBlock
        view = visitorView
    }

    //MARK:- VisitorViewDelegate
    func registerButtonClick() {
//       print(UserAccount.readAccount())
    }

    func loginButtonClick() {
//        print(#function)
        let oauthView = OAuthViewController()
        let nav = UINavigationController(rootViewController: oauthView)
        present(nav, animated: true, completion: nil)
    }
    
    ///回调函数
    func backBlock() {

    }
    
}
