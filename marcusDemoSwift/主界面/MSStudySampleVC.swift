//
//  MSStudySampleVC.swift
//  marcusDemoSwift
//
//  Created by marcus on 15/12/18.
//  Copyright © 2015年 marcus. All rights reserved.
//

import UIKit

class MSStudySampleVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
  var sampleArrayData = ["景深效果测试上","景深效果测试下","景深效果测试左","景深效果测试右","测试GPUImage测试GPUImage测试GPUImage测试GPUImage测试GPUImage测试GPUImage"]
  
  @IBOutlet weak var mainTableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    mainTableView.dataSource = self
    mainTableView.delegate = self
    mainTableView.reloadData()
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  //    MARK: tableView Delegate
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sampleArrayData.count
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 60.0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cellID:String = "cell"
    let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellID)
    cell.textLabel?.text = sampleArrayData[indexPath.row]
    cell.selectionStyle = .None
    return cell
  }
  
  func buttonClick(){
    MSDepthViewController.dissmissWithAnimation(true) { () -> Void in
      print("关闭按钮释放")
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let tempView = UIView.init()
    let button = UIButton.init(frame: CGRectMake(0, 0, 100, 60))
    button.backgroundColor = UIColor.whiteColor()
    button.addTarget(self, action: "buttonClick", forControlEvents: .TouchUpInside)
    button.setTitle("关闭弹出框", forState: .Normal)
    button.setTitleColor(UIColor.blackColor(), forState: .Normal)
    tempView.backgroundColor = UIColor.redColor()
    tempView.addSubview(button)
    switch(indexPath.row){
    case 0:
      tempView.frame = CGRectMake(0, 0, MSApplication.sharedApplication().screenWidth, MSApplication.sharedApplication().screenHeight/2)
      MSDepthViewController.presentDepthView(tempView, backgroundColor: nil, animateDuration: 0.3, popupStyle: DepthPopupStyle.Top, blur: 0.1, depthSacle: 0.9)
      break
    case 1:
      tempView.frame = CGRectMake(0, 0, MSApplication.sharedApplication().screenWidth, MSApplication.sharedApplication().screenHeight/2)
      MSDepthViewController.presentDepthView(tempView, backgroundColor: nil, animateDuration: 0.3, popupStyle: DepthPopupStyle.Bottom, blur: 0.2, depthSacle: 0.9)
      break
    case 2:
      tempView.frame = CGRectMake(0, 0, MSApplication.sharedApplication().screenWidth/2, MSApplication.sharedApplication().screenHeight)
      MSDepthViewController.presentDepthView(tempView, backgroundColor: nil, animateDuration: 0.3, popupStyle: DepthPopupStyle.Left, blur: 0.4, depthSacle: 0.9)
      break
    case 3:
      tempView.frame = CGRectMake(0, 0, MSApplication.sharedApplication().screenWidth/2, MSApplication.sharedApplication().screenHeight)
      MSDepthViewController.presentDepthView(tempView, backgroundColor: UIColor.whiteColor(), animateDuration: 0.3, popupStyle: DepthPopupStyle.Right, blur:0.6, depthSacle: 0.9)
      break
    case 4:
      let gpuVC = MSGPUViewController.init()
      self.presentViewController(gpuVC, animated: true, completion: nil)
      break
    default:
      break
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
