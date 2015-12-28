//
//  AppDelegate.swift
//  marcusDemoSwift
//
//  Created by marcus on 15/11/23.
//  Copyright © 2015年 marcus. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var isCurrentVersion = false //判断当前版本是否为第一次运行
  
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    isCurrentVersion = isCurrentVersionJudge()
    
    if (isCurrentVersion){
      let guideVC = MSGuideViewController()
       UIApplication.sharedApplication().delegate?.window!!.rootViewController = guideVC
    }else{
      let studySampleVC = MSStudySampleVC()
      UIApplication.sharedApplication().delegate?.window!!.rootViewController = studySampleVC
    }
    return true
  }
  
  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  //mark 判断该版本是否第一次在此设备上运行
  func isCurrentVersionJudge() -> Bool{
    var currentVersion: String?
    if let tempCurrentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]{
      currentVersion = String(tempCurrentVersion)
    }
    let defaults = NSUserDefaults.standardUserDefaults()
    var lastRunVersion: String?
    if let tempRunVersion = defaults.objectForKey(LAST_RUN_VERSION_KEY){
      lastRunVersion = String(tempRunVersion)
    }
    if (lastRunVersion == nil){
      defaults.setObject(currentVersion, forKey: LAST_RUN_VERSION_KEY)
      return true
    }else if (!(lastRunVersion == currentVersion)){
      return true
    }
    return false
  }
  

}

