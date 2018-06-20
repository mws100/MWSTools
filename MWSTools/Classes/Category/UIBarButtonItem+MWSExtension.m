//
//  UIBarButtonItem+MWSExtension.h
//
//  Created by 马文帅 on 2018/6/19.
//  Copyright © 2018年 mawenshuai. All rights reserved.
//

#import "UIBarButtonItem+MWSExtension.h"

@implementation UIBarButtonItem (MWSExtension)

+ (instancetype)mws_leftItemWithImage:(NSString *)image tintColor:(UIColor *)tintColor target:(id)target action:(SEL)action {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:image] style:UIBarButtonItemStylePlain target:target action:action];
    item.width = 50;
    if (@available(iOS 11.0, *)) {
        item.imageInsets = UIEdgeInsetsMake(0, -12, 0, 0);
    }
    item.tintColor = tintColor;
    return item;
}

+ (instancetype)mws_rightItemWithImage:(NSString *)image tintColor:(UIColor *)tintColor target:(id)target action:(SEL)action {
    UIImage *img = [UIImage imageNamed:image];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:target action:action];
    item.width = 50;
    if (@available(iOS 11.0, *)) {
        item.imageInsets = UIEdgeInsetsMake(0, 0, 0, -12);
    }
    item.tintColor = tintColor;
    return item;
}

+ (instancetype)mws_rightItemWithTitle:(NSString *)title tintColor:(UIColor *)tintColor target:(id)target action:(SEL)action {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    item.width = 50;
    [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:tintColor} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateHighlighted];
    [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[tintColor colorWithAlphaComponent:0.3]} forState:UIControlStateDisabled];

    [item setTitlePositionAdjustment:UIOffsetMake(12, 0) forBarMetrics:UIBarMetricsDefault];
    return item;
}

@end
