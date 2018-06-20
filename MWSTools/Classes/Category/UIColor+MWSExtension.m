//
//  UIColor+MWSExtension.h
//
//  Created by 马文帅 on 2018/6/19.
//  Copyright © 2018年 mawenshuai. All rights reserved.
//

#import "UIColor+MWSExtension.h"
#import "NSString+MWSExtension.h"

@implementation UIColor (MWSExtension)

+ (UIColor *)mws_colorWithHex:(NSInteger)hexColor {
    return [UIColor colorWithRed:((hexColor & 0xFF0000) >> 16)/255.0 green:((hexColor & 0x00FF00) >> 8) /255.0 blue:( hexColor & 0x0000FF)/255.0 alpha:1.0];
}

+ (UIColor *)mws_randomColor {
    return [UIColor colorWithRed:arc4random_uniform(256)/255.0
                           green:arc4random_uniform(256)/255.0
                            blue:arc4random_uniform(256)/255.0
                           alpha:1.0];
}


@end
