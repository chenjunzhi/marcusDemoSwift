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
  var gpuImageView = GPUImageView.init()
  var beginRect = CGRectZero
  var endRect = CGRectZero
  var scale = 0.9
  var animationImageView = UIImageView.init()
  var bChange = false
  @IBOutlet weak var button: UIButton!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    var imageTemp = MSManageImage.convertViewImage(self.view, frame: CGSize(MSApplication.sharedApplication().screenWidth,MSApplication.sharedApplication().screenHeight))
    imageTemp = MSManageImage.specialScaleImage(imageTemp, scale: CGFloat(scale), background: UIColor.blackColor())
    beginRect = CGRect.init(-(imageView.width*((1-scale)/scale)*0.5), -(imageView.height*((1-scale)/scale)*0.5), imageView.width/scale, imageView.height/scale)
    endRect = CGRect.init(0, 0, imageView.width, imageView.height)
    animationImageView.contentMode = .ScaleAspectFit
    animationImageView.frame = beginRect
    animationImageView.image = imageTemp
    self.view.addSubview(animationImageView)
    self.view.bringSubviewToFront(button)
    
    
//    GPUImageView *backgroundImageView = [[GPUImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    UIImage *image = [UIImage imageNamed:@"photo"]; //The image is not nil
//    GPUImagePicture *imageInput = [[GPUImagePicture alloc] initWithImage:image];
//    
//    [imageInput addTarget:backgroundImageView];
//    [self.view addSubview:backgroundImageView];
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
  
  
  @IBAction func click(sender: UIButton) {
    if (!bChange){
      UIView .animateWithDuration(0.5, animations: { () -> Void in
        self.animationImageView.frame = self.endRect
        }) { (result:Bool) -> Void in
      }
      bChange = !bChange
    }else{
      UIView .animateWithDuration(0.5, animations: { () -> Void in
        self.animationImageView.frame = self.beginRect
        }) { (result:Bool) -> Void in
      }
      bChange = !bChange
    }

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
