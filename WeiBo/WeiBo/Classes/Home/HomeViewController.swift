//
//  HomeController.swift
//  WeiBo
//
//  Created by fangjs on 2016/11/2.
//  Copyright © 2016年 fangjs. All rights reserved.
//

import UIKit

///cell 的标识符
let homeCellIdentifier = "homeCellIdentifier"

class HomeViewController: BaseViewController,UITableViewDataSourcePrefetching {
    
    ///缓存微博的行高
    var cellHeight:[Int:CGFloat] = [Int:CGFloat]()
    ///数据模型
    var models:[StatusesModel]?{
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !login {
            visitorView?.setupVisitorViewInfo(isHome: true, imageName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看有什么惊喜")
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.plain, target: self, action: #selector(registerBtnClick))
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.plain, target: self, action: #selector(loginBtnClick))
            return
        }
        //注册 cell
        setUpTableView()
        
        //设置导航栏按钮
        setupNavBarButton()
        
        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(changeTitleBtnState), name: NSNotification.Name(rawValue: PopoverAnimatorWillShowNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeTitleBtnState), name: NSNotification.Name(rawValue: PopoverAnimatorWillDismissNotification), object: nil)
        
        //加载数据
        loadData()
        
        promptLabel.isHidden = true
    }
    
    ///当有内容警告时清楚全部缓存
    override func didReceiveMemoryWarning() {
        cellHeight.removeAll()
    }
    
    ///注册 cell
    private func setUpTableView() {
        tableView.register(HomeNormalCell.self, forCellReuseIdentifier: HomeTableViewCellType.normalCell.rawValue)
        tableView.register(HomeForwardCell.self, forCellReuseIdentifier: HomeTableViewCellType.forwardCell.rawValue)
        //预估高度
        //tableView.estimatedRowHeight = 200
        //自动计算高度
        //tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.prefetchDataSource = self
        //设置下拉刷新
        refreshControl = HomeRefreshControl()
        refreshControl?.addTarget(self, action: #selector(loadData), for: UIControlEvents.valueChanged)
    }
    
    ///上拉或下拉的标志位
    var pullRefreshFlag = false
    ///下拉刷新的 id
    private var since_id = 0
    ///上拉刷新的 id
    private var max_id = 0
    
    ///加载数据
    func loadData() {
        
        // 1.默认最新返回20条数据
        // 2.since_id : 会返回比since_id大的微博
        // 3.max_id: 会返回小于等于max_id的微博
        //每条微博都有一个微博ID, 而且微博ID越后面发送的微博, 它的微博ID越大递增
        
        //判断是否为上拉刷新
        if pullRefreshFlag {
            //将 since_id 置为 0,即在刷新数据时会根据所传递的参数判断是要请求上拉刷新的数据还是下拉刷新的数据
            since_id = 0
            //获取第一条微博的 max_id 如果为 models 为空则返回0
            max_id = models?.last?.id ?? 0
        } else {
            //获取第一条微博的 since_id 如果为 models 为空则返回0
            since_id = models?.first?.id ?? 0
        }
        //获取当前登录用户及其所关注（授权）用户的最新微博
        StatusesModel.loadInfo (sinceId: since_id , maxId: max_id) { (statuse, error) in
           
            if error == nil {
                //结束刷新
                self.refreshControl?.endRefreshing()
                //给数据源赋值
                if self.since_id > 0 {
                    // 如果是下拉刷新, 就将获取到的数据, 拼接在原有数据的前面
                    self.models = statuse! + self.models!
                    //显示刷新状态
                    self.showRefreshPromptContent(count: self.models?.count ?? 0)
                } else if self.max_id > 0 {
                    // 如果是上拉刷新, 就将获取到的数据, 拼接在原有数据的后面
                    self.models = self.models! + statuse!
                } else {
                    self.models = statuse
                }
            }
        }
    }
    
    ///显示刷新状态
    private func showRefreshPromptContent(count:Int) {
        self.promptLabel.isHidden = false
        self.promptLabel.text = count == 0 ? "没有刷新到新微薄" : "刷新了\(count)条微博"
        UIView.animate(withDuration: 1.5, animations: {
            self.promptLabel.transform = CGAffineTransform.init(translationX: 0, y: 21)
            }) { (_) in
                UIView.animate(withDuration:2.5, animations: {
                    self.promptLabel.transform = CGAffineTransform.identity
                    }, completion: { (_) in
                        self.promptLabel.isHidden = true
                })
        }
    }
    
    ///更改标题栏上的按钮的状态
    func changeTitleBtnState() {
        let titleBtn = navigationItem.titleView as! TitleButton
        titleBtn.isSelected = !titleBtn.isSelected
    }
    
    ///设置导航栏按钮
    private func setupNavBarButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.createNavBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: #selector(leftBtnClick))
        //快捷键 command + control + e 多行操作
        navigationItem.rightBarButtonItem = UIBarButtonItem.createNavBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(rightBtnClick))
        
        //设置导航栏上的标题按钮
        let titleBtn = TitleButton()
        titleBtn.setTitle("极客江南 ", for: UIControlState.normal)
        
        titleBtn.addTarget(self, action: #selector(titleBtnClick), for: UIControlEvents.touchUpInside)
        navigationItem.titleView = titleBtn
    }
    
    ///当控制器销毁时,移除通知
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    //MARK:- 懒加载 负责转场动画的对象
    ///一定要定义一个属性来保存自定义转场动画的对象,否则会报错
    private lazy var popoverAnimator:PopoverAnimator = {
      let popoverView = PopoverAnimator()
          //设置下拉菜单的尺寸
          popoverView.presentedFrame = CGRect(x: 100, y: 50, width: 200, height: 300)
      return popoverView
    }()
    ///当刷新微博时用来提示用户刷新的状态
    private lazy var promptLabel:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.orange
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.white
        label.frame = CGRect.init(x: 0, y: 23, width: Int(width), height: 21)
        label.isHidden = true
        self.navigationController?.navigationBar.insertSubview(label, at: 0)
        return label
    }()
    
    //MARK:- 按钮点击响应事件
    ///标题菜单按钮
    func titleBtnClick(btn:TitleButton) {
        //从 storyboard 中加载控制器
        let sb = UIStoryboard.init(name: "PopoverViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        //设置转场代理,告诉系统谁来负责转场
        //popoverAnimator:来负责转场动画的实现
        vc?.transitioningDelegate = popoverAnimator
        //设置转场模式
        vc?.modalPresentationStyle = UIModalPresentationStyle.custom
        present(vc!, animated: true, completion: nil)
    }

    ///注册按钮
    func registerBtnClick(){
        print(#function)
    }
    ///登录按钮
    func loginBtnClick(){
        print(#function)
    }
    ///导航栏上的左侧按钮
    func leftBtnClick () {
        print(#function)
    }
    ///导航栏上的右侧按钮
    func rightBtnClick () {
        let sb = UIStoryboard(name: "QRCodeViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        present(vc!, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let statues = models![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCellType.cellIdentifier(statuse: statues)) as! HomeTableViewCell
        let count = models?.count ?? 0
        if indexPath.row == (count - 1) {
            pullRefreshFlag = true
            loadData()
        }
        cell.statuse = statues
        return cell
    }
    
    //MARK:- Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //取出模型
        let statuse = models![indexPath.row]
        //如果该条微博的行高以缓存,则直接取出使用,否则重新计算
        if let height = cellHeight[statuse.id] {
            return height
        }
        //取出 cell
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCellType.cellIdentifier(statuse: statuse)) as! HomeTableViewCell
        let rowHeight = cell.caculateCellHeight(statuse: statuse)
        //缓存 cell 的行高
        cellHeight[statuse.id] = rowHeight
        //返回 cell 的高度
        return rowHeight
    }
    
    //MARK:- Table view daata source prefetching
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        //print(indexPaths)
    }

 }




