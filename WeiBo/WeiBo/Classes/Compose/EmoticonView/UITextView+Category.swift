//
//  UITextView+Category.swift
//  EmoticonKeyboard
//
//  Created by wangjiayu on 2016/12/16.
//  Copyright © 2016年 wangjiayu. All rights reserved.
//

import UIKit

extension UITextView {
    
     ///插入表情符
    func insertEmoticonAttributedText(emoticon: Emoticon){
        //处理删除按钮
        if emoticon.isRemoveButton {
             deleteBackward()
        }
        //判断是否为 emoji 表情
        if emoticon.emojiStr != nil {
            self.replace(self.selectedTextRange!, withText: emoticon.emojiStr!)
        }
        
        //判断是否为图片表情
        if emoticon.png != nil {
            //根据模型创建一个表情字符串
            let imageText = EmoticonNSTextAttachment.imageText(emoticon: emoticon, font:font ?? UIFont.systemFont(ofSize: 17))
            
            //拿到customTextView当前所有的内容
            let strM = NSMutableAttributedString.init(attributedString: self.attributedText)
            //获取光标所在的位置
            let range = self.selectedRange
            //替换表情符到当前光标所在的位置
            strM.replaceCharacters(in:range, with: imageText)
            //属性字符串有自己默认的尺寸
            strM.addAttribute(NSFontAttributeName, value: font!, range: NSRange.init(location: range.location, length: 1))
            //将属性字符串赋值个customTextView
            self.attributedText = strM
            //回复光标的位置
            //两个参数:第一个是指定光标的位置;第二个是选中文本的个数
            self.selectedRange = NSRange.init(location: range.location + 1, length: 0)
            //主动调用代理函数来清除 placeholder
            delegate?.textViewDidChange!(self)
        }
    }
    
    ///返回发送给服务器的字符串
    func emoticonAttributedText() -> String {
        //声明一个容器字符串
        var strM = String()
        //遍历customTextView是内容,获取要发送给服务器的数据
        attributedText.enumerateAttributes(in: NSRange.init(location: 0, length: attributedText.length), options: NSAttributedString.EnumerationOptions.init(rawValue: 0)) { (object, range, _) in
            //遍历的时候传递给我们的 object 是一个字典,如果这个字典中有NSAttachment这个 key 就说明当前是一个图片
            if object["NSAttachment"] != nil {
                strM += (object["NSAttachment"] as! EmoticonNSTextAttachment).chs!
            } else {
                //range 就是纯字符串的范围
                strM += (text as NSString).substring(with: range)
            }
        }
        return strM
    }
}
