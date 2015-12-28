//
//  MSManageImage.swift
//  marcusDemoSwift
//
//  Created by marcus on 15/12/25.
//  Copyright © 2015年 marcus. All rights reserved.
//  图片处理类 

import Foundation
import UIKit
import Accelerate

class MSManageImage {
  
  //对某个 View 进行截图 (整个View 截图)
  class func convertViewImage(view: UIView) -> UIImage {
    UIGraphicsBeginImageContext(view.bounds.size)
    view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
  
  //对某个 View 进行截图 (view的部分区域 截图)
  class func convertViewImage(view: UIView, frame: CGSize) -> UIImage{
    UIGraphicsBeginImageContext(frame)
    view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
  
  //将图片做高斯模糊  blurRadius : 0 - 1 取值
  class func applyBlurOnImage(imageToBlur: UIImage, blur: Double) -> UIImage{
    var blurRadius = blur
    if ((blurRadius <= 0.0) || (blurRadius > 1.0)) {
      blurRadius = 0.5;
    }
    
    var boxSize = Int(blurRadius * 100);
    boxSize -= (boxSize % 2) + 1;
    
    let rawImage = imageToBlur.CGImage;
    
    var inBuffer = vImage_Buffer()
    var outBuffer = vImage_Buffer()
    
    let inProvider = CGImageGetDataProvider(rawImage);
    let inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = vImagePixelCount(CGImageGetWidth(rawImage))
    inBuffer.height = vImagePixelCount(CGImageGetHeight(rawImage))
    inBuffer.rowBytes = CGImageGetBytesPerRow(rawImage)
    inBuffer.data = UnsafeMutablePointer<Void>(CFDataGetBytePtr(inBitmapData))
    
    //手动申请内存
    let pixelBuffer = malloc(CGImageGetBytesPerRow(rawImage) * CGImageGetHeight(rawImage))
    
    outBuffer.data = pixelBuffer
    outBuffer.width = vImagePixelCount(CGImageGetWidth(rawImage))
    outBuffer.height = vImagePixelCount(CGImageGetHeight(rawImage))
    outBuffer.rowBytes = CGImageGetBytesPerRow(rawImage);
    
    var error = vImageBoxConvolve_ARGB8888(&inBuffer,
        &outBuffer, nil,vImagePixelCount(0), vImagePixelCount(0),
        UInt32(boxSize), UInt32(boxSize), nil, vImage_Flags(kvImageEdgeExtend));
    if (kvImageNoError != error) {
        error = vImageBoxConvolve_ARGB8888(&inBuffer,
            &outBuffer, nil, vImagePixelCount(0), vImagePixelCount(0),
            UInt32(boxSize), UInt32(boxSize), nil, vImage_Flags(kvImageEdgeExtend))
    }
    
    if(error != kvImageNoError){
        print("出错error：\(error)")
    }else{
        print("无错\(error)")
    }

    let colorSpace = CGColorSpaceCreateDeviceRGB();
    let ctx = CGBitmapContextCreate(outBuffer.data,
      Int(outBuffer.width),  
      Int(outBuffer.height),
      8,
      outBuffer.rowBytes,
      colorSpace,
      CGImageGetBitmapInfo(imageToBlur.CGImage).rawValue);
    
    let imageRef = CGBitmapContextCreateImage (ctx);
    free(pixelBuffer);
    
    return UIImage(CGImage: imageRef!)
  }
  
}