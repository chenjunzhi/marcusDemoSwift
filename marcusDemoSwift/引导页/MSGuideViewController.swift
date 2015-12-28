//
//  MSGuideViewController.swift
//  marcusDemoSwift
//
//  Created by marcus on 15/12/23.
//  Copyright © 2015年 marcus. All rights reserved.
//

import UIKit

class MSGuideViewController: MSViewController,UIScrollViewDelegate {
  
  private var imageArray: [String] = []
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var constraintPageControlBottom: NSLayoutConstraint!
  @IBOutlet weak var constraintContentWidth: NSLayoutConstraint!
  @IBOutlet weak var contentView: UIView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let screenWidth = MSApplication.sharedApplication().screenWidth
    let screenHeight = MSApplication.sharedApplication().screenHeight
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.showsVerticalScrollIndicator = false
    scrollView.contentSize = CGSize.init(width: screenWidth*3, height: screenHeight)
    scrollView.delegate = self
    imageArray = ["guide1","guide2","guide3"]
    constraintContentWidth.constant = imageArray.count*screenWidth
    for (var i = 0; i < 3; i++){
      let imageView = UIImageView(image: UIImage(named: imageArray[i]))
      imageView.frame = CGRect.init(i*screenWidth, 0, screenWidth, screenHeight)
      imageView.userInteractionEnabled = true
      contentView.addSubview(imageView)
      if (i == 2){
        let button = UIButton(frame: CGRect.init(screenWidth/2-50, screenHeight-90, 100, 35))
        button.setBackgroundImage(UIImage(named: "togetter"), forState: UIControlState.Normal)
        button.center = CGPoint.init(x: screenWidth/2, y: view.bottom - screenHeight/3.0)
        imageView.addSubview(button)
        button.addTarget(self, action: "beginButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
      }
    }
    pageControl.numberOfPages = imageArray.count
    pageControl.currentPage = 0
    pageControl.addTarget(self, action: "pageChange:", forControlEvents: UIControlEvents.ValueChanged)
    pageControl.currentPageIndicatorTintColor = UIColor.init(colorCode: 0xDF3448)
    pageControl.pageIndicatorTintColor = UIColor.init(colorCode: 0x999999)
    view.bringSubviewToFront(pageControl)
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  func beginButtonClick(sender:UIButton){
    let studySampleVC = MSStudySampleVC()
    self.presentViewController(studySampleVC, animated: false, completion: nil)
  }
  
  func pageChange(sender:UIPageControl){
    scrollView.contentOffset.x = sender.currentPage * MSApplication.sharedApplication().screenWidth
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
//  MARK: UIScrollViewDelegate
  func scrollViewDidScroll(scrollView: UIScrollView) {
    let page = scrollView.contentOffset.x / MSApplication.sharedApplication().screenWidth
    pageControl.currentPage = Int(page)
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
