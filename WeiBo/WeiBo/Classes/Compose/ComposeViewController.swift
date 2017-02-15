//
//  ComposeViewController.swift
//  WeiBo
//
//  Created by wangjiayu on 2016/12/12.
//  Copyright © 2016年 fangjs. All rights reserved.
/** 发布微博界面 */

import UIKit
import SVProgressHUD

class ComposeViewController: UIViewController {
    var keyBoardHeight:CGFloat = 0
    var toolbarCons:NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChanged), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        //初始化导航栏
        setupNavgation()
        
        //初始化工具条
        setupToolbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if pictureView.bounds.height == 0 {
            //呼出键盘
            textView.becomeFirstResponder()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //隐藏键盘
        textView.resignFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    ///初始化导航栏
    private func setupNavgation() {
        
        //取消按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "取消", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancleAction))
        //发送按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "发送", style: UIBarButtonItemStyle.plain, target: self, action: #selector(sendMessage))
        //标题试图
        let titleView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 35))
        navigationItem.titleView = titleView
        //主标题
        let titleLabel = UILabel()
        titleLabel.text = "发送微博"
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.sizeToFit()
        titleLabel.textColor = UIColor.darkGray
        //名称
        let subTitleLabel = UILabel()
        subTitleLabel.text = UserAccount.readAccount()?.screen_name
        subTitleLabel.font = UIFont.systemFont(ofSize: 13)
        subTitleLabel.sizeToFit()
        subTitleLabel.textColor = UIColor.lightGray
        
        //添加子控件
        titleView.addSubview(titleLabel)
        titleView.addSubview(subTitleLabel)
        view.addSubview(textView)
        textView.addSubview(placehoderLabel)
        
        //布局子控件
        titleLabel.xmg_AlignInner(type: XMG_AlignType.TopCenter, referView: navigationItem.titleView!, size: nil)
        subTitleLabel.xmg_AlignInner(type: XMG_AlignType.BottomCenter, referView: navigationItem.titleView!, size: nil)
        textView.xmg_Fill(referView: view)
        placehoderLabel.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: textView, size: nil, offset: CGPoint.init(x: 5, y: 8))
    }
    
    ///初始化工具条
    private func setupToolbar() {
        //添加子控件
        view.addSubview(toolBar)
        
        //添加工具条中的按钮
        var items = [UIBarButtonItem]()
        let itemSettings = [["imageName": "compose_toolbar_picture", "action": "selectPicture"],
                            ["imageName": "compose_mentionbutton_background"],
                            ["imageName": "compose_trendbutton_background"],
                            ["imageName": "compose_emoticonbutton_background", "action": "inputEmoticon"],
                            ["imageName": "compose_addbutton_background"]]
        for dict in itemSettings {
            items.append(UIBarButtonItem.init(imageName: dict["imageName"]!, target: self, action: dict["action"]))
            items.append(UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil))
        }
        
        //删除最后一个弹簧
        items.removeLast()
        toolBar.items = items
        
        //布局子控件
       let cons = toolBar.xmg_AlignInner(type: XMG_AlignType.BottomLeft, referView: view, size: CGSize.init(width: width, height: 44))
        //获取工具条的底部约束
        toolbarCons = toolBar.xmg_Constraint(constraintsList: cons, attribute: NSLayoutAttribute.bottom)
    }
    ///通知响应
    func keyboardFrameChanged(notify:Notification) {
        //获取键盘的位置值
        let value = notify.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        //将NSValue转换为 CGRect
        let rect = value.cgRectValue
        keyBoardHeight = rect.height - 30
        // 计算键盘弹出和消失时的 y 方向上的偏移量
        let offsetY = UIScreen.main.bounds.height - rect.origin.y
        //注意:键盘弹出时的方向是向上的,所以值为负数
        toolbarCons!.constant = -offsetY
        //获取键盘弹出时的时间
        let duration = notify.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        //注意:工具条回弹是因为执行了两次动画, 而系统自带的键盘的动画节奏(曲线) UIKeyboardAnimationDurationUserInfoKey : 7
        // 7在apple API中并没有提供给我们, 但是我们可以使用
        // 7这种节奏有一个特点: 如果连续执行两次动画, 不管上一次有没有执行完毕, 都会立刻执行下一次
        // 也就是说上一次可能会被忽略
        // 如果将动画节奏设置为7, 那么动画的时长无论如何都会自动修改为0.5
        // UIView动画的本质是核心动画, 所以可以给核心动画设置动画节奏
        
        // 1.取出键盘的动画节奏
        let curve = notify.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        
        UIView.animate(withDuration: duration) {
            //设置动画节奏
            UIView.setAnimationCurve(UIViewAnimationCurve.init(rawValue: curve.intValue)!)
            //更新界面
           self.view.layoutIfNeeded()
        }
    }
    
    //MARK:- 事件响应
    ///选择照片
    func selectPicture() {
        //关闭键盘
        textView.resignFirstResponder()
        //添加子控件
        view.insertSubview(pictureView, belowSubview: toolBar)
        //布局子控件
        pictureView.xmg_AlignInner(type: XMG_AlignType.BottomCenter, referView: textView, size: CGSize.init(width: width, height: height * 0.6))
        
    }
    ///切换键盘
    func inputEmoticon() {
        //先关闭键盘
        textView.resignFirstResponder()
        //切换表情键盘
        textView.inputView = (textView.inputView == nil) ? emoticonView : nil
        //呼出键盘
        textView.becomeFirstResponder()
    }
    ///取消
    func cancleAction() {
        dismiss(animated: true, completion: nil)
    }
    ///发送微博
    func sendMessage() {
        if let image = pictureView.pictures.first {
            //路径
            let path = "2/statuses/upload.json"
            //参数
            let params = ["access_token": UserAccount.readAccount()?.access_token ,"status": textView.emoticonAttributedText()]
            NetWorkTools.shareNetWorkTools().post(path, parameters: params, constructingBodyWith: { (formData) in
                let data = UIImagePNGRepresentation(image)
                /*
                 第一个参数: 需要上传的二进制数据
                 第二个参数: 服务端对应哪个的字段名称
                 第三个参数: 文件的名称(在大部分服务器上可以随便写)
                 第四个参数: 数据类型, 通用类型application/octet-stream
                 */
                formData.appendPart(withFileData: data!, name: "pic", fileName: "wang.png", mimeType: "application/octet-stream")
            }, progress: { (progress) in
                
            }, success: { (_, JSON) in
                //提示用户
                SVProgressHUD.showSuccess(withStatus: "发布成功")
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                //关闭控制器
                self.close()

            }, failure: { (_, error) in
                SVProgressHUD.showError(withStatus: error as! String)
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            })
        } else {
            //路径
            let path = "2/statuses/update.json"
            //参数
            let params = ["access_token": UserAccount.readAccount()?.access_token ,"status": textView.emoticonAttributedText()]
            
            //发送 post 请求
            NetWorkTools.shareNetWorkTools().post(path, parameters: params, progress: nil, success: {  (_, JSON) in
                //提示用户
                SVProgressHUD.showSuccess(withStatus: "发布成功")
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                //关闭控制器
                self.close()
                
            }) { (_, error) in
                SVProgressHUD.showError(withStatus: error as! String)
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            }

        }
    }
    
    /// 关闭控制器
    private func close() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- 懒加载
    private lazy var textView: UITextView = {
       let tView = UITextView()
       tView.alwaysBounceVertical = true
       tView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
       tView.font = UIFont.systemFont(ofSize: 17)
       tView.delegate = self
       return tView
    }()
    ///工具条
    private lazy var toolBar:UIToolbar = UIToolbar()
    ///提示符
    fileprivate lazy var placehoderLabel:UILabel = {
        let label = UILabel()
        label.text = "发布新鲜事..."
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.lightGray
        label.sizeToFit()
        return label
    }()
    ///表情视图
    private lazy var emoticonView:EmoticonView = {
       let eView = EmoticonView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: self.keyBoardHeight), callBack: {[unowned self] (emoticon) in
            //插入表情符
            self.textView.insertEmoticonAttributedText(emoticon: emoticon)
       })
        return eView
    }()
    ///图片选择器
    private lazy var  pictureView:PictureSelectorView =  PictureSelectorView()
}

//MARK:- UITextViewDelegate
extension ComposeViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placehoderLabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
}
