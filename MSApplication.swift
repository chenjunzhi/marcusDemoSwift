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
  
  // 屏幕尺寸
  let screenWidth = UIScreen.mainScreen().bounds.width
  let screenHeight = UIScreen.mainScreen().bounds.height
  
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
    
    let rootView = Int(Double(UIDevice.currentDevice().systemVersion)!*1000)>=8000 ? topWindow?.subviews[0].subviews[0] : topWindow?.subviews[0]
    let nextResponder: AnyObject? = rootView?.nextResponder()
    
    if let tempResponder = nextResponder{
      if (tempResponder.isKindOfClass(UIViewController.classForCoder())){
        result = tempResponder as? UIViewController
      }else if let _ = topWindow?.rootViewController {
        if (topWindow!.respondsToSelector("rootViewController")){
          result = topWindow?.rootViewController
        }
      }
    }
    
    if let tempResult = result {
      while (tempResult.respondsToSelector("rootViewController") || tempResult.respondsToSelector("topViewController") || tempResult.respondsToSelector("selectedViewController")){
        if (tempResult.respondsToSelector("rootViewController") ){
          if let _ = tempResult.valueForKey("rootViewController"){
            result = tempResult.valueForKey("rootViewController") as? UIViewController
          }
        }else if (tempResult.respondsToSelector("topViewController")){
          result = tempResult.valueForKey("topViewController") as? UIViewController
        }else if (tempResult.respondsToSelector("selectedViewController")){
          result = tempResult.valueForKey("selectedViewController") as? UIViewController
        }
      }
    }
    
    return result
  }
}
