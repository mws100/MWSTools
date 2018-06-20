//
//  UIButton+MWSExtension.h
//
//  Created by 马文帅 on 2018/6/19.
//  Copyright © 2018年 mawenshuai. All rights reserved.
//

#import "UIButton+MWSExtension.h"
#import "UIImage+MWSExtension.h"
#import "UIColor+MWSExtension.h"

@implementation UIButton (MWSExtension)

+ (UIButton *)mws_buttonWithBackgroundColor:(UIColor *)backgroundColor
                          highlightedColor:(UIColor *)highlightedColor
                                     title:(NSString *)title
                                 textColor:(UIColor *)textColor
                      textHighlightedColor:(UIColor *)textHighlightedColor
                                      font:(UIFont *)font
                               normalImage:(UIImage *)image
                          highlightedImage:(UIImage *)highlightedImage
                              cornerRadius:(CGFloat)radius {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage mws_imageWithColor:backgroundColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage mws_imageWithColor:highlightedColor] forState:UIControlStateHighlighted];
    [button mws_setTitle:title];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    [button setTitleColor:textHighlightedColor forState:UIControlStateHighlighted];
    if (font) {
        button.titleLabel.font = font;
    }
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
        if (highlightedImage) {
            [button setImage:highlightedImage forState:UIControlStateHighlighted];
        }
    }
    //这里没有使用圆角UIImage来做背景图，因为此button的frame可能会改变
    if (radius > 0) {
        button.layer.cornerRadius = radius;
        button.layer.masksToBounds = YES;
    }
    [button sizeToFit];
    return button;
}

+ (UIButton *)mws_navCricleButtonWithBackgroundColor:(UIColor *)backgroundColor
                                        normalImageName:(NSString *)imageName
                                   highlightedImageName:(NSString *)highlightedImageName {
   UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *colorImage = [UIImage mws_imageWithColor:backgroundColor size:CGSizeMake(40, 40)];
    [button setBackgroundImage:[colorImage mws_circleImage] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, 0, button.currentImage.size.width, button.currentImage.size.height) ;
    return button;
}

- (void)mws_setTitle:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
    [self setTitle:title forState:UIControlStateSelected];
    [self setTitle:title forState:UIControlStateDisabled];
    [UIColor grayColor];
}

+ (UIButton *)mws_grayColorCornerBorderButtonWithTitle:(NSString *)title {
    UIButton *button = [self mws_buttonWithBackgroundColor:[UIColor whiteColor]
                                         highlightedColor:[UIColor mws_colorWithHex:0xeeeeee]
                                                    title:title
                                                textColor:[UIColor mws_colorWithHex:0x333333]
                                     textHighlightedColor:[UIColor mws_colorWithHex:0x333333]
                                                     font:[UIFont systemFontOfSize:16]
                                              normalImage:nil
                                         highlightedImage:nil
                                             cornerRadius:3];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor mws_colorWithHex:0xb1b1b1].CGColor;
    button.layer.masksToBounds = YES;
    return button;
}

@end
