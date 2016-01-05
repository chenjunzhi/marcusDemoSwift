//
//  MSGPUViewController.swift
//  marcusDemoSwift
//
//  Created by marcus on 16/1/5.
//  Copyright © 2016年 marcus. All rights reserved.
//

import UIKit

class MSGPUViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  var beginRect = CGRectZero
  var endRect = CGRectZero
  var scale = 0.9
  var animationImageView = UIImageView.init()
  var bChange = false
  var currentBlur = 0.0
  var imageEnd = UIImage.init()
  @IBOutlet weak var button: UIButton!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    imageEnd = MSManageImage.convertViewImage(self.view, frame: CGSize(MSApplication.sharedApplication().screenWidth,MSApplication.sharedApplication().screenHeight))
    imageEnd = MSManageImage.specialScaleImage(imageEnd, scale: CGFloat(scale), background: UIColor.blackColor())
    beginRect = CGRect.init(-(imageView.width*((1-scale)/scale)*0.5), -(imageView.height*((1-scale)/scale)*0.5), imageView.width/scale, imageView.height/scale)
    endRect = CGRect.init(0, 0, imageView.width, imageView.height)
    animationImageView.contentMode = .ScaleAspectFit
    animationImageView.backgroundColor = UIColor.blackColor()
    animationImageView.frame = beginRect
    animationImageView.image = imageEnd
    self.view.addSubview(animationImageView)
    
    self.view.bringSubviewToFront(button)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
  
  
  func gaussianBlurImage(){
    if (!bChange){
      currentBlur += 0.5
    }else{
      currentBlur -= 0.5
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
      weak var tempSelf = self
      print("\(tempSelf?.currentBlur)")
      let gaussianImage = MSManageImage.gaussianBlurOnImage(tempSelf!.imageEnd, blur: tempSelf!.currentBlur)
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        tempSelf?.animationImageView.image = gaussianImage
      })
    }
  }
  
  
  @IBAction func click(sender: UIButton) {
    let timer = NSTimer.scheduledTimerWithTimeInterval(0.08, target: self, selector: "gaussianBlurImage", userInfo: nil, repeats: true)
    
    if (!bChange){
      UIView.animateWithDuration(0.5, animations: { () -> Void in
        self.animationImageView.frame = self.endRect
        }, completion: { (Bool) -> Void in
          timer.invalidate()
          self.bChange = !self.bChange
      })
      
    }else{
      UIView.animateWithDuration(0.5, animations: { () -> Void in
        self.animationImageView.frame = self.beginRect
        }, completion: { (Bool) -> Void in
          timer.invalidate()
          self.bChange = !self.bChange
      })
      
    }
  }
}
