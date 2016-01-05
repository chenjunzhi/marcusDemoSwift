//
//  MSToolsManger.h
//  marcusDemoSwift
//
//  Created by marcus on 16/1/4.
//  Copyright © 2016年 marcus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface MSToolsManger : NSObject
/****** 图片处理
 //截取某个位置的图片
 *
 * @param  rect 图片需要截取的区域
 * @param  image 需要截取的图片
 * return 截取出来的图片
 */
+ (UIImage*)getImageFromInsideRect:(CGRect)rect WithImage:(UIImage*)image;

/****** 将图片做高斯模糊
 *
 * @param  imageToBlur 需要做高斯模糊的图片
 * @param  blurRadius 模糊值
 * return 高斯模糊后的图片
 */
+ (UIImage *)applyBlurOnImage: (UIImage *)imageToBlur withRadius:(CGFloat)blurRadius;
@end
