//
//  MMCubeBannerView.swift
//  MMLibTest
//
//  Created by 丁帅 on 15/8/6.
//  Copyright (c) 2015年 丁帅. All rights reserved.
//

import UIKit

@IBDesignable class MMCubeBannerView: UIView, UIGestureRecognizerDelegate {
    
    /// Use auto layout or not, set true if use auto layout for MMCycelScrollView
    @IBInspectable var isUseLayoutConstraints : Bool = false {
        didSet {
            if isUseLayoutConstraints != oldValue {
                if isUseLayoutConstraints {
                    contentView.translatesAutoresizingMaskIntoConstraints = false
                    controlView.translatesAutoresizingMaskIntoConstraints = false
                    self.addConstraints(selfConstraints)
                } else {
                    contentView.translatesAutoresizingMaskIntoConstraints = true
                    controlView.translatesAutoresizingMaskIntoConstraints = true
                    self.removeConstraints(selfConstraints)
                }
            }
        }
    }
    /// Auto scroll images when MMCycelScrollView be added to superview
    @IBInspectable var autoScroll : Bool = false {
        didSet {
            if autoScroll {
                if !autoRunTimer.valid {
                    autoRunTimer = NSTimer.scheduledTimerWithTimeInterval(autoScrollInterval, target: self, selector: "handleTimer", userInfo: nil, repeats: true)
                }
            } else {
                autoRunTimer.invalidate()
            }
        }
    }
    /// Auto scroll timeInterval,  TimeInterval between scroll a page and next
    @IBInspectable var autoScrollInterval : NSTimeInterval = 2
    /// PageContoler normal color
    @IBInspectable var pageControlColor : UIColor = UIColor(colorCode: 0xCCCCCC) {
        didSet {
            controlView.pageIndicatorTintColor = pageControlColor
        }
    }
    /// PageContoler selected color
    @IBInspectable var pageControlTintColor : UIColor = UIColor.whiteColor() {
        didSet {
            controlView.currentPageIndicatorTintColor = pageControlTintColor
        }
    }
    /// how many page of MMCycelScrollView
    var pageNumbers : NSInteger = 0 {
        didSet {
            controlView.numberOfPages = pageNumbers
        }
    }
    /// current page for view
    var currentPage : NSInteger = 0 {
        didSet {
            if currentPage != oldValue {
                let isAdd = currentPage > oldValue
                if currentPage >= pageNumbers {
                    currentPage = 0
                } else if currentPage < 0 {
                    currentPage = max(pageNumbers-1, 0)
                }
                currentViews[oldValue].hidden = true
                currentViews[currentPage].hidden = false
                switchPage(isAdd)
            }
        }
    }
    /// data source block for page view of each page
    var viewOfPageBlock : ((index : NSInteger) -> UIView)? {
        didSet {
            if viewOfPageBlock != nil {
                reloadViews()
            }
        }
    }
    /// call back block for did click a page
    var pageClickCallBackBlock : ((index : NSInteger) -> ())?
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.privateInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.privateInit()
    }
    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    dynamic internal override func prepareForInterfaceBuilder() {
        self.backgroundColor = UIColor.clearColor()
    }
    
    deinit {
        if autoRunTimer.valid {
            autoRunTimer.invalidate()
        }
    }
    override var frame : CGRect {
        didSet {
            contentView.frame = CGRect(origin: CGPointZero, size: frame.size)
            controlView.frame = CGRect(0, frame.height - 30, frame.width, 30)
            for index in 0..<currentViews.count {
                let view = currentViews[index]
                view.frame = CGRect(index*frame.width, 0, frame.width, frame.height)
            }
        }
    }
    
    // MARK: - private
    private let contentView = UIView()
    private let controlView = UIPageControl()
    private var selfConstraints : [NSLayoutConstraint] = []
    
    private var currentViews : [UIView] = []
    private var cViewConstraints : [NSLayoutConstraint] = []
    
    private var autoRunTimer = NSTimer()
    
    private var turning = false
    
    private func privateInit() {
        initViews()
        initFrames()
        initConstraints()
        initGestureRecognizers()
    }
    
    private func initViews() {
        contentView.backgroundColor = UIColor.clearColor()
        self.addSubview(contentView)
        
        controlView.pageIndicatorTintColor = pageControlColor
        controlView.currentPageIndicatorTintColor = pageControlTintColor
        controlView.userInteractionEnabled = false
        self.addSubview(controlView)
    }
    
    private func initFrames() {
        contentView.frame = self.bounds
        controlView.frame = CGRect(0, self.height - 30, self.width, 30)
    }
    
    private func initConstraints() {
        let H_content = NSLayoutConstraint.constraintsWithVisualFormat("H:|[content]|", options: NSLayoutFormatOptions.DirectionMask, metrics: nil, views: ["content": contentView])
        let V_content = NSLayoutConstraint.constraintsWithVisualFormat("V:|[content]|", options: NSLayoutFormatOptions.DirectionMask, metrics: nil, views: ["content": contentView])
        let H_control = NSLayoutConstraint.constraintsWithVisualFormat("H:|[control]|", options: NSLayoutFormatOptions.DirectionMask, metrics: nil, views: ["control": controlView])
        let V_control = NSLayoutConstraint.constraintsWithVisualFormat("V:[control(30)]|", options: NSLayoutFormatOptions.DirectionMask, metrics: nil, views: ["control": controlView])
        selfConstraints += H_content + V_content + H_control + V_control
    }
    
    private func initGestureRecognizers() {
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleClick"))
        let left = UISwipeGestureRecognizer(target: self, action: "handleSwip:")
        left.direction = .Left
        left.delegate = self
        contentView.addGestureRecognizer(left)
        let right = UISwipeGestureRecognizer(target: self, action: "handleSwip:")
        right.direction = .Right
        right.delegate = self
        contentView.addGestureRecognizer(right)
    }
    
    dynamic internal override func willMoveToSuperview(newSuperview: UIView?) {
        if let _ = newSuperview where autoScroll && !autoRunTimer.valid {
            autoRunTimer = NSTimer.scheduledTimerWithTimeInterval(autoScrollInterval, target: self, selector: "handleTimer", userInfo: nil, repeats: true)
        }
    }
    
    private func validIndexFromIndex(index: NSInteger) -> NSInteger {
        if index >= pageNumbers {
            return 0
        } else if index < 0 {
            return max(pageNumbers-1, 0)
        } else {
            return index
        }
    }
    
    dynamic private func handleClick() {
        if let block = pageClickCallBackBlock {
            block(index: currentPage)
        }
    }
    
    dynamic private func handleSwip(sender: UISwipeGestureRecognizer) {
        if !turning {
            switch sender.direction {
            case UISwipeGestureRecognizerDirection.Left :
                currentPage++
            case UISwipeGestureRecognizerDirection.Right :
                currentPage--
            default :
                break
            }
            
        }
    }
        
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    dynamic private func handleTimer() {
        currentPage++
    }
    
    private func switchPage(indexAdd: Bool) {
        turning = true
        let transform = CATransition()
        transform.delegate = self
        transform.duration = 0.8
        transform.type = "cube"
        transform.subtype =  indexAdd ? kCATransitionFromRight : kCATransitionFromLeft
        
        let target = currentViews[currentPage]
        contentView.bringSubviewToFront(target)
        contentView.layer.addAnimation(transform, forKey: "cube")
        controlView.currentPage = currentPage
    }
    
    private func reloadViews() {
        if pageNumbers <= 0 {
            controlView.currentPage = 0
            return
        }
        
        controlView.currentPage = currentPage
        
        self.removeConstraints(cViewConstraints)
        for view in currentViews {
            view.removeFromSuperview()
        }
        cViewConstraints.removeAll(keepCapacity: true)
        currentViews.removeAll(keepCapacity: true)
        
        if let block = viewOfPageBlock {
            for index in 0..<pageNumbers {
                let view = block(index: index)
                view.frame = CGRect(0, 0, self.width, self.height)
                view.hidden = (index > 0)
                currentViews.append(view)
                contentView.addSubview(view)
                
                if isUseLayoutConstraints {
                    view.translatesAutoresizingMaskIntoConstraints = false
                    let H = NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: NSLayoutFormatOptions.DirectionMask, metrics: nil, views: ["view": view])
                    let V = NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: NSLayoutFormatOptions.DirectionMask, metrics: nil, views: ["view": view])
                    cViewConstraints += H + V
                    contentView.addConstraints(H + V)
                }
            }
        }
    }
    
    //  MARK: - CAAnimation Delegate
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        turning = false
    }
    
    // MARK: - Publick Methods
    /**
    reload data and reset view for MMCycelScrollView
    */
    func reloadData() {
        currentPage = 0
        reloadViews()
    }
    /**
    begain to scroll MMCycelScrollView
    */
    func scrollRun() {
        if !autoRunTimer.valid {
            autoRunTimer = NSTimer.scheduledTimerWithTimeInterval(autoScrollInterval, target: self, selector: "handleTimer", userInfo: nil, repeats: true)
        }
    }
    /**
    end scroll
    */
    func scrollInvalidate() {
        autoRunTimer.invalidate()
    }
}
