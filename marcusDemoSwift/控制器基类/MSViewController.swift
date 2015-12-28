//
//  MSViewController.swift
//  marcusDemoSwift
//
//  Created by marcus on 15/12/23.
//  Copyright © 2015年 marcus. All rights reserved.
// **** ViewController基类 (项目中其他ViewController需继承该基类) *******

import UIKit

class MSViewController: UIViewController {
  
  
  private var firstAppeared = false
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    firstAppeared = true
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    if (firstAppeared){
       viewWillFirstAppear(animated)
    }
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    if (firstAppeared){
      firstAppeared = false
      viewDidFirstAppear(animated)
    }
  }
  
  func viewWillFirstAppear(animated: Bool)  {
  }
  
  func viewDidFirstAppear(animated: Bool){
  }
  
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}
