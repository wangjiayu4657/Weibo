//
//  EnnoticonView.swift
//  WeiBo
//
//  Created by wangjiayu on 2016/12/21.
//  Copyright © 2016年 fangjs. All rights reserved.
//

import UIKit

//typealias emoticonSelectedCallBack = (_ emoticon:Emoticon)->()

private let emotionViewCellReuseIdentifier = "emotionViewCellReuseIdentifier"

class EmoticonView: UIView {
    ///显示哪组表情键盘的索引,默认为1,所以默认显示默认表情
    var index:Int = 1
    ///计数,用来记录一组21个表情符是否加载完毕
    var count:Int = 0
    ///标志位,当点击表情按钮进行切换表情时,判断是否是默认表情,如果是则不进行任何操作
    var flag:Bool = false
    ///回调类型
    var emoticonSelectedCallBack:(_ emoticon:Emoticon)->()
    
    ///构造函数
    init(frame: CGRect,callBack:@escaping (_ emoticon:Emoticon)->()) {
        self.emoticonSelectedCallBack = callBack
        super.init(frame: frame)
        
        //初始化界面
        setupUI()
    }
    
    ///初始化界面
    private func setupUI() {
        //添加子控件
        addSubview(collectionView)
        addSubview(toolBar)
        //布局子控件
        //先清除原有的自动布局
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        //初始化约束数组
        var cons = [NSLayoutConstraint]()
        let dict:[String : Any] = ["collectionView":collectionView ,"toolBar":toolBar]
        //collectionView的水平约束
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: dict)
        //toolBar的水平约束
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[toolBar]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: dict)
        //toolBar的垂直约束
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-[toolBar(44)]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: dict)
        //添加约束
        addConstraints(cons)
    }
    
    ///监听底部工具条上按钮的点击事件
    func itemClick(item:UIBarButtonItem) {
        //第一次进来显示的是默认表情,所以当再点击默认按钮时不移动
        if flag {
            collectionView.scrollToItem(at: IndexPath.init(item: 0, section: item.tag), at: UICollectionViewScrollPosition.left, animated: true)
        }
        // item.tag = 1是"默认"按钮,当点击除默认按钮以为的按钮时 flag 设为 true, 同时表情符号移动到对应的位置,否则不移动
        if item.tag != 1 {
            flag = true
            collectionView.scrollToItem(at: IndexPath.init(item: 0, section: item.tag), at: UICollectionViewScrollPosition.left, animated: true)
        }
    }
    
    //MARK:- 懒加载
    ///collectionView
    private lazy var collectionView:UICollectionView = {
        let cView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: customLayout())
        cView.register(EmotionCell.self, forCellWithReuseIdentifier: emotionViewCellReuseIdentifier)
        cView.backgroundColor = UIColor.white
        cView.dataSource = self
        cView.delegate = self
        return cView
    }()
    ///底部工具条
    private lazy var toolBar:UIToolbar = {
        let bar = UIToolbar()
        //字体颜色
        bar.tintColor = UIColor.darkGray
        var index = 0
        //初始化一个装UIBarButtonItem的数组
        var items = [UIBarButtonItem]()
        for title in ["最近","默认","emoji","浪小花"] {
            let item = UIBarButtonItem.init(title: title, style: UIBarButtonItemStyle.plain, target: self, action: #selector(itemClick))
            item.tag = index
            index += 1
            items.append(item)
            //添加一个弹簧
            items.append(UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil))
        }
        //删除最后一个弹簧,使四个按钮评分 toolbar 的宽度
        items.removeLast()
        bar.items = items
        return bar
    }()
    ///声明一个[EmoticonPackage]类型的数组
    fileprivate lazy var packages:[EmoticonPackage] = EmoticonPackage.packagesList
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK:- UICollectionViewDataSource / UICollectionViewDelegate
extension EmoticonView : UICollectionViewDataSource , UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return packages.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].emoticons?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emotionViewCellReuseIdentifier, for: indexPath) as! EmotionCell
        cell.backgroundColor = UIColor.clear
        
        var package:EmoticonPackage
        let emoticon:Emoticon
        
        if index == 1 {
            package = packages[index]
            emoticon = package.emoticons![indexPath.item]
            count += 1
            //表情键盘一组最多显示21个
            if count == 21 {
                //index 清零是为了让点击其他表情按钮切换数据时有效,如果不清零的话则一直显示的是默认表情
                index = 0
            }
        } else {
            package = packages[indexPath.section]
            emoticon = package.emoticons![indexPath.item]
        }
      
        cell.emoticon = emoticon
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let emoticon = packages[indexPath.section].emoticons![indexPath.item]
        emoticon.times += 1
        packages[0].appendEmoticons(emoticon:emoticon)
        emoticonSelectedCallBack(emoticon)
    }
}

//MARK:- 自定义 collectionView 的布局
fileprivate class customLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        //设置 cell 的相关属性
        let width = collectionView!.bounds.width / 7
        itemSize = CGSize.init(width: width, height: width)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        //设置 collectionView 的相关属性
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
        scrollDirection = UICollectionViewScrollDirection.horizontal
        let y = (collectionView!.bounds.height - 3 * width) * 0.45
        collectionView?.contentInset = UIEdgeInsets.init(top: y, left: 0, bottom: y, right: 0)
    }
}

//MARK:- 自定义 cell
 class EmotionCell:UICollectionViewCell {
    
    var emoticon:Emoticon? {
        didSet {
            //判断是否为图片表情
            if emoticon?.chs != nil {
                cellButton.setImage(UIImage.init(named: emoticon!.imagePath!), for: UIControlState.normal)
            } else {
                //清空是防止重用
                cellButton.setImage(UIImage.init(named: ""), for: UIControlState.normal)
            }
            //设置 emoji 表情, 加上??可以防止重用
            cellButton.setTitle(emoticon!.emojiStr ?? "", for: UIControlState.normal)
            //判断是否需要添加删除按钮
            if emoticon!.isRemoveButton {
                cellButton.setImage(UIImage.init(named: "compose_emotion_delete"), for: UIControlState.normal)
                cellButton.setImage(UIImage.init(named: "compose_emotion_delete_highlighted"), for: UIControlState.highlighted)
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //初始化界面
        setupUI()
    }
    ///初始化界面
    private func setupUI() {
        //添加子控件
        contentView.addSubview(cellButton)
        //布局子控件
        cellButton.frame = contentView.bounds.insetBy(dx: 4,dy: 4)
    }
    
    //MARK:- 懒加载
    private lazy var cellButton:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.white
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        btn.isUserInteractionEnabled = false
        return btn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



