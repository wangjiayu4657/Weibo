//
//  EmoticonPackage.swift
//  EmoticonKeyboard
//
//  Created by wangjiayu on 2016/12/14.
//  Copyright © 2016年 wangjiayu. All rights reserved.
//

/*
 结构:
 1. 加载emoticons.plist拿到每组表情的路径
 
 emoticons.plist(字典)  存储了所有组表情的数据
 |----packages(字典数组)
 |-------id(存储了对应组表情对应的文件夹)
 
 2. 根据拿到的路径加载对应组表情的info.plist
 info.plist(字典)
 |----id(当前组表情文件夹的名称)
 |----group_name_cn(组的名称)
 |----emoticons(字典数组, 里面存储了所有表情)
 |----chs(表情对应的文字)
 |----png(表情对应的图片)
 |----code(emoji表情对应的十六进制字符串)
 */


import UIKit

class EmoticonPackage: NSObject {
    /// 当前组表情文件夹的名称
    var id:String?
    ///组的名称
    var group_name_cn:String?
    ///字典数组, 里面存储了所有表情
    var emoticons:[Emoticon]?
    
    init(id:String) {
        self.id = id
        super.init()
    }
    ///静态变量只会加载一次,可以提高性能
    static let packagesList:[EmoticonPackage] = EmoticonPackage.loadPackages()
    ///获取所有组的表情数据
    private class func loadPackages() -> [EmoticonPackage] {
        var packages = [EmoticonPackage]()
        //添加"最近"组
        let emptyGroup = EmoticonPackage.init(id: "")
        emptyGroup.group_name_cn = "最近"
        emptyGroup.emoticons = [Emoticon]()
        emptyGroup.appendRemoveButton()
        packages.append(emptyGroup)
        
        //加载路径
        let path = Bundle.main.path(forResource: "emoticons.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        //加载 emoticons.plist
        let dict = NSDictionary.init(contentsOfFile: path)!
        //从emoticons中获取packages
        let packageArray = dict["packages"] as! [[String:AnyObject]]
        
        //遍历数组
        for dic in packageArray {
            //取出 id, 创建对应的组
            let emoticon = EmoticonPackage(id: dic["id"]! as! String)
            packages.append(emoticon)
            emoticon.loadEmoticon()
            emoticon.appendRemoveButton()
        }
        
        return packages
    }
    ///加载每一组中所有的表情
     func loadEmoticon(){
        //获取文件路径
        let dictionary = NSDictionary.init(contentsOfFile: infoPath())!
        group_name_cn = dictionary["group_name_cn"] as? String
        let dictArray = dictionary["emoticons"] as? [[String:String]]
        emoticons = [Emoticon]()
        //索引
        var index:Int = 0
        //遍历数组,将字典转为模型
        for dic in dictArray! {
            //如果 index==20则在第二十一个位置插入一个删除按钮
            if index == 20 {
                emoticons?.append(Emoticon.init(isRemoveButton: true))
                //插入删除按钮后要清零,下次重新计数,循环插入删除按钮
                index = 0
            }
            emoticons?.append(Emoticon.init(dictonary: dic, id: id!))
            index += 1
        }
    }
    
    ///追加删除按钮
    func appendRemoveButton() {
        let count = emoticons!.count % 21
        for _ in count ..< 20  {
            emoticons?.append(Emoticon.init(isRemoveButton: false))
        }
        
        emoticons?.append(Emoticon.init(isRemoveButton: true))
    }
    
    func appendEmoticons(emoticon:Emoticon) {
        //判断是否为删除按钮
        if emoticon.isRemoveButton {
            return
        }
        //判断当前点击的表情是否已经添加到最近表情数组中
        let contain = emoticons!.contains(emoticon)
        if !contain {
            //删除"删除按钮"
            emoticons?.removeLast()
            emoticons?.append(emoticon)
        }
        //排序
        var result = emoticons?.sorted(by: { (e1, e2) -> Bool in
            return e1.times > e2.times
        })
        //删除多与表情
        if !contain {
            //删除多余表情
            result?.removeLast()
            //将删除按钮添加到最后
            result?.append(Emoticon.init(isRemoveButton: true))
        }
        //将处理好的数据数组赋值给emoticons
        emoticons = result
    }
    
    ///获取指定文件的主路径
    private  func infoPath() -> String {
        return (EmoticonPackage.emoticonPath().appendingPathComponent(id!) as NSString).appendingPathComponent("info.plist")
    }
    
    ///获取微博表情的主路径
    class func emoticonPath() -> NSString {
        return (Bundle.main.bundlePath as NSString).appendingPathComponent("Emoticons.bundle") as NSString
    }
}

//MARK:- 表情模型
class Emoticon : NSObject {
    ///表情对应的文字
    var chs:String?
    ///表情对应的图片
    var png:String? {
        didSet {
            imagePath = (EmoticonPackage.emoticonPath().appendingPathComponent(id!) as NSString).appendingPathComponent(png!)
        }
    }
    ///当前表情对应的文件夹
    var id:String?
    ///表情对应的十六进制数
    var code:String? {
        didSet {
            //构建扫描器
            let scanner = Scanner.init(string: code!)
            //取出十六进制数
            var result:UInt32 = 0
            scanner.scanHexInt32(&result)
            //将十六进制数转换为字符串
            emojiStr =  "\(Character.init(UnicodeScalar.init(result)!))"
        }
    }
    
    ///图片表情的全路径
    var imagePath:String?
    
    ///emoji 表情
    var emojiStr:String?
    
    ///是否添加删除按钮
    var isRemoveButton:Bool = false
    
    ///记录当前表情使用的次数
    var times:Int = 0
    
    init(isRemoveButton:Bool) {
        self.isRemoveButton = isRemoveButton
        super.init()
    }
    init(dictonary:[String:String],id:String){
        super.init()
        self.id = id
        setValuesForKeys(dictonary)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}









