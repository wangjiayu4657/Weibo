//
//  PictureBrowserCell.swift
//  WeiBo
//
//  Created by wangjiayu on 2016/12/7.
//  Copyright © 2016年 fangjs. All rights reserved.
/** 图片浏览器界面上要展示图片的的 cell */

import UIKit
import SDWebImage

protocol PictureBrowserCellDelegate {
    func PictureBrowserCellDelegateDidClose(cell:PictureBrowserCell)
}

class PictureBrowserCell: UICollectionViewCell {
    
    var delegate : PictureBrowserCellDelegate?
    
    ///图片的下载地址
    var iconURL:URL? {
        didSet {
                reset()
                iconView.sd_setImage(with: iconURL, completed: {(image, _, _, _) -> Void in
                self.setImagePosition()
            })
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //设置界面
        setupUI()
    }
    
    ///初始化界面
    private func setupUI() {
        
        //添加子控件
        addSubview(scrollView)
        scrollView.addSubview(iconView)
        scrollView.backgroundColor = UIColor.white

        //布局子控件
        scrollView.frame = UIScreen.main.bounds
        
        //设置代理
        scrollView.delegate = self
        //最大缩放比
        scrollView.maximumZoomScale = 2.0
        //最小缩放比
        scrollView.minimumZoomScale = 0.5
        
        //添加点击手势
        let tap = UITapGestureRecognizer()
        iconView.addGestureRecognizer(tap)
        iconView.isUserInteractionEnabled = true
        tap.addTarget(self, action: #selector(close))
    }
    
    ///重置
    private func reset() {
        //重置scrollView的contentSize为zero
        scrollView.contentSize = CGSize.zero
        //重置iconView的形变
        iconView.transform = CGAffineTransform.identity
    }
    
    ///关闭控制器
    func close() {
        delegate?.PictureBrowserCellDelegateDidClose(cell: self)
    }
    
    ///调整图片的位置
    private func setImagePosition() {
        //获取到等比例缩放的图片的尺寸
        let size = displayPictureSize(image: iconView.image!)
        //判断图片的高度
        if size.height < UIScreen.main.bounds.size.height {
            self.iconView.frame = CGRect.init(origin: CGPoint.zero, size: size)
            let y = (UIScreen.main.bounds.size.height - size.height) * 0.5
            self.scrollView.contentInset = UIEdgeInsetsMake(y, 0, y, 0)
        } else {
            self.iconView.frame = CGRect.init(origin: CGPoint.zero, size: size)
            scrollView.contentSize = size
        }
    }
    
    ///根据图片的宽高比来等比例缩放图片
    private func displayPictureSize(image:UIImage) -> CGSize {
        //计算图片的高宽比例
        let scale = image.size.height / image.size.width
        let width = UIScreen.main.bounds.size.width
        //根据比例计算图片的高度
        let height = width * scale
        return CGSize.init(width: width, height: height)
    }
    
    //MARK:- 懒加载
    ///展示图
    lazy var iconView:UIImageView = UIImageView()
    ///背景容器
    private lazy var scrollView:UIScrollView = UIScrollView()
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK:- UIScrollViewDelegate
extension PictureBrowserCell : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return iconView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        var offsetX = (UIScreen.main.bounds.size.width - view!.frame.size.width) * 0.5
        var offsetY = (UIScreen.main.bounds.size.height - view!.frame.size.height) * 0.5
        offsetX = offsetX < 0 ? 0 : offsetX
        offsetY = offsetY < 0 ? 0 : offsetY
        scrollView.contentInset = UIEdgeInsets.init(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
    }
}
