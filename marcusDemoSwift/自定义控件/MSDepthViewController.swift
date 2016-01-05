//
//  MSDepthViewController.swift
//  marcusDemoOC
//
//  Created by marcus on 15/12/25.
//  Copyright © 2015年 marcus. All rights reserved.
//  具有 景深/侧边弹出/高斯模糊 效果的界面

import UIKit

// 弹出效果
public enum DepthPopupStyle : Int {
  case Top        //从上面弹出  最后靠上
  case Bottom     //从下面弹出  最后靠下
  case Left       //从左侧弹出  最后靠左
  case Right      //从右侧弹出  最后靠右
  case Grow       //从中间扩展动画  最后居中
  case Shrink     //从中间收缩动画  最后居中
  case None       //没有动画  最后据居中
}

class MSDepthViewController: UIViewController {
  //  presentDepthView 参数
  //  view: 需要弹出的View(最终的大小由该View的frame确定)
  //  backgroundColor: 背景色  默认为黑色
  //  duration: 动画时间 0 时则没有动画
  //  popupStyle: 弹出样式
  //  blur: 高斯模糊值 0 - 1.0 (0:没有高斯模糊效果)
  //  depthSacle: 景深缩放比例 0 - 1.0
  //  completion：退出景深界面后执行的操作
  class func presentDepthView(view: UIView, backgroundColor: UIColor?, animateDuration: NSTimeInterval, popupStyle : DepthPopupStyle, blur: Double, depthSacle: Double, completion: (() -> Void)?) {
     let depthVC = MSDepthViewController()
     depthVC.presentView = view
    if let tempColor = backgroundColor {
      depthVC.backgroundColor = tempColor
    }
    depthVC.animateDuration = animateDuration
    depthVC.popupStyle = popupStyle
    depthVC.blur = blur*40.0
    depthVC.depathScale = depthSacle
    depthVC.completion = completion
    if let currentVC = MSApplication.getCurrentTopViewController(){
      depthVC.convertImage = MSManageImage.convertViewImage(currentVC.view)
      depthVC.beginTransform = currentVC.view.transform
      currentVC.presentViewController(depthVC, animated: false, completion: nil)
    }
    
  }
  
  class func presentDepthView(view: UIView, backgroundColor: UIColor?, animateDuration: NSTimeInterval, popupStyle : DepthPopupStyle, blur: Double, depthSacle: Double){
    MSDepthViewController.presentDepthView(view, backgroundColor: backgroundColor, animateDuration: animateDuration, popupStyle: popupStyle, blur: blur, depthSacle: depthSacle) { () -> Void in
    }
  }
  
  class func presentDepthView(view: UIView, popupStyle : DepthPopupStyle) {
    MSDepthViewController.presentDepthView(view, backgroundColor: UIColor.blackColor(), animateDuration: 0.5, popupStyle: DepthPopupStyle.Bottom, blur: 0.5, depthSacle: 0.9) { () -> Void in
    }
  }
  
  class func dissmissWithAnimation(animation: Bool, completion: (() -> Void)?){
    if let currentVC = MSApplication.getCurrentTopViewController(){
      if (currentVC.isKindOfClass(MSDepthViewController.classForCoder())){
        let tempVC = currentVC as! MSDepthViewController
        tempVC.dissmissPresentView(animation,completion: completion)
      }
    }
  }
  
  var presentView: UIView?
  var backgroundColor = UIColor.blackColor()
  var animateDuration: NSTimeInterval = 0.5
  var popupStyle: DepthPopupStyle = .Top
  var blur  = 0.5*40.0
  var depathScale = 0.9
  var completion: (() -> Void)?
  var convertImage = UIImage()
  let visualEffectView = UIVisualEffectView.init(effect: UIBlurEffect.init(style: .Light))
  //背景view
  private var backgroundView = UIView.init(frame: CGRectMake(0, 0, MSApplication.sharedApplication().screenWidth, MSApplication.sharedApplication().screenHeight))
  private var coverView = UIView.init(frame: CGRectMake(0, 0, MSApplication.sharedApplication().screenWidth, MSApplication.sharedApplication().screenHeight))
  //做动画的View
  var animationImageView = UIImageView.init(frame: CGRectMake(0, 0, MSApplication.sharedApplication().screenWidth, MSApplication.sharedApplication().screenHeight))
  //高斯模糊的View
  var gaussianImageView = UIImageView.init(frame: CGRectMake(0, 0, MSApplication.sharedApplication().screenWidth, MSApplication.sharedApplication().screenHeight))
  private var beginTransform = CGAffineTransform()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.clearColor()
    view.addSubview(backgroundView)
    view.addSubview(animationImageView)
    view.addSubview(gaussianImageView)
    gaussianImageView.backgroundColor = UIColor.clearColor()
    gaussianImageView.hidden = true
    //转高斯模糊效果图片方法
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
      weak var tempSelf = self
      let scaleImage = MSManageImage.scaleImage((tempSelf?.convertImage)!, scale: CGFloat((tempSelf?.depathScale)!), background: (tempSelf?.backgroundColor)!)
      let gaussianImage = MSManageImage.gaussianBlurOnImage(scaleImage, blur: tempSelf!.blur)
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        tempSelf?.gaussianImageView.image = gaussianImage
      })
    }
    coverView.backgroundColor = UIColor(colorLiteralRed: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.5)
    view.addSubview(coverView)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    backgroundView.backgroundColor = backgroundColor
    animationImageView.image = convertImage
    let tap = UITapGestureRecognizer(target: self, action: "dissmissPresentView")
    coverView.addGestureRecognizer(tap)
    self.popupPosition()
    view.addSubview(presentView!)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    if (animateDuration == 0){
      self.animatePopupWithStyle()
    }else{
      UIView.animateWithDuration(animateDuration, animations: { () -> Void in
        self.animatePopupWithStyle()
        }, completion: { (Bool) -> Void in
          self.gaussianImageView.hidden = false
      })
    }
  }
  
  func dissmissPresentView(){
    self.dissmissPresentView(true, completion: nil)
  }
  
 private func dissmissPresentView(animation: Bool, completion: (() -> Void)? ){
    if (animation){
    UIView.animateWithDuration(animateDuration, animations: { () -> Void in
      self.popupPosition()
      }) { (Bool) -> Void in
        self.dismissViewControllerAnimated(false, completion: { () -> Void in
          if let tempCompletion = completion{
            tempCompletion()
          }
          if let tempCompletion = self.completion{
            tempCompletion()
          }
        })
      }}else{
      self.popupPosition()
      self.dismissViewControllerAnimated(false, completion: { () -> Void in
        if let tempCompletion = completion{
          tempCompletion()
        }
        if let tempCompletion = self.completion{
          tempCompletion()
        }
      })
    }
  }
  
  
  //MARK 初始化presentView 的位置 及初始值
  func popupPosition(){
    gaussianImageView.hidden = true
    animationImageView.transform = self.beginTransform
    coverView.alpha = 0.5
    visualEffectView.alpha = 0
    var rect = presentView?.frame
    switch(self.popupStyle){
    case .Top:
      rect?.origin.x = 0
      rect?.origin.y = -(rect?.size.height)!
      presentView?.frame = rect!
      break
    case.Bottom:
      rect?.origin.x = 0
      rect?.origin.y = MSApplication.sharedApplication().screenHeight
      presentView?.frame = rect!
      break
    case.Left:
      rect?.origin.x = -(rect?.size.width)!
      rect?.origin.y = 0
      presentView?.frame = rect!
      break
    case.Right:
      rect?.origin.x = MSApplication.sharedApplication().screenWidth
      rect?.origin.y = 0
      presentView?.frame = rect!
      break
    case.Grow:
      break
    case.Shrink:
      break
    case.None:
      break
    }
  }
  
  //MARK presentView 动画的方式弹出到特定位置 及最终值
  func animatePopupWithStyle() {
    animationImageView.transform = CGAffineTransformMakeScale(CGFloat(depathScale), CGFloat(depathScale))
    coverView.alpha = 0.5
    visualEffectView.alpha = CGFloat(blur)
    var rect = presentView?.frame
    switch(self.popupStyle){
    case .Top:
      rect?.origin.y = 0
      self.presentView?.frame = rect!
      break
    case.Bottom:
      rect?.origin.y = MSApplication.sharedApplication().screenHeight-(rect?.size.height)!
      self.presentView?.frame = rect!
      break
    case.Left:
      rect?.origin.x = 0
      self.presentView?.frame = rect!
      break
    case.Right:
      rect?.origin.x = MSApplication.sharedApplication().screenWidth-(rect?.size.width)!
      self.presentView?.frame = rect!
      break
    case.Grow:
      break
    case.Shrink:
      break
    case.None:
      break
    }
  }
  
}
