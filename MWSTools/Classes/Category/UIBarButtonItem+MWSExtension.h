//
//  UIBarButtonItem+MWSExtension.h
//
//  Created by 马文帅 on 2018/6/19.
//  Copyright © 2018年 mawenshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (MWSExtension)

/**
 *  快速返回一个barButtonItem
 */
+ (instancetype)mws_leftItemWithImage:(NSString *)image tintColor:(UIColor *)tintColor target:(id)target action:(SEL)action;

/**
 *  快速返回一个barButtonItem
 */
+ (instancetype)mws_rightItemWithImage:(NSString *)image tintColor:(UIColor *)tintColor target:(id)target action:(SEL)action;
+ (instancetype)mws_rightItemWithTitle:(NSString *)title tintColor:(UIColor *)tintColor target:(id)target action:(SEL)action;

@end
