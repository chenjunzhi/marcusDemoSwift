//
//  MMUtils.swift
//  Mikoto_Swift
//
//  Created by M_Mikoto on 14/10/31.
//  Copyright (c) 2014年 m_mikoto. All rights reserved.
//
//****************************************************************************************
//  MMSwiftUtils.  Define a new operator, add some methods to system Class.
//****************************************************************************************
//

import Foundation
import UIKit


// MARK: - ** 操作符重载 **

// 自定义操作符 距离
infix operator |-| {
associativity none
precedence 135
}

// 不同类型数值 + - * /
func +(lhs: Int, rhs: Float) -> Float {return Float(lhs) + rhs}
func +(lhs: Int, rhs: Double) -> Double {return Double(lhs) + rhs}
func +(lhs: Int, rhs: CGFloat) -> CGFloat {return CGFloat(lhs) + rhs}
func +(lhs: Float, rhs: Int) -> Float {return lhs + Float(rhs)}
func +(lhs: Float, rhs: Double) -> Double {return Double(lhs) + rhs}
func +(lhs: Float, rhs: CGFloat) -> CGFloat {return CGFloat(lhs) + rhs}
func +(lhs: Double, rhs: Int) -> Double {return lhs + Double(rhs)}
func +(lhs: Double, rhs: Float) -> Double {return lhs + Double(rhs)}
func +(lhs: Double, rhs: CGFloat) -> CGFloat {return CGFloat(lhs) + rhs}
func +(lhs: CGFloat, rhs: Int) -> CGFloat {return lhs + CGFloat(rhs)}
func +(lhs: CGFloat, rhs: Float) -> CGFloat {return lhs + CGFloat(rhs)}
func +(lhs: CGFloat, rhs: Double) -> CGFloat {return lhs + CGFloat(rhs)}

func -(lhs: Int, rhs: Float) -> Float {return Float(lhs) - rhs}
func -(lhs: Int, rhs: Double) -> Double {return Double(lhs) - rhs}
func -(lhs: Int, rhs: CGFloat) -> CGFloat {return CGFloat(lhs) - rhs}
func -(lhs: Float, rhs: Int) -> Float {return lhs - Float(rhs)}
func -(lhs: Float, rhs: Double) -> Double {return Double(lhs) - rhs}
func -(lhs: Float, rhs: CGFloat) -> CGFloat {return CGFloat(lhs) - rhs}
func -(lhs: Double, rhs: Int) -> Double {return lhs - Double(rhs)}
func -(lhs: Double, rhs: Float) -> Double {return lhs - Double(rhs)}
func -(lhs: Double, rhs: CGFloat) -> CGFloat {return CGFloat(lhs) - rhs}
func -(lhs: CGFloat, rhs: Int) -> CGFloat {return lhs - CGFloat(rhs)}
func -(lhs: CGFloat, rhs: Float) -> CGFloat {return lhs - CGFloat(rhs)}
func -(lhs: CGFloat, rhs: Double) -> CGFloat {return lhs - CGFloat(rhs)}

func *(lhs: Int, rhs: Float) -> Float {return Float(lhs) * rhs}
func *(lhs: Int, rhs: Double) -> Double {return Double(lhs) * rhs}
func *(lhs: Int, rhs: CGFloat) -> CGFloat {return CGFloat(lhs) * rhs}
func *(lhs: Float, rhs: Int) -> Float {return lhs * Float(rhs)}
func *(lhs: Float, rhs: Double) -> Double {return Double(lhs) * rhs}
func *(lhs: Float, rhs: CGFloat) -> CGFloat {return CGFloat(lhs) * rhs}
func *(lhs: Double, rhs: Int) -> Double {return lhs * Double(rhs)}
func *(lhs: Double, rhs: Float) -> Double {return lhs * Double(rhs)}
func *(lhs: Double, rhs: CGFloat) -> CGFloat {return CGFloat(lhs) * rhs}
func *(lhs: CGFloat, rhs: Int) -> CGFloat {return lhs * CGFloat(rhs)}
func *(lhs: CGFloat, rhs: Float) -> CGFloat {return lhs * CGFloat(rhs)}
func *(lhs: CGFloat, rhs: Double) -> CGFloat {return lhs * CGFloat(rhs)}

func /(lhs: Int, rhs: Float) -> Float {return Float(lhs) / rhs}
func /(lhs: Int, rhs: Double) -> Double {return Double(lhs) / rhs}
func /(lhs: Int, rhs: CGFloat) -> CGFloat {return CGFloat(lhs) / rhs}
func /(lhs: Float, rhs: Int) -> Float {return lhs / Float(rhs)}
func /(lhs: Float, rhs: Double) -> Double {return Double(lhs) / rhs}
func /(lhs: Float, rhs: CGFloat) -> CGFloat {return CGFloat(lhs) / rhs}
func /(lhs: Double, rhs: Int) -> Double {return lhs / Double(rhs)}
func /(lhs: Double, rhs: Float) -> Double {return lhs / Double(rhs)}
func /(lhs: Double, rhs: CGFloat) -> CGFloat {return CGFloat(lhs) / rhs}
func /(lhs: CGFloat, rhs: Int) -> CGFloat {return lhs / CGFloat(rhs)}
func /(lhs: CGFloat, rhs: Float) -> CGFloat {return lhs / CGFloat(rhs)}
func /(lhs: CGFloat, rhs: Double) -> CGFloat {return lhs / CGFloat(rhs)}

// CGPoint, CGSize, CGRect
func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)}
func +(lhs: CGRect, rhs: CGRect) -> CGRect {return lhs.union(rhs)}

func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)}
func -(lhs: CGRect, rhs: CGRect) -> CGRect {return lhs.intersect(rhs)}

func *(lhs: CGPoint, rhs: CGFloat) -> CGPoint {return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)}
func *(lhs: CGSize, rhs: CGFloat) -> CGSize {return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)}
func *(lhs: CGRect, rhs: CGFloat) -> CGRect {return CGRect(origin: lhs.origin * rhs, size: lhs.size * rhs)}

func /(lhs: CGSize, rhs: CGSize) -> CGFloat {return sqrt(lhs.area / rhs.area)} // 两个Size的比例

func +=(inout lhs: CGPoint, rhs: CGPoint) {lhs.x += rhs.x; lhs.y += rhs.y}
func +=(inout lhs: CGRect, rhs: CGRect) {lhs.unionInPlace(rhs)}

func -=(inout lhs: CGPoint, rhs: CGPoint) {lhs.x -= rhs.x; lhs.y -= rhs.y}
func -=(inout lhs: CGRect, rhs: CGRect) {lhs.intersectInPlace(rhs)}

func *=(inout lhs: CGPoint, rhs: CGFloat) {lhs.x *= rhs; lhs.y *= rhs}
func *=(inout lhs: CGSize, rhs: CGFloat) {lhs.width *= rhs; lhs.height *= rhs}
func *=(inout lhs: CGRect, rhs: CGFloat) {lhs.origin *= rhs; lhs.size *= rhs}

func |-|(lhs: CGPoint, rhs: CGPoint) -> CGFloat {return sqrt(pow(lhs.x - rhs.x, 2) + pow(lhs.y - rhs.y, 2))} // 两点间距离
func |-|(lhs: CGRect, rhs: CGRect) -> CGFloat {return lhs.center |-| rhs.center}
func |-|(lhs: UIView, rhs: UIView) -> CGFloat {return lhs.center |-| rhs.center}



// MARK: - Top level function
/**
格式化LOG

- parameter items:  输出内容
- parameter file:   所在文件
- parameter method: 所在方法
- parameter line:   所在行
*/
func MMLog(items: Any... ,
    file: String = #file,
    method: String = #function,
    line: Int = #line) {
    #if DEBUG
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.dateFormat = "YYYY-MM-dd hh:mm:ss.SSS"
        var itemStr = ""
        for item in items {
            if let str = item as? String {
                itemStr += str
            } else {
                itemStr += "\(item)"
            }
        }
        print("-------------------------- MMLOG --------------------------\n[" + formatter.stringFromDate(NSDate()) + "] <" + (file as NSString).lastPathComponent + ":" + method + "  inLine:\(line)>\n" + itemStr)
    #endif
}
/**
 输出标记
 */
func Mark( file: String = #file,
    method: String = #function,
    line: Int = #line) {
    MMLog("- MARK -", file: file, method: method, line: line)
}
/// 屏幕尺寸
var screenBounds : CGRect {return UIScreen.mainScreen().bounds}
// 判断屏幕尺寸
func screenIsSize(size: Float) -> Bool {
    switch size {
    case 3.5:
        return UIScreen.mainScreen().bounds.size == CGSize(320, 480)
    case 4.0:
        return UIScreen.mainScreen().bounds.size == CGSize(320, 568)
    case 4.7:
        return UIScreen.mainScreen().bounds.size == CGSize(375, 667)
    case 5.5:
        return UIScreen.mainScreen().bounds.size == CGSize(414, 736)
    default:
        return false
    }
}
// 判断系统版本
func systemVersionLater(version: String) -> Bool {return UIDevice.currentDevice().systemVersion >= version}
// 获取当前控制器
func getCurrentViewController() -> UIViewController? {
    var result: UIViewController?
    let topWindow = UIApplication.sharedApplication().keyWindow
    if topWindow?.windowLevel != UIWindowLevelNormal {
        for topWindow in UIApplication.sharedApplication().windows{
            if topWindow.windowLevel == UIWindowLevelNormal {
                break
            }
        }
    }
    var nextRespons: AnyObject?
    if systemVersionLater("8.0") {
        nextRespons = topWindow?.subviews[0].subviews[0].nextResponder()
    } else {
        nextRespons = topWindow?.subviews[0].nextResponder()
    }
    
    if nextRespons is UIViewController {
        result = (nextRespons as! UIViewController)
    } else if let rootViewContoller = topWindow?.rootViewController {
        result = rootViewContoller
    } else {
        assertionFailure("ShareKit: Could not find a root view controller.  You can assign one manually by calling [[SHK currentHelper] setRootViewController:YOURROOTVIEWCONTROLLER].")
    }
    while result!.respondsToSelector(Selector("rootViewController")) || result!.respondsToSelector(Selector("topViewController")) || result!.respondsToSelector(Selector("selectedViewController")) {
        if result!.respondsToSelector(Selector("rootViewController")) && result!.valueForKey("rootViewController") != nil {
            result = (result!.valueForKey("rootViewController") as! UIViewController)
        } else if result!.respondsToSelector(Selector("topViewController")) {
            result = (result!.valueForKey("topViewController") as! UIViewController)
        } else if result!.respondsToSelector(Selector("selectedViewController")) {
            result = (result!.valueForKey("selectedViewController") as! UIViewController)
        }
    }
    return result
}

// MARK: - CGPoint, CGSize, CGRect 扩展
// MARK: CGPoint
extension CGPoint {
    //构造器
    init(_ x: CGFloat, _ y: CGFloat) {self.init(x: x, y: y)}
    init(_ x: Int, _ y: Int) {self.init(x: x, y: y)}
    init(_ x: Double, _ y: Double) {self.init(x: x, y: y)}
    
    // 距目标point的 距离
    func distanceTo(point point: CGPoint) -> CGFloat {return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))}
    // 减去一个point/ 目标point指向自身的向量
    func pointBySub(subPoint: CGPoint) -> CGPoint {return CGPoint(x: x - subPoint.x, y: y - subPoint.y)}
    mutating func sub(subPoint: CGPoint) {x -= subPoint.x; y -= subPoint.y}
    // 加上一个point
    func pointByAdd(addPoint: CGPoint) -> CGPoint {return CGPoint(x: x + addPoint.x, y: y + addPoint.y)}
    mutating func add(addPoint: CGPoint) {x += addPoint.x; y += addPoint.y}
    // point按比例放大/缩小
    func pointByScale(scale: CGFloat) -> CGPoint {return CGPoint(x: x * scale, y: y * scale)}
    mutating func scale(scale: CGFloat) {x *= scale; y *= scale;}
}
// MARK: CGSize
extension CGSize {
    //构造器
    init(_ width: CGFloat, _ height: CGFloat) {self.init(width: width, height: height)}
    init(_ width: Int, _ height: Int) {self.init(width: width, height: height)}
    init(_ width: Double, _ height: Double) {self.init(width: width, height: height)}

    // 面积
    var area: CGFloat {get{return width * height}}
    // 周长
    var perimeter: CGFloat {get{return 2*(width + height)}}
    //宽高比
    var ratio: CGFloat {get{return width / height}}
    // 目标size和自身的比例
    func scaleFrom(size: CGSize) -> CGFloat {return sqrt(size.area / area)}
    // size按比例放大/缩小
    func sizeByScale(scale: CGFloat) -> CGSize {return CGSize(width: width * scale, height: height * scale)}
    mutating func scale(scale: CGFloat) {width *= scale; height *= scale}
}
// MARK: CGRect
extension CGRect {
    //构造器
    init(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) {self.init(x: x, y: y, width: width, height: height)}
    init(_ x: Int, _ y: Int, _ width: Int, _ height: Int) {self.init(x: x, y: y, width: width, height: height)}
    init(_ x: Double, _ y: Double, _ width: Double, _ height: Double) {self.init(x: x, y: y, width: width, height: height)}
    init(center: CGPoint, size: CGSize){self.origin = center - CGPoint(x: size.width/2, y: size.height/2); self.size = size}
    
    // 中心 及 四角
    var center: CGPoint {set{origin.x = newValue.x - width/2; origin.y = newValue.y - height/2} get{return CGPoint(x: midX, y: midY)}}
    var topRight: CGPoint {set{origin.x = newValue.x - width/2; origin.y = newValue.y - height/2} get{return CGPoint(x: maxX, y: minY)}}
    var bottomLeft: CGPoint {set{origin.x = newValue.x - width/2; origin.y = newValue.y - height/2} get{return CGPoint(x: minX, y: maxY)}}
    var bottomRight: CGPoint {set{origin.x = newValue.x - width/2; origin.y = newValue.y - height/2} get{return CGPoint(x: maxX, y: maxY)}}
    /// 内中心
    var boundsCenter: CGPoint {get{return CGPoint(x: size.width/2, y: size.height/2)}}
    /// 面积
    var area: CGFloat {get{return width * height}}
    /// 周长
    var perimeter: CGFloat {get{return 2*(width + height)}}
    /// 宽高比
    var ratio: CGFloat {get{return width / height}}
    // 移动rect
    func rectByMoveBy(point: CGPoint) -> CGRect {return CGRect(origin: origin + point, size: size)}
    mutating func moveBy(point: CGPoint) {origin += point}
    func rectByMoveTo(center center: CGPoint) -> CGRect {return CGRect(center: center, size: size)}
    mutating func moveTo(center center: CGPoint) {origin = center - CGPoint(x: size.width/2, y: size.height/2)}
    //比例放大
    func rectByScale(scale: CGFloat) -> CGRect {return CGRect(origin: origin * scale, size: size * scale)}
    mutating func scale(scale: CGFloat) {origin *= scale; size *= scale}
}

// MARK: - Foundation 扩展
// MARK: String
extension String {
    func rangeFromNSRange(nsRange : NSRange) -> Range<String.Index>? {
        let from16 = utf16.startIndex.advancedBy(nsRange.location, limit: utf16.endIndex)
        let to16 = from16.advancedBy(nsRange.length, limit: utf16.endIndex)
        if let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self) {
                return from ..< to
        }
        return nil
    }
    
    func NSRangeFromRange(range : Range<String.Index>) -> NSRange {
        let utf16view = self.utf16
        let from = String.UTF16View.Index(range.startIndex, within: utf16view)
        let to = String.UTF16View.Index(range.endIndex, within: utf16view)
        return NSMakeRange(utf16view.startIndex.distanceTo(from), from.distanceTo(to))
    }
    
    func calculateWidthWith(fontSize: CGFloat, heightLimit height: CGFloat, otherAttribute otherAttr: [String: AnyObject]?) -> CGFloat {
        var attr : [String: AnyObject] = [NSFontAttributeName: UIFont.systemFontOfSize(fontSize)]
        if let otherAttr_ = otherAttr {
            for (key, value) in otherAttr_ {
                attr[key] = value
            }
        }
        return (self as NSString).boundingRectWithSize(CGSize(CGFloat(MAXFLOAT), height), options: [.UsesLineFragmentOrigin, .UsesFontLeading], attributes: attr, context: nil).width
    }
    
    func calculateHeightWith(fontSize: CGFloat, widthLimit width: CGFloat, otherAttribute otherAttr: [String: AnyObject]?) -> CGFloat {
        var attr : [String: AnyObject] = [NSFontAttributeName: UIFont.systemFontOfSize(fontSize)]
        if let otherAttr_ = otherAttr {
            for (key, value) in otherAttr_ {
                attr[key] = value
            }
        }
        return (self as NSString).boundingRectWithSize(CGSize(width, CGFloat(MAXFLOAT)), options: [.UsesLineFragmentOrigin, .UsesFontLeading], attributes: attr, context: nil).height
    }
}

extension Double {
    func format(f: String) -> String {
    return String(format: "%\(f)f", self)
    }
}

extension NSDateFormatter {
    convenience init(dateFormat: String) {
        self.init()
        self.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        self.dateFormat = dateFormat
    }
}

// MARK: - UIKit类 扩展
// MARK: UIView
extension UIView {
    var origin: CGPoint {set{frame.origin = newValue} get{return frame.origin}}
    var size: CGSize {set{frame.size = newValue} get{return frame.size}}
    
    var boundsCenter: CGPoint {get{return bounds.center}}
    var topRight: CGPoint {set{frame.moveTo(center: newValue - CGPoint(x: size.width/2, y: -size.height/2))} get{return origin + CGPoint(x: size.width, y: 0)}}
    var bottomLeft: CGPoint {set{frame.moveTo(center: newValue - CGPoint(x: -size.width/2, y: size.height/2))} get{return origin + CGPoint(x: 0, y: size.height)}}
    var bottomRight: CGPoint {set{frame.moveTo(center: newValue - CGPoint(x: size.width/2, y: size.height/2))} get{return origin + CGPoint(x: size.width, y: size.height)}}
    
    var width: CGFloat {set{size.width = newValue} get{return size.width}}
    var height: CGFloat {set{size.height = newValue} get{return size.height}}
    
    var left: CGFloat {set{origin.x = newValue} get{return origin.x}}
    var top: CGFloat {set{origin.y = newValue} get{return origin.y}}
    var right: CGFloat {set{origin.x = newValue - size.width} get{return origin.x + size.width}}
    var bottom: CGFloat {set{origin.y = newValue - size.height} get{return origin.y + size.height}}
    
    var midX: CGFloat {set{center.x = newValue} get{return center.x}}
    var midY: CGFloat {set{center.y = newValue} get{return center.y}}
    
    func moveBy(delta: CGPoint) {origin += delta}
    func scaleBy(scale: CGFloat) {size *= scale}
    // anchorPoint  (0.0, 0.0) - (1.0, 1.0)
    func resize(size: CGSize, atAnchorPoint anchor: CGPoint) {
       let anchorTemp = CGPoint(x: max(0, min(1, anchor.x)), y: max(0, min(1, anchor.y)))
        frame = CGRect(origin: origin - CGPoint(x: (size.width - width) * anchorTemp.x, y: (size.height - height) * anchorTemp.y), size: size)
    }
    func fitIn(size: CGSize) {
        if self.size.ratio > size.ratio {
            self.size = CGSize(width: size.width, height: size.width / self.size.width * self.size.height)
        } else {
            self.size = CGSize(width: size.height / self.size.height * self.size.width, height: size.height)
        }
    }
}
// MARK: CALayer
extension CALayer {
    var origin: CGPoint {set{frame.origin = newValue} get{return frame.origin}}
    var size: CGSize {set{frame = CGRect(origin: frame.origin - CGPoint(x: (newValue.width - frame.width) * anchorPoint.x, y: (newValue.height - frame.height) * anchorPoint.y), size:newValue)} get{return frame.size}}
    
    var boundsCenter: CGPoint {get{return bounds.center}}
    
    var topRight: CGPoint {set{frame.moveTo(center: newValue - CGPoint(x: size.width/2, y: -size.height/2))} get{return origin + CGPoint(x: size.width, y: 0)}}
    var bottomLeft: CGPoint {set{frame.moveTo(center: newValue - CGPoint(x: -size.width/2, y: size.height/2))} get{return origin + CGPoint(x: 0, y: size.height)}}
    var bottomRight: CGPoint {set{frame.moveTo(center: newValue - CGPoint(x: size.width/2, y: size.height/2))} get{return origin + CGPoint(x: size.width, y: size.height)}}
    
    var width: CGFloat {set{size.width = newValue} get{return size.width}}
    var height: CGFloat {set{size.height = newValue} get{return size.height}}
    
    var left: CGFloat {set{origin.x = newValue} get{return origin.x}}
    var top: CGFloat {set{origin.y = newValue} get{return origin.y}}
    var right: CGFloat {set{origin.x = newValue - size.width} get{return origin.x + size.width}}
    var bottom: CGFloat {set{origin.y = newValue - size.height} get{return origin.y + size.height}}
    
    var midX: CGFloat {set{origin.x = newValue - width/2} get{return origin.x + width/2}}
    var midY: CGFloat {set{origin.y = newValue - height/2} get{return origin.y + height/2}}
    
    
    // 替换 系统方法 实现
    class func switchImplementations() {
        var sysMethod = class_getInstanceMethod(self, #selector(CALayer.addSublayer(_:)))
        var customMethod = class_getInstanceMethod(self, #selector(CALayer.customAddSublayer(_:)))
        method_exchangeImplementations(sysMethod, customMethod)
        sysMethod = class_getInstanceMethod(self, #selector(CALayer.removeFromSuperlayer))
        customMethod = class_getInstanceMethod(self, #selector(CALayer.customRemoveFromSuperlayer))
        method_exchangeImplementations(sysMethod, customMethod)
    }
    // 自定义添加子Layer方法
    func customAddSublayer(sublayer: CALayer) {
        sublayer.willMoveToSuperlayer(self)
        customAddSublayer(sublayer) // 方法实现已交换， 此为调用系统方法实现
        sublayer.didMoveToSuperlayer()
    }
    // 自定义从父Laer删除方法
    func customRemoveFromSuperlayer() {
        self.willMoveToSuperlayer(nil)
        customRemoveFromSuperlayer() // 方法实现已交换， 此为调用系统方法实现
        self.didMoveToSuperlayer()
    }
    // 自定义生命周期方法，子类可重载这些方法
    func willMoveToSuperlayer(newSuperlayer: CALayer?) {}
    func didMoveToSuperlayer() {}
}
// MARK: UIColor
extension UIColor {
    convenience init(colorCode: UInt32) {
        self.init(colorCode: colorCode, alpha: 1)
    }
    convenience init(colorCode: UInt32, alpha: CGFloat) {
        self.init(red: CGFloat((colorCode & 0xFF0000) >> 16)/255, green: CGFloat((colorCode & 0x00FF00) >> 8)/255, blue: CGFloat(colorCode & 0x0000FF)/255, alpha: alpha)
    }
}
// MARK: UITableViewCell
extension UITableViewCell {
    func cleanSeparatorInset() {
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

// MARK: UIGestureRecognizer
// TODO: NSArray 和 闭包 冲突

/*
typealias GestureBlock = UIGestureRecognizer -> Void
private let gestureRecognizerBlocksArray = UnsafePointer<Void>()
private let gestureBlockQueue: dispatch_queue_t = dispatch_queue_create("gestureBlockQueue", DISPATCH_QUEUE_SERIAL)
extension UIGestureRecognizer {
    
    var blocks: NSArray {
        get{
            if objc_getAssociatedObject(self, gestureRecognizerBlocksArray) == nil {
                objc_setAssociatedObject(self, gestureRecognizerBlocksArray, NSMutableArray(), UInt(OBJC_ASSOCIATION_RETAIN))
            }
            return objc_getAssociatedObject(self, gestureRecognizerBlocksArray) as! NSArray
        }
    }
    
    func addTo(view: UIView, withBlock block: GestureBlock) {
                
        dispatch_async(gestureBlockQueue) {
            if objc_getAssociatedObject(self, gestureRecognizerBlocksArray) == nil {
                objc_setAssociatedObject(self, gestureRecognizerBlocksArray, NSMutableArray(), UInt(OBJC_ASSOCIATION_RETAIN))
            }
            view.addGestureRecognizer(self)
            var blockArray = objc_getAssociatedObject(self, gestureRecognizerBlocksArray) as! NSMutableArray
            if blockArray.count == 0 {self.addTarget(self, action: "blockHandle")}
//            blockArray.addObject(block)
        }
    }
    
    private func blockHandle() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
        }
    }
}
*/
