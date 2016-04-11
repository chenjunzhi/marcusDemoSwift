//
//  MSLog.swift
//  marcusDemoSwift
//
//  Created by marcus on 16/1/7.
//  Copyright © 2016年 marcus. All rights reserved.
//

import Foundation

/**
 打印日志
 
 - parameter message: 日志内容
 - parameter file:    __FILE__
 - parameter Method:  __FUNCTION__
 - parameter line:    __LINE__
 */
func printLog<T>(message: T,
                    file: String = #file,
                  Method: String = #function,
                    line: Int = #line)
{
    print("\((file as NSString).lastPathComponent)[\(line)],\(Method): \(message)]")
}