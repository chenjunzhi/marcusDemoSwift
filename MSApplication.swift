//
//  MSApplication.swift
//  marcusDemoSwift
//
//  Created by marcus on 15/12/24.
//  Copyright © 2015年 marcus. All rights reserved.
//

import UIKit

class MSApplication: NSObject {
  
  //对象单例
  static let applicationObj: MSApplication = MSApplication()
  
  /// 屏幕宽度
  let screenWidth = UIScreen.mainScreen().bounds.width
  /// 屏幕高度
  let screenHeight = UIScreen.mainScreen().bounds.height
    /**
     <#Description#>
     
     - returns: <#return value description#>
     */
  var phoneCallView: UIWebView?
 
  class func sharedApplication() -> MSApplication {
    return applicationObj
  }
  
  func appRootViewController() -> UIViewController? {
    return UIApplication.sharedApplication().delegate?.window!!.rootViewController
  }
  
  func refreshStatusBar(){
    appRootViewController()?.setNeedsStatusBarAppearanceUpdate()
  }
  
  func openURL(url: NSURL) -> Bool{
    return UIApplication.sharedApplication().openURL(url)
  }
  
  func callPhoneNumber(phoneNumber: String){
    let phone = phoneNumber.stringByReplacingOccurrencesOfString("-", withString: "")
    if (phone.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0){
      return
    }
    if (phoneCallView == nil){
      phoneCallView = UIWebView.init(frame: CGRectZero)
    }
    phoneCallView?.loadRequest(NSURLRequest.init(URL: NSURL.init(fileURLWithPath: "tel://\(phone)")))
  }
  
    // 判断系统版本
  func systemVersionLater(version: String) -> Bool {return UIDevice.currentDevice().systemVersion >= version}

  //获取当前最顶部的VC
  class func getCurrentTopViewController() -> UIViewController? {
    var result: UIViewController?
    let topWindow = UIApplication.sharedApplication().keyWindow
    if (topWindow?.windowLevel != UIWindowLevelNormal){
      let tempWindows = UIApplication.sharedApplication().windows
      for topWindow in tempWindows{
        if (topWindow.windowLevel == UIWindowLevelNormal){
          break
        }
      }
    }
    
    let rootView = (UIDevice.currentDevice().systemVersion >= "8.0") ? topWindow?.subviews[0].subviews[0] : topWindow?.subviews[0]
    let nextResponder: AnyObject? = rootView?.nextResponder()
    
    if let tempResponder = nextResponder{
      if (tempResponder.isKindOfClass(UIViewController.classForCoder())){
        result = tempResponder as? UIViewController
      }else if let _ = topWindow?.rootViewController {
        if (topWindow!.respondsToSelector(Selector("rootViewController"))){
          result = topWindow?.rootViewController
        }
      }
    }
    
    if let tempResult = result {
      while (tempResult.respondsToSelector(Selector("rootViewController")) || tempResult.respondsToSelector(Selector("topViewController")) || tempResult.respondsToSelector(Selector("selectedViewController"))){
        if (tempResult.respondsToSelector(Selector("rootViewController")) ){
          if let _ = tempResult.valueForKey("rootViewController"){
            result = tempResult.valueForKey("rootViewController") as? UIViewController
          }
        }else if (tempResult.respondsToSelector(Selector("topViewController"))){
          result = tempResult.valueForKey("topViewController") as? UIViewController
        }else if (tempResult.respondsToSelector(Selector("selectedViewController"))){
          result = tempResult.valueForKey("selectedViewController") as? UIViewController
        }
      }
    }
    
    return result
  }
}
