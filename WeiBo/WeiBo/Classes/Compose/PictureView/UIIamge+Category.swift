//
//  UIIamge+Category.swift
//  WeiBo
//
//  Created by wangjiayu on 2016/12/27.
//  Copyright © 2016年 fangjs. All rights reserved.
//

import UIKit

extension UIImage {
    
    /**
     根据传入的宽度生成一张图片
     按照图片的宽高比来压缩以前的图片
     :param: width 制定宽度
     */

    func imageWithScale(imageWidth:CGFloat) -> UIImage {
        //根据宽度来计算图片的高度
        let imageHeight = imageWidth * size.height / size.width
        let currentSize = CGSize.init(width: imageWidth, height: imageHeight)
        //按照宽高比来绘制一张新的图片
        UIGraphicsBeginImageContext(currentSize)
        draw(in: CGRect.init(origin: CGPoint.zero, size: currentSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
