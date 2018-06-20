//
//  UIButton+MWSExtension.h
//
//  Created by 马文帅 on 2018/6/19.
//  Copyright © 2018年 mawenshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (MWSExtension)

/**
 *  创建一个单色背景的UIButton，注意此方法返回的button时自动适应的尺寸，如果需要可以设置frame，圆角半径不会因frame的改变而改变
 *
 *  @param backgroundColor      按钮背景色
 *  @param highlightedColor     高亮时的背景色
 *  @param title                按钮文字
 *  @param font                 按钮字体，如果想使用默认值可设为nil
 *  @param textColor            文字颜色
 *  @param textHighlightedColor 文字高亮颜色
 *  @param image                按钮图片，可设置为nil，为nil时为文字按钮
 *  @param highlightedImage     按钮高亮图片，可设置为nil，如果image为nil则highlightedImage不显示
 *  @param radius               圆角半径，单位为point，可设置为0
 *
 *  @return 按照给定参数生成的UIButton
 */
+ (UIButton *)mws_buttonWithBackgroundColor:(UIColor *)backgroundColor
                          highlightedColor:(UIColor *)highlightedColor
                                     title:(NSString *)title
                                 textColor:(UIColor *)textColor
                      textHighlightedColor:(UIColor *)textHighlightedColor
                                      font:(UIFont *)font
                               normalImage:(UIImage *)image
                          highlightedImage:(UIImage *)highlightedImage
                              cornerRadius:(CGFloat)radius;

/**
 *  创建一个背景是纯色圆形只带图标的Nav按钮
 *
 *  @param backgroundColor      按钮背景色
 *  @param imageName            默认图标
 *  @param highlightedImageName 高亮图标
 *
 *  @return 按照给定参数生成的UIButton
 */
+ (UIButton *)mws_navCricleButtonWithBackgroundColor:(UIColor *)backgroundColor normalImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName;

/**
 *  创建一个灰色圆弧边框、白底的按钮
 *
 *  @param title 按钮标题
 *
 *  @return 按照给定参数生成的UIButton
 */
+ (UIButton *)mws_grayColorCornerBorderButtonWithTitle:(NSString *)title;

/**
 *  为所有的state设置title
 *
 *  @param title button title
 */
- (void)mws_setTitle:(NSString *)title;

@end
