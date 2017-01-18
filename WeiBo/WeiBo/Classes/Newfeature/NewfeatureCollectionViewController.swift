//
//  NewfeatureCollectionViewController.swift
//  WeiBo
//
//  Created by fangjs on 2016/11/22.
//  Copyright © 2016年 fangjs. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class NewfeatureCollectionViewController: UICollectionViewController {
    ///引导页的个数
    private let pageCount:Int = 4
    ///用来保存最后一页引导页,当最后一页消失时把最后一页上的按钮进行隐藏
    private var customCell:NewfeatureCell?
    ///true:标志当前还在最后一页,'按钮'不需要在做动画;false: 标志已经离开最后一页,在进入最后一页时,'按钮'需做动画
    var flag:Bool = true
    ///自定义布局
    private var layout:UICollectionViewFlowLayout = NewfeatureLayout()
    
    ///构造函数
    init() {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //注册 cell
        self.collectionView!.register(NewfeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageCount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! NewfeatureCell
        cell.imageIndex = indexPath.item + 1
        return cell
    }

    ///在引导页的最后一页完全显示之后才显示"进入按钮"
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //获取当前显示的cell对应的索引
        let path = collectionView.indexPathsForVisibleItems.last!
        //如果是最后一页则显示"进入按钮"
        if path.item == (pageCount - 1)  {
            let cell = collectionView.cellForItem(at: IndexPath.init(item: path.item, section: 0)) as! NewfeatureCell
            customCell = cell
            if flag { cell.startBtnAnimation() }
            flag = false
        } else {
            customCell?.startBtn.isHidden = true
            flag = true
        }
    }
}


//MARK:- 自定义UICollectionViewCell
fileprivate class NewfeatureCell:UICollectionViewCell {
    
    fileprivate var imageIndex:Int? {
        didSet {
            iconView.image = UIImage.init(named: "new_feature_\(imageIndex!)")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //布局界面
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///按钮显示的动画
    fileprivate func startBtnAnimation() {
        startBtn.isHidden = false
        startBtn.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
        startBtn.isUserInteractionEnabled = false
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1.5, initialSpringVelocity: 1.5, options: UIViewAnimationOptions.init(rawValue: 0), animations: {
            [weak self] in
            self!.startBtn.transform = CGAffineTransform.identity
            }) { [weak self] (_) in
                self!.startBtn.isUserInteractionEnabled = true
        }
    }
    
    ///初始化 UI界面
    private func setUpUI(){
        //添加UIImageView控件到 contentView 上
        contentView.addSubview(iconView)
        contentView.addSubview(startBtn)
        //布局子控件
       iconView.xmg_Fill(referView: contentView)
       startBtn.xmg_AlignInner(type: XMG_AlignType.BottomCenter, referView: contentView, size: nil, offset: CGPoint(x: 0, y: -160))
    }
    ///懒加载背景视图
    private lazy var iconView = UIImageView()
    ///懒加载'进入微博'按钮
    fileprivate lazy var startBtn:UIButton = {
       let btn = UIButton()
        btn.setImage(UIImage(named: "new_feature_button"), for: UIControlState.normal)
        btn.setImage(UIImage(named: "new_feature_button_highlighted"), for: UIControlState.normal)
        btn.isHidden = true
        btn.addTarget(self, action: #selector(startBtnClick), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    ///按钮响应事件
    func startBtnClick() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: changeViewControllerNotification), object: true)
    }
}


//MARK:- 自定义布局
fileprivate class NewfeatureLayout:UICollectionViewFlowLayout {
    override func prepare() {
        //设置 cell 的大小
        itemSize = UIScreen.main.bounds.size
        //设置水平间距
        minimumInteritemSpacing = 0
        //设置垂直间距
        minimumLineSpacing = 0
    
        //禁止反弹效果
        collectionView?.bounces = false
        //隐藏水平滚动线
        collectionView?.showsHorizontalScrollIndicator = false
        //设置分页
        collectionView?.isPagingEnabled = true
        
        //设置水平方向
        self.scrollDirection = UICollectionViewScrollDirection.horizontal
    }
}
