//
//  THSelectBoard.swift
//  Tuhu
//
//  Created by 丁帅 on 15/9/8.
//  Copyright (c) 2015年 telenav. All rights reserved.
//

import UIKit

class THSelectBoard: UIView {
    
    var buttonTitles : [String]? {
        didSet {
            if let titles = buttonTitles {
                cleanButtons()
                var lastButton : UIButton?
                var lastLineButton : UIButton?
                
                let lineNumber = Int((UIScreen.mainScreen().bounds.width - 12 + 8) / (8 + 30))
                let fixMargin = (UIScreen.mainScreen().bounds.width - 12 - lineNumber*30) / (lineNumber - 1)
                numberOfLines = Int(ceil(Float(titles.count)/lineNumber))
                
                for (idx, title) in titles.enumerate() {
                    let button = MMColorButton()
                    button.radius = 5
                    button.translatesAutoresizingMaskIntoConstraints = false
                    button.clipsToBounds = false
                    button.layer.shadowOffset = CGSize(0, 1)
                    button.layer.shadowRadius = 0
                    button.layer.shadowColor = UIColor(colorCode: 0x666666).CGColor
                    button.layer.shadowOpacity = 0.5
                    button.layer.shadowPath = UIBezierPath(roundedRect: CGRect(0, 30.5, 30, 7 ), cornerRadius: 3).CGPath
                    if let selected = selectedTitle {
                        button.normalColor = selected == title ? UIColor(colorCode: 0xdf3448) : UIColor(colorCode: 0xffffff)
                        button.setTitleColor(selected == title ? UIColor(colorCode: 0xffffff) : UIColor(colorCode: 0x222222), forState: .Normal)
                    } else {
                        button.normalColor = UIColor(colorCode: 0xffffff)
                        button.setTitleColor(UIColor(colorCode: 0x222222), forState: .Normal)
                    }
                    button.highlightColor = UIColor(colorCode: 0xdf3448)
                    button.setTitleColor(UIColor(colorCode: 0xffffff), forState: .Highlighted)
                    
                    button.titleLabel?.font = UIFont(name: "STHeitiSC", size: 16)
                    button.setTitle(title, forState: .Normal)
                    button.addTarget(self, action: "handleButton:", forControlEvents: .TouchUpInside)
                    self.addSubview(button)
                    buttons.append(button)
                    
                    let lineFirst = idx%lineNumber == 0
                    let firstLine = idx/lineNumber == 0
                    let lineLast = idx%lineNumber == lineNumber - 1
                    let LastButton = idx == titles.count - 1
                    
                    buttonConstraints.append(NSLayoutConstraint(item: button, attribute: .Leading, relatedBy: .Equal, toItem: lineFirst ? self : lastButton, attribute: lineFirst ? .Leading : .Trailing, multiplier: 1, constant: lineFirst ? 6 : fixMargin))
                    buttonConstraints.append(NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: firstLine ? self : lastLineButton, attribute: firstLine ? .Top : .Bottom, multiplier: 1, constant: firstLine ? 8 : 12))
                    buttonConstraints.append(NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem:nil, attribute: .NotAnAttribute, multiplier: 1, constant: 37))
                    buttonConstraints.append(NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem:nil, attribute: .NotAnAttribute, multiplier: 1, constant: 30))
                    if lineLast {
                        buttonConstraints.append(NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal, toItem: button, attribute:.Trailing, multiplier: 1, constant:6))
                        lastLineButton = button
                    }
                    if LastButton {
                        buttonConstraints.append(NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: button, attribute:.Bottom, multiplier: 1, constant:8))
                    }
                    lastButton = button
                }
                self.addConstraints(buttonConstraints)
            }
        }
    }
    
    var selectedBlock : ((title : String) -> ())?
    
    var boardHeight : CGFloat {
        get {
            return numberOfLines*CGFloat(37+12) - 12 + 16
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        privateInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        privateInit()
    }
    
    dynamic internal override func prepareForInterfaceBuilder() {
    }
    
    private var buttons : [UIButton] = []
    private var buttonConstraints : [NSLayoutConstraint] = []
    
    private var numberOfLines : Int = 0
    
    private func privateInit() {
        self.backgroundColor = UIColor(colorCode: 0xd4d4d4)
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .Width, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: UIScreen.mainScreen().bounds.width))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .Height, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 16))
    }
    
    private func cleanButtons() {
        for button in buttons {
            button.removeFromSuperview()
        }
        self.removeConstraints(buttonConstraints)
        buttons.removeAll(keepCapacity: false)
        buttonConstraints.removeAll(keepCapacity: false)
    }
    
    dynamic private func handleButton(sender : UIButton) {
        if let block = selectedBlock {
            block(title: sender.titleForState(.Normal)!)
        }
    }
    
// MARK: - 封装类方法弹出选字板
    private var selectedTitle : String?
    private var selfTop : NSLayoutConstraint?
    private var selfConstraints : [NSLayoutConstraint]?
    dynamic private func handleHidden(sender : UITapGestureRecognizer) {
        selfTop?.constant = 0
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions(), animations: {
            UIApplication.sharedApplication().keyWindow?.layoutIfNeeded()
            }, completion: { finish in
                UIApplication.sharedApplication().keyWindow?.removeConstraints(self.selfConstraints!)
                self.removeFromSuperview()
                sender.view?.removeFromSuperview()
        })
    }
    
    /**
     类方法，直接在window层弹出选字板，选择一个选项或者点击蒙版背景时返回
     
    :param: titles 选项数组，数组中为字符串
    :param: selecedTitle 已选中的 文字
    :param: callBackBlock 选择一个选项时的回调
    */
    class func showBoard(titles : [String], selecedTitle: String?, callBackBlock block: ((title : String) -> ())?) {
        
        guard let window = UIApplication.sharedApplication().keyWindow else {
            return
        }
        
        let board = self.init()
        board.translatesAutoresizingMaskIntoConstraints = false
        let bgMask = UIView(frame: UIScreen.mainScreen().bounds)
        bgMask.backgroundColor = UIColor(colorCode: 0x0, alpha: 0.7)
        bgMask.addGestureRecognizer(UITapGestureRecognizer(target: board, action: "handleHidden:"))
        
        window.addSubview(bgMask)
        window.addSubview(board)
        
        var constraints : [NSLayoutConstraint] = []
        constraints.append(NSLayoutConstraint(item: board, attribute: .CenterX, relatedBy: .Equal, toItem: window, attribute: .CenterX, multiplier: 1, constant: 0))
        let top = NSLayoutConstraint(item: board, attribute: .Top, relatedBy: .Equal, toItem: window, attribute: .Bottom, multiplier: 1, constant: 0)
        constraints.append(top)
        window.addConstraints(constraints)
        
        board.selfTop = top
        board.selfConstraints = constraints
        board.selectedTitle = selecedTitle
        board.buttonTitles = titles
        board.selectedBlock = { title in
            top.constant = 0
            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions(), animations: {
                window.layoutIfNeeded()
                }, completion: { finish in
                    window.removeConstraints(constraints)
                    board.removeFromSuperview()
                    bgMask.removeFromSuperview()
                    if let wrap = block {
                        wrap(title: title)
                    }
            })
        }
        window.layoutIfNeeded()
        
        top.constant = -board.boardHeight
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: UIViewAnimationOptions(), animations: {
            window.layoutIfNeeded()
            }, completion: nil)
    }
}
