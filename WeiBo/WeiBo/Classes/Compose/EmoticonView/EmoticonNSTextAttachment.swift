//
//  EmoticonNSTextAttachment.swift
//  EmoticonKeyboard
//
//  Created by wangjiayu on 2016/12/16.
//  Copyright © 2016年 wangjiayu. All rights reserved.
//

import UIKit

class EmoticonNSTextAttachment: NSTextAttachment {
    var chs:String?
    
    class func imageText(emoticon:Emoticon,font:UIFont) -> NSAttributedString {
        let attachment = EmoticonNSTextAttachment.init()
        attachment.image = UIImage.init(contentsOfFile: emoticon.imagePath!)
        attachment.bounds = CGRect.init(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
        attachment.chs = emoticon.chs
        //根据附件创建属性字符串
        return NSAttributedString.init(attachment: attachment)
    }
    
}
