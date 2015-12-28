//
//  ViewController.swift
//  marcusDemoSwift
//
//  Created by marcus on 15/11/23.
//  Copyright © 2015年 marcus. All rights reserved.
//

import UIKit

class ViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let homeVC = MSStudySampleVC()
        let navIndex = UINavigationController(rootViewController: homeVC)
        navIndex.title = "首页"
        navIndex.tabBarItem.image = UIImage(named: "tabVCUnSelectHome")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        navIndex.tabBarItem.selectedImage = UIImage(named: "tabVCSelectHome")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        self.viewControllers = [navIndex];
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        //.自定义工具栏
        self.tabBar.backgroundColor=UIColor.clearColor()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

