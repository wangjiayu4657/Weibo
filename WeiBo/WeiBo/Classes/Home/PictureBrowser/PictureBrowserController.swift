//
//  PictureBrowserController.swift
//  WeiBo
//
//  Created by wangjiayu on 2016/12/7.
//  Copyright © 2016年 fangjs. All rights reserved.
/** 图片浏览器界面 */

import UIKit

private let pictureCellReuseIdentifier = "pictureCellReuseIdentifier"

class PictureBrowserController: UIViewController {
    
    ///图片索引
    var pictureIndex:Int?
    ///图片地址
    var pictureURLs:[URL]?
    ///构造一个初始化函数
    init(index:Int,urls:[URL]) {
        pictureIndex = index
        pictureURLs = urls
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        //初始化界面
        setUpUI()
        //初始化 collectionView
        setupCollectionView()
    }

    ///设置 UI 界面
    private func setUpUI() {
        //添加子控件
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        //布局子控件
        closeBtn.xmg_AlignInner(type: XMG_AlignType.BottomLeft, referView: view, size: CGSize.init(width: 100, height: 35), offset: CGPoint.init(x: margin, y: -margin))
        saveBtn.xmg_AlignInner(type: XMG_AlignType.BottomRight, referView: view, size: CGSize.init(width: 100, height: 35), offset: CGPoint.init(x: -margin, y: -margin))
        collectionView.frame = UIScreen.main.bounds
    }
    
    ///初始化 collectionView
    private func setupCollectionView() {
        collectionView.dataSource = self
        // 注册
        collectionView.register(PictureBrowserCell.self, forCellWithReuseIdentifier: pictureCellReuseIdentifier)
    }
    
    //MARK:- 懒加载
    private lazy var closeBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("关闭", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.backgroundColor = UIColor.darkGray
        btn.addTarget(self, action: #selector(closeBtnClick), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    private lazy var saveBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("保存", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.backgroundColor = UIColor.darkGray
        btn.addTarget(self, action: #selector(saveBtnClick), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    private lazy var collectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: pictureViewLayout())
    
    
    //MARK:- 按钮响应事件
    //关闭按钮
    func closeBtnClick() {
        dismiss(animated: true, completion: nil)
    }
    //保存按钮
    func saveBtnClick() {
        print(#function)
        //获当前正在显示的 cell
        let index = collectionView.indexPathsForVisibleItems.last
        let cell = collectionView.cellForItem(at: index!) as! PictureBrowserCell
        //获取要保存的图片
        let image = cell.iconView.image
        
        //保存图片 注意:保存图片是的方法调用
        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    ///保存图片时会调用这个方法
    func image(image:UIImage,didFinishSavingWithError error:Error?,contextInfo:AnyObject) {
        if error == nil {
            print("保存成功")
        } else {
            print("保存失败")
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

//MARK:- UICollectionViewDataSource
extension PictureBrowserController : UICollectionViewDataSource , PictureBrowserCellDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureURLs?.count ?? 0
    } 
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pictureCellReuseIdentifier, for: indexPath) as! PictureBrowserCell
        cell.delegate = self
        cell.iconURL = pictureURLs![indexPath.item]
        return cell
    }
    
    ///PictureBrowserCellDelegate 关闭控制器
    func PictureBrowserCellDelegateDidClose(cell: PictureBrowserCell) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK:- 自定义布局
fileprivate class pictureViewLayout:UICollectionViewFlowLayout {
    //准备布局
    fileprivate override func prepare() {
        //设置 item 尺寸
        itemSize = UIScreen.main.bounds.size
        //行间距
        minimumLineSpacing = 0
        //列间距
        minimumInteritemSpacing = 0
        //水平滚动
        scrollDirection = UICollectionViewScrollDirection.horizontal
        //设置分页
        collectionView?.isPagingEnabled = true
        //隐藏水平滚动条
        collectionView?.showsHorizontalScrollIndicator = false
    }
}














