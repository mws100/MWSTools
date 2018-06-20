//
//  UIColor+MWSExtension.h
//
//  Created by 马文帅 on 2018/6/19.
//  Copyright © 2018年 mawenshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (MWSExtension)

/**
 *  返回16进制色值对应的UIColor
 *  例如 [UIColor colorFromHex:0xffffff] 的返回值相当于 [UIColor whiteColor]
 *
 *  @param hexColor color的16进制表示，需要0x前缀，例如0x66ccff
 *
 *  @return 16进制表示法对应的UIColor
 */
+ (UIColor *)mws_colorWithHex:(NSInteger)hexColor;

/**
 *  return a Random Color
 *
 *  @return random Color
 */
+ (UIColor *)mws_randomColor;

@end
