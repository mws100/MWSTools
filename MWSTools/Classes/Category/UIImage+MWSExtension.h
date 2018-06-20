//
//  UIImage+MWSExtension.h
//
//  Created by 马文帅 on 2018/6/19.
//  Copyright © 2018年 mawenshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MWSColorUtils)
/**
 *  返回指定颜色的UIImage，尺寸为 1Point x 1Point
 *
 *  @param color 颜色
 *
 *  @return 指定颜色的UIImage
 */
+ (UIImage *)mws_imageWithColor:(UIColor *)color;

/**
 *  返回指定颜色和尺寸的UIImage
 *
 *  @param color 颜色
 *  @param size  尺寸
 *
 *  @return 指定颜色和尺寸的UIImage
 */
+ (UIImage *)mws_imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *  返回指定颜色尺寸和圆角半径的UIImage
 *
 *  @param color  颜色
 *  @param size   尺寸
 *  @param radius 圆角半径
 *
 *  @return 指定颜色尺寸和圆角半径的UIImage
 */
+ (UIImage *)mws_imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)radius;


@end

/**
 * 此Category存在的目的是在使用xcassets时在iPhone 5和iPhone 6这两种均使用@2x的设备上可以加载不同的图像（典型例子：全屏图像）
 * 以及未来出现分辨率不同的@3x设备时也有能力对不同设备加载不同的图像
 * 增加新类型的步骤：在.m文件中的enum里增加设备类型，约定不同的后缀，在增加对相应后缀的判断
 * 此Category需要配合xcassets使用，因此会假定xcassets中对1x，2x，3x，以及iPad和iPhone已经做了区分（Xcode 6）
 */
@interface UIImage (MWSDeviceSpecificMedia)

/**
 *  获取指定名称的图片，使用约定的后缀来区分
 *
 *  @param fileName 图片文件名称
 *
 *  @return 指定名称的图片
 */
+ (instancetype)mws_imageForDeviceWithName:(NSString *)fileName;

@end


/**    self.backgroundColor = MWSGlobalCellBG;

 *  apple provided this category in WWDC 2013
 */
@interface UIImage (MWSImageBlurEffects)

/**
 *  返回模糊后的图像，色调偏白
 *
 *  @return 模糊后的UIImage
 */
- (UIImage *)mws_applyLightBlurEffect;

/**
 *  返回模糊后的图像，色调偏黑
 *
 *  @return 模糊后的UIImage
 */
- (UIImage *)mws_applyDarkBlurEffect;

/**
 *  返回模糊后的图像，自定义色调
 *
 *  @param tintColor 模糊后的色调
 *
 *  @return 模糊后的UIImage
 */
- (UIImage *)mws_applyTintEffectWithColor:(UIColor *)tintColor;

/**
 *  返回模糊后的图像，可自定义所有参数
 *
 *  @param blurRadius            模糊半径
 *  @param tintColor             模糊后的色调
 *  @param saturationDeltaFactor 饱和度偏移量，不会用就设为1.8左右
 *  @param maskImage             遮罩图，不知道怎么用就设为nil
 *
 *  @return 模糊后的UIImage
 */
- (UIImage *)mws_applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

@end

@interface UIImage (MWSFrameUtils)

- (UIImage *)mws_scaleToSize:(CGSize)size;
- (UIImage *)mws_clipToRect:(CGRect)rect;
- (UIImage *)mws_scaleToWidth:(CGFloat)width;

/**
 *  返回圆形图片
 *
 *  @return 圆形image
 */
- (UIImage *)mws_circleImage;

/**
 *  返回带颜色边框的圆形图片
 *
 *  @param borderWidth 圆形边框的宽度
 *  @param borderColor 圆形边框的颜色
 *
 *  @return 圆形image
 */
- (UIImage *)mws_circleImageBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 *  返回带两层颜色边框的圆形图片
 *
 *  @param bigBorderWidth    大圆边框的宽度
 *  @param bigBorderColor    大圆边框的颜色
 *  @param littleBorderWidth 小圆边框的宽度
 *  @param littleBorderColor 小圆边框的颜色
 *
 *  @return 圆形image
 */
- (UIImage *)mws_circleImageBigBorderWidth:(CGFloat)bigBorderWidth bigBorderColor:(UIColor *)bigBorderColor littleBorderWidth:(CGFloat)littleBorderWidth littleBorderColor:(UIColor *)littleBorderColor;



/**
 *  返回带弧度的角图片
 *
 *  @param radius 弧度值
 *
 *  @return 带弧度的角图片
 */
- (UIImage *)mws_clipToCornerRadius:(CGFloat)radius;

/**
 *  压缩图像直到文件二进制size小于某个给定的byte数，如果给定的byte数过小，返回尽可能压缩过的图像
 *
 *  @param bytes 图像最大的byte数
 *
 *  @return 压缩过后的UIImage
 */
- (UIImage *)mws_compressToMaxFileSize:(NSUInteger)bytes;

/**
 *  截图
 *
 *  @param view 要截图的view
 *
 *  @return iamge
 */
+ (instancetype)mws_cupWithView:(UIView *)view;

/**
 *  直接截屏
 *
 *  @return iamge
 */
+ (UIImage *)mws_cutScreen;

/**
 *  根据frame截图
 *
 */
- (UIImage *)mws_cutWithFrame:(CGRect)frame;

@end

