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
   
    /**
     //1.简单调用方式
    
    - parameter view:       需要弹出的View(最终的大小由该View的frame确定) 必须传
    - parameter popupStyle: 弹出样式  必须传
    */
    class func presentDepthView(view: UIView, popupStyle : Int) {
        MSDepthViewController.presentDepthView(view, popupStyle: popupStyle, backgroundColor: UIColor.blackColor(), animateDuration: 0.5, blur: 0.1, realTimeBlur: true,depthSacle: 0.9) { () -> Void in
        }
    }
    /**
     1.专业调用方式
     
     - parameter view:            需要弹出的View(最终的大小由该View的frame确定) 必须传
     - parameter popupStyle:      弹出样式  必须传
     - parameter backgroundColor: 背景色  默认: 黑色
     - parameter animateDuration: 动画时间 0 时则没有动画  默认: 0.5
     - parameter blur:            高斯模糊值 0 - 1.0 (0:没有高斯模糊效果)  默认: 0.1
     - parameter realTimeBlur:    是否需要实时高斯模糊  默认: true  当动画时间为零时，该值参数无效
     - parameter depthSacle:      景深缩放比例 0 - 1.0   默认：0.9
     - parameter completion:      退出景深界面后执行的操作  默认: nil
     */
    class func presentDepthView(view: UIView, popupStyle : Int, backgroundColor: UIColor?, animateDuration: NSTimeInterval, blur: Double, realTimeBlur: Bool, depthSacle: Double, completion: (() -> Void)?) {
        let depthVC = MSDepthViewController()
        depthVC.presentView = view
        if let tempColor = backgroundColor {
            depthVC.backgroundColor = tempColor
        }
        depthVC.animateDuration = animateDuration
        depthVC.popupStyle = DepthPopupStyle(rawValue: popupStyle) ?? DepthPopupStyle.Bottom
        depthVC.blur = blur*20.0
        depthVC.depathScale = depthSacle
        depthVC.completion = completion
        depthVC.realTimeBlur = realTimeBlur
        if let currentVC = MSApplication.getCurrentTopViewController(), let windowView = UIApplication.sharedApplication().keyWindow{
            depthVC.convertImage = MSManageImage.convertViewImage(windowView)
            currentVC.presentViewController(depthVC, animated: false, completion: nil)
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
    
    var presentView = UIView()
    var backgroundColor = UIColor.blackColor()
    var animateDuration: NSTimeInterval = 0.5
    var popupStyle: DepthPopupStyle = .Top
    var blur  = 0.1*20.0
    var depathScale = 0.9
    var completion: (() -> Void)?
    var convertImage = UIImage()
    var realTimeBlur = true
    var beginRect = CGRectZero
    var endRect = CGRectZero
    var bShowView = true     //显示 还是 隐藏 View 的过程
    var currentBlur = 0.0   //动画过程中，当前高斯模糊值
    let intervalTime = 0.06 //高斯模糊间隔时间
    //背景view
    private var backgroundView = UIView.init(frame: CGRectMake(0, 0, MSApplication.sharedApplication().screenWidth, MSApplication.sharedApplication().screenHeight))
    private var coverView = UIView.init(frame: CGRectMake(0, 0, MSApplication.sharedApplication().screenWidth, MSApplication.sharedApplication().screenHeight))
    //做动画/高斯模糊的ImageView
    var animationImageView = UIImageView.init(frame: CGRectMake(0, 0, MSApplication.sharedApplication().screenWidth, MSApplication.sharedApplication().screenHeight))
    
    override func viewDidLoad() {
        #if DEBUG
            printLog("景深效果ViewDidLoad")
        #endif
        super.viewDidLoad()
        view.addSubview(backgroundView)
        
        convertImage = MSManageImage.specialScaleImage(convertImage, scale: CGFloat(depathScale), background: backgroundColor)
        beginRect = CGRect.init(-(MSApplication.sharedApplication().screenWidth*((1-depathScale)/depathScale)*0.5), -(MSApplication.sharedApplication().screenHeight*((1-depathScale)/depathScale)*0.5), MSApplication.sharedApplication().screenWidth/depathScale, MSApplication.sharedApplication().screenHeight/depathScale)
        endRect = CGRect.init(0, 0, MSApplication.sharedApplication().screenWidth, MSApplication.sharedApplication().screenHeight)
        animationImageView.contentMode = .ScaleAspectFit
        animationImageView.backgroundColor = UIColor.blackColor()
        animationImageView.frame = beginRect
        animationImageView.image = convertImage
        self.view.addSubview(animationImageView)
        coverView.backgroundColor = UIColor(colorLiteralRed: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha:0.05)
        view.addSubview(coverView)
        view.addSubview(presentView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        #if DEBUG
            printLog("景深效果viewWillAppear")
        #endif
        super.viewWillAppear(animated)
        backgroundView.backgroundColor = backgroundColor
        let tap = UITapGestureRecognizer(target: self, action: "dissmissPresentView")
        coverView.addGestureRecognizer(tap)
        self.popupPosition()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        bShowView = true
        if (animateDuration == 0){  //动画时间为零
            self.animatePopupWithStyle()
            self.gaussianBlurImage()
        }else{
            var timer: NSTimer?
            if (realTimeBlur){
                timer = NSTimer.scheduledTimerWithTimeInterval(intervalTime, target: self, selector: "gaussianBlurImageWithAnimation", userInfo: nil, repeats: true)
            }
            UIView.animateWithDuration(animateDuration, animations: { () -> Void in
                self.animatePopupWithStyle()
                }, completion: { (Bool) -> Void in
                    if let timerTemp = timer{
                        timerTemp.invalidate()
                    }else{  //没有实时高斯模糊的情况
                        self.gaussianBlurImage()
                    }
            })
        }
    }
    
    func dissmissPresentView(){
        self.dissmissPresentView(true, completion: nil)
    }
    
    func dissmissPresentView(animation: Bool, completion: (() -> Void)? ){
        bShowView = false
        if (animation){
            var timer: NSTimer?
            if (realTimeBlur){
                timer = NSTimer.scheduledTimerWithTimeInterval(intervalTime, target: self, selector: "gaussianBlurImageWithAnimation", userInfo: nil, repeats: true)
            }
            UIView.animateWithDuration(animateDuration, animations: { () -> Void in
                self.popupPosition()
                }, completion: { (Bool) -> Void in
                    if let timerTemp = timer{
                        timerTemp.invalidate()
                    }else{  //没有实时高斯模糊的情况
                        self.gaussianBlurImage()
                    }
                    self.dismissViewControllerAnimated(false, completion: { () -> Void in
                        if let tempCompletion = completion{
                            tempCompletion()
                        }
                        if let tempCompletion = self.completion{
                            tempCompletion()
                        }
                    })
            })
        }else{
            self.gaussianBlurImage()
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
    
    // 通过动画做高斯模糊函数
    func gaussianBlurImageWithAnimation(){
        if (bShowView){
            currentBlur += blur*(intervalTime/animateDuration)
        }else{
            currentBlur -= blur*(intervalTime/animateDuration)
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            weak var tempSelf = self
            let gaussianImage = MSManageImage.gaussianBlurOnImage(tempSelf!.convertImage, blur: tempSelf!.currentBlur)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                tempSelf?.animationImageView.image = gaussianImage
            })
        }
    }
    
    // 没有动画做高斯模糊函数
    func gaussianBlurImage() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            weak var tempSelf = self
            let gaussianImage = MSManageImage.gaussianBlurOnImage(tempSelf!.convertImage, blur: tempSelf!.bShowView ? tempSelf!.blur : 0)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                tempSelf?.animationImageView.image = gaussianImage
            })
        }
    }
    
    //MARK: 初始化presentView 的位置 及初始值
    private func popupPosition(){
        animationImageView.frame = beginRect
        var rect = presentView.frame
        switch(self.popupStyle){
        case .Top:
            rect.origin.x = 0
            rect.origin.y = -(rect.size.height)
            presentView.frame = rect
            break
        case.Bottom:
            rect.origin.x = 0
            rect.origin.y = screenBounds.height
            presentView.frame = rect
            break
        case.Left:
            rect.origin.x = -(rect.size.width)
            rect.origin.y = 0
            presentView.frame = rect
            break
        case.Right:
            rect.origin.x = screenBounds.width
            rect.origin.y = 0
            presentView.frame = rect
            break
        case.Grow:
            break
        case.Shrink:
            break
        case.None:
            break
        }
    }
    
    //MARK: presentView 动画的方式弹出到特定位置 及最终值
    private func animatePopupWithStyle() {
        animationImageView.frame = endRect
        var rect = presentView.frame
        switch(self.popupStyle){
        case .Top:
            rect.origin.y = 0
            self.presentView.frame = rect
            break
        case.Bottom:
            rect.origin.y = screenBounds.height-(rect.size.height)
            self.presentView.frame = rect
            break
        case.Left:
            rect.origin.x = 0
            self.presentView.frame = rect
            break
        case.Right:
            rect.origin.x = screenBounds.width-(rect.size.width)
            self.presentView.frame = rect
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
