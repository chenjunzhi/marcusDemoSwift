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
  
  //对某个图片进行缩小  将原图缩小为 scale  背景用 background 填充
  class func scaleImage(image:UIImage,scale:CGFloat,background:UIColor) -> UIImage {
    let imageSize = image.size
    UIGraphicsBeginImageContextWithOptions(imageSize, true, image.scale);
    background.set()
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height))
    let backGroundImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(imageSize)
    backGroundImage.drawInRect(CGRectMake(0, 0, imageSize.width, imageSize.height))
    image.drawInRect(CGRectMake(imageSize.width*(1.0-scale)*0.5, imageSize.height*(1.0-scale)*0.5, imageSize.width*scale, imageSize.height*scale))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }
  
//  //对某个图片进行放大  将原图尺寸不变  背景用 background 填充，并放大为 1/scale 倍
  class func specialScaleImage(image:UIImage,scale:CGFloat,background:UIColor) -> UIImage {
    let imageSize = image.size
    let newImageSize = CGSizeMake(image.size.width/scale, image.size.height/scale)
    UIGraphicsBeginImageContextWithOptions(newImageSize, false, 1.0);
    background.set()
    UIRectFill(CGRectMake(0, 0, imageSize.width/scale, imageSize.height/scale))
    let backGroundImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(newImageSize)
    backGroundImage.drawInRect(CGRectMake(0, 0, imageSize.width/scale, imageSize.height/scale))
    image.drawInRect(CGRectMake(imageSize.width*((1.0-scale)/scale)*0.5, imageSize.height*((1.0-scale)/scale)*0.5, imageSize.width, imageSize.height))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }
  
  //对某个 View 进行截图 (view的部分区域 截图)
  class func convertViewImage(view: UIView, frame: CGSize) -> UIImage{
    UIGraphicsBeginImageContext(frame)
    view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
  
  //通过GPUImage 高斯模糊
  class func gaussianBlurOnImage(imageToBlur: UIImage, blur: Double) -> UIImage {
    let gauFilter = GPUImageGaussianBlurFilter.init()
    gauFilter.blurRadiusInPixels = CGFloat(blur)
    let newImage = gauFilter.imageByFilteringImage(imageToBlur)
    return newImage
  }
  
  //将图片做高斯模糊  blurRadius : 0 - 1 取值
  class func applyBlurOnImage(imageToBlur: UIImage, blur: Double) -> UIImage{
    var blurRadius = blur
    if ((blurRadius < 0.0) || (blurRadius > 1.0)) {
      blurRadius = 0.5;
    }
    
    var boxSize = Int(blurRadius * 40);
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
    
    outBuffer.width = vImagePixelCount(CGImageGetWidth(rawImage))
    outBuffer.height = vImagePixelCount(CGImageGetHeight(rawImage))
    outBuffer.rowBytes = CGImageGetBytesPerRow(rawImage)
    outBuffer.data = pixelBuffer
    
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