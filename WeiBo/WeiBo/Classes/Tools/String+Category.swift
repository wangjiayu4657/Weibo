//
//  String+Category.swift
//  WeiBo
//
//  Created by fangjs on 2016/11/18.
//  Copyright © 2016年 fangjs. All rights reserved.
//

import UIKit

extension String {
    
    ///将当前字符串拼接到 caches目录后
    func cacheDirPath() -> String {
        let path = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!) as NSString
        return path.appendingPathComponent((self as NSString).lastPathComponent)
    }
    
    ///将当前字符串拼接到 document目录后
    func docDirPath() -> String {
        let path = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!) as NSString
        return path.appendingPathComponent((self as NSString).lastPathComponent)
    }
    
    ///将当前字符串拼接到 tmp目录后
    func tmpDirPath() -> String {
        let path = NSTemporaryDirectory() as NSString
        return path.appendingPathComponent((self as NSString).lastPathComponent)
    }
}
