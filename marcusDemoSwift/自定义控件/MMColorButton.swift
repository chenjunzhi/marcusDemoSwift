//
//  MMColorButton.swift
//  Mikoto
//
//  Created by 丁帅 on 15/4/7.
//  Copyright (c) 2015年 m_mikoto. All rights reserved.
//
//****************************************************************************************
//  Custom color Button with real time xib
//  LAST UPDATE 2015-7-28：add solid line border or cut line border
//****************************************************************************************
//

import UIKit


public struct MMColorButtonEdgeCorner : OptionSetType {
    private let _rawValue : UInt
    public init(rawValue: UInt) { _rawValue = rawValue }
    public var rawValue: UInt { get { return _rawValue} }
    
    public static var TopLeft: MMColorButtonEdgeCorner { get { return self.init(rawValue: 1 << 0) } }
    public static var TopRight: MMColorButtonEdgeCorner { get { return self.init(rawValue: 1 << 1) } }
    public static var BottomLeft: MMColorButtonEdgeCorner { get { return self.init(rawValue: 1 << 2) } }
    public static var BottomRight: MMColorButtonEdgeCorner { get { return self.init(rawValue: 1 << 3) } }
    public static var AllCorners: MMColorButtonEdgeCorner { get { return self.init(rawValue: 0xF) } }
}

@IBDesignable class MMColorButton: UIButton {
    /// nomal background color
    @IBInspectable var normalColor : UIColor = UIColor.clearColor() {
        didSet{
            self.setNeedsDisplay()
        }
    }
    /// highlight background color
    @IBInspectable var highlightColor :  UIColor? {
        didSet{
            self.setNeedsDisplay()
        }
    }
    /// disabled backgroud color
    @IBInspectable var disableColor : UIColor? {
        didSet{
            self.setNeedsDisplay()
        }
    }
    /// selected backgroud color
    @IBInspectable var selectedColor : UIColor? {
        didSet{
            self.setNeedsDisplay()
        }
    }
    /// show solid line border or cut line border
    @IBInspectable var showCutLine : Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    /// solid line border color
    @IBInspectable var borderColor : UIColor = UIColor(colorCode: 0x999999) {
        didSet {
            self.setNeedsDisplay()
        }
    }
    ///  highlight solid line border color
    @IBInspectable var highlightBorderColor : UIColor? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    /// disable solid line border color
    @IBInspectable var disableBorderColor : UIColor? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    /// selected solid line border color
    @IBInspectable var selectedBorderColor : UIColor? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    /// cut line border color, use borderColor if cutLineBorderColor is nil
    @IBInspectable var cutLineColor : UIColor? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    /// highlti cut line border color
    @IBInspectable var highlightCutLineColor : UIColor? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    /// disbale cut line border color
    @IBInspectable var disableCutLineColor : UIColor? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    /// selected cut line border color
    @IBInspectable var selectedCutLineColor : UIColor? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    /// border line width
    @IBInspectable var borderWidth : CGFloat = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    /// cut line solid part length
    @IBInspectable var lineSolidLength : CGFloat = 3 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    /// cut line cut part length
    @IBInspectable var lineCutLength : CGFloat = 2 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    /// The radius to use when drawing rounded corners for the layer’s background. Animatable.
    @IBInspectable var radius : CGFloat = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    /// The mask value that identifies the corners that you want rounded. You can use this parameter to round only a subset of the corners of the rectangle. Default is ALLCorners
    var edgeCornerType : MMColorButtonEdgeCorner = .AllCorners {
        didSet {
            self.setNeedsDisplay()
        }
    }
    /**
     API for OC to set edgeCornerType, because of OC cant use swift OptionSetType
     
     - parameter type: Type of MMColorButtonEdgeCorner, use MMColorButtonEdgeMaskForOC enum in OC
     */
    func setEdgeCornerTypeForOC(type: UInt) {
        edgeCornerType = MMColorButtonEdgeCorner(rawValue: type)
    }
    
    // MARK: - override handle
    override var highlighted : Bool {
        willSet{
            if highlighted != newValue {
                self.setNeedsDisplay()
            }
        }
    }
    
    override var selected : Bool {
        willSet{
            if selected != newValue {
                self.setNeedsDisplay()
            }
        }
    }
    
    override var enabled : Bool {
        willSet{
            if enabled != newValue {
                self.setNeedsDisplay()
            }
        }
    }
    
    override var backgroundColor : UIColor? {
        didSet {
            super.backgroundColor = nil
        }
    }
    
    override func setBackgroundImage(image: UIImage?, forState state: UIControlState) {
        super.setBackgroundImage(nil, forState: state)
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        // set fill color and stroke color depends on state of button
        let strokeColor : UIColor
        let fillColor : UIColor
        if self.state.contains(.Disabled) {
            // show cutline disable color when showCutline setted ture. if disableCutLineColor is nil, cutLineColor instead. Or use borderColor instead while nil
            strokeColor = showCutLine ? (disableCutLineColor ?? (cutLineColor ?? borderColor)) : (disableBorderColor ?? borderColor)
            fillColor = disableColor ?? normalColor
        } else if self.state.contains(.Highlighted) {
            // show cutline highlight color when showCutline setted ture. if highlightCutLineColor is nil, cutLineColor instead. Or use borderColor instead while nil
            strokeColor = showCutLine ? (highlightCutLineColor ?? (cutLineColor ?? borderColor)) : (highlightBorderColor ?? borderColor)
            fillColor = highlightColor ?? normalColor
        } else if self.state.contains(.Selected) {
            // show cutline selected color when showCutline setted ture. if selectedCutLineColor is nil, cutLineColor instead. Or use borderColor instead while nil
            strokeColor = showCutLine ? (selectedCutLineColor ?? (cutLineColor ?? borderColor)) : (selectedBorderColor ?? borderColor)
            fillColor = selectedColor ?? normalColor
        } else {
            strokeColor = showCutLine ? (cutLineColor ?? borderColor) : borderColor
            fillColor = normalColor
        }
        
        CGContextSetStrokeColorWithColor(context, strokeColor.CGColor)
        CGContextSetFillColorWithColor(context, fillColor.CGColor)
        CGContextSetLineWidth(context, borderWidth)
        if showCutLine {
            CGContextSetLineDash(context, 0, [lineSolidLength, lineCutLength], 2)
        }
        
        let fixInsetMargin = borderWidth / 2.0 + ((borderWidth / 2.0) % 0.5)
        let fixTangentPoint = radius + fixInsetMargin
        func fixRadius(type : MMColorButtonEdgeCorner) -> CGFloat {
            return edgeCornerType.contains(type) ? fixTangentPoint : fixInsetMargin
        }
        
        CGContextMoveToPoint(context, fixInsetMargin, fixRadius(.TopLeft))
        if edgeCornerType.contains(.TopLeft) { CGContextAddArcToPoint(context, fixInsetMargin, fixInsetMargin, fixTangentPoint, fixInsetMargin, radius) }
        CGContextAddLineToPoint(context, self.width-fixRadius(.TopRight), fixInsetMargin)
        if edgeCornerType.contains(.TopRight) { CGContextAddArcToPoint(context, self.width-fixInsetMargin, fixInsetMargin, self.width-fixInsetMargin, fixTangentPoint, radius) }
        CGContextAddLineToPoint(context, self.width-fixInsetMargin, self.height-fixRadius(.BottomRight))
        if edgeCornerType.contains(.BottomRight) { CGContextAddArcToPoint(context, self.width-fixInsetMargin, self.height-fixInsetMargin, self.width-fixTangentPoint, self.height-fixInsetMargin, radius) }
        CGContextAddLineToPoint(context, fixRadius(.BottomLeft), self.height-fixInsetMargin)
        if edgeCornerType.contains(.BottomLeft) { CGContextAddArcToPoint(context, fixInsetMargin, self.height-fixInsetMargin, fixInsetMargin, self.height-fixTangentPoint, radius) }
        CGContextAddLineToPoint(context, fixInsetMargin, fixRadius(.TopLeft))
        CGContextDrawPath(context, .FillStroke);
    }
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForInterfaceBuilder() {
    }
    
    convenience init(normalColor nor: UIColor, highlightColor high: UIColor?) {
        self.init(frame:CGRect.zero)
        self.normalColor = nor
        self.highlightColor = high
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    //    MARK: - shark animation
    func shark(shark: Bool) {
        if shark {
            animatable = true
            animateStepIndex = 0
            sharkAnimate()
        } else {
            animatable = false
        }
    }
    
    private var animatable = false
    private let animateStepRadius : [CGFloat] =  [0.03, -0.024, 0.015, -0.02]
    private let animateStepDuring : [NSTimeInterval] = [0.05, 0.03, 0.04, 0.045]
    private var animateStepIndex = 0 {
        didSet {
            animateStepIndex = animateStepIndex > 3 ? 0 : animateStepIndex
        }
    }
    
    private func sharkAnimate() {
        if animatable {
            let trans =  CATransform3DMakeRotation(animateStepRadius[animateStepIndex], 0, 0, 1)
            let basicAnimation = CABasicAnimation(keyPath: "transform")
            basicAnimation.duration = animateStepDuring[animateStepIndex]
            basicAnimation.toValue = NSValue(CATransform3D: trans)
            basicAnimation.delegate = self
            self.layer.addAnimation(basicAnimation, forKey: nil)
        }
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if let transform = anim as? CABasicAnimation where transform.keyPath == "transform" {
            animateStepIndex++
            self.sharkAnimate()
        }
    }
}
