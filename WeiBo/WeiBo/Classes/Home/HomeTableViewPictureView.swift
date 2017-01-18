//
//  HomeTableViewPictureView.swift
//  WeiBo
//
//  Created by fangjs on 2016/11/28.
//  Copyright © 2016年 fangjs. All rights reserved.
/**  HomeTableViewCell中显示配图的自定义 view */

import UIKit
import SDWebImage

///间距
let margin:CGFloat = 10.0

///cell的重用标识符
let cellReuseIdentifier = "cellReuseIdentifier"


class HomeTableViewPictureView: UICollectionView {
    ///数据模型
    var statuse:StatusesModel? {
        didSet {
            //刷新表格
            reloadData()
        }
    }
    ///配图布局对象
    private let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    ///初始化构造函数
    init() {
        super.init(frame: CGRect.zero, collectionViewLayout: layout)
        
        //初始化collectionView
        setUpCollectionView()
    }
    
    ///初始化 collectionView
    private func setUpCollectionView() {
        //注册 cell
        register(pictureViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        //设置数据源
        dataSource = self
        //设置代理
        delegate = self
        //设置间距
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        //设置pictureView的背景色
        backgroundColor = UIColor.clear
    }

    ///计算配图的尺寸
    func caculateImageSize() -> CGSize {
        //先获取缩略图的个数
        let count = statuse?.storePicURLs?.count
        //如果个数为0或为 nil 则返回CGSize.zero
        if count == 0 || count == nil { return CGSize.zero }
        //如果个数为1则返回原始尺寸
        if count == 1 {
            //将 URL 转换为 String
            let url = statuse?.storePicURLs!.first?.absoluteString
            let imageSize = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: url!)
            if imageSize == nil { return CGSize.zero }
            layout.itemSize = imageSize!.size
            return imageSize!.size
        }
        let width:CGFloat = 100.0
        layout.itemSize = CGSize.init(width: width, height: width)
        if count == 2 {
            let viewWidth = width * 2 + margin
            return CGSize.init(width: viewWidth, height: width)
        }
        //如果个数为4则返回田字格的尺寸
        if count == 4 {
            let viewWidth = width * 2 + margin
            return CGSize.init(width: viewWidth, height: viewWidth)
        }
        //如果是其他(多张图) 返回九宫格的尺寸
        //列数
        let colNumber = 3
        //行数
        let rowNumber = (count! - 1) / 3 + 1
        //宽度 = 列数 * 图片的宽度 + (列数 - 1) * 间隙
        let viewWidth = colNumber * Int(width) + (colNumber - 1) * Int(margin)
        //高度 = 行数 * 图片的高度 + (行数 - 1) * 间隙
        let viewHeith = rowNumber * Int(width) + (rowNumber - 1) * Int(margin)
        return CGSize.init(width: viewWidth, height: viewHeith)
    }

    //MARK:- 自定义UICollectionViewCell
    fileprivate class pictureViewCell:UICollectionViewCell {
        
        fileprivate var imageURL:URL?{
            didSet {
                pictureImageView.sd_setImage(with: imageURL)
                if (imageURL!.absoluteString as NSString).pathExtension.lowercased() == "gif" {
                    gifImageView.isHidden = false
                } else {
                    gifImageView.isHidden = true
                }
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            //初始化界面
            setUpUI()
        }
        
        ///初始化 UI
        private func setUpUI() {
            //添加子控件
            contentView.addSubview(pictureImageView)
            pictureImageView.addSubview(gifImageView)
            //布局子控件
            pictureImageView.xmg_Fill(referView: contentView)
            gifImageView.xmg_AlignInner(type: XMG_AlignType.BottomRight, referView: pictureImageView, size: nil)
        }
        
        //MARK:- 懒加载
        private lazy var pictureImageView:UIImageView = UIImageView()
        private lazy var gifImageView:UIImageView = {
           let gifImage = UIImageView.init(image: UIImage.init(named: "avatar_vgirl"))
            gifImage.isHidden = true
            return gifImage
        }()
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK:- UICollection View data source
extension HomeTableViewPictureView : UICollectionViewDataSource , UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statuse?.storePicURLs?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! pictureViewCell
        cell.imageURL = statuse?.storePicURLs![indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//         print(statuse?.bigStorePicURLs![indexPath.item])
        
        window?.rootViewController?.present(PictureBrowserController.init(index: indexPath.item, urls: (statuse?.bigStorePicURLs)!), animated: true, completion: nil)
        
    }
}


