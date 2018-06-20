//
//  UIView+MWSExtension.h
//
//  Created by 马文帅 on 2018/6/19.
//  Copyright © 2018年 mawenshuai. All rights reserved.
//

#import "UIColor+MWSExtension.h"
#import "UIView+MWSExtension.h"

@implementation UIView (MWSExtension)

-(void)mws_setCornerRadius:(float)radius
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [[UIColor clearColor] CGColor];
}

- (CGFloat)mws_left {
    return self.frame.origin.x;
}

- (void)setMws_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)mws_top {
    return self.frame.origin.y;
}


- (void)setMws_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


- (CGFloat)mws_right {
    return self.frame.origin.x + self.frame.size.width;
}


- (void)setMws_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


- (CGFloat)mws_bottom {
    return self.frame.origin.y + self.frame.size.height;
}


- (void)setMws_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


- (CGFloat)mws_centerX {
    return self.center.x;
}


- (void)setMws_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


- (CGFloat)mws_centerY {
    return self.center.y;
}


- (void)setMws_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


- (CGFloat)mws_width {
    return self.frame.size.width;
}


- (void)setMws_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


- (CGFloat)mws_height {
    return self.frame.size.height;
}


- (void)setMws_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


- (CGFloat)mws_screenViewX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.mws_left;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            x -= scrollView.contentOffset.x;
        }
    }
    
    return x;
}


- (CGFloat)mws_screenViewY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.mws_top;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}


- (CGRect)mws_screenFrame {
    return CGRectMake(self.mws_screenViewX, self.mws_screenViewY, self.mws_width, self.mws_height);
}


- (CGPoint)mws_origin {
    return self.frame.origin;
}


- (void)setMws_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


- (CGSize)mws_size {
    return self.frame.size;
}


- (void)setMws_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}



- (void)mws_removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}


- (CGPoint)mws_offsetFromView:(UIView*)otherView {
    CGFloat x = 0, y = 0;
    for (UIView* view = self; view && view != otherView; view = view.superview) {
        x += view.mws_left;
        y += view.mws_top;
    }
    return CGPointMake(x, y);
}

@end


@implementation UIView (MWSScreenshot)

- (UIImage *)mws_screenshotImage {
    UIGraphicsBeginImageContext(self.bounds.size);
    if([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    }
    else{
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(image, 0.75);
    image = [UIImage imageWithData:imageData];
    return image;
}

@end


@implementation UIView (MWSShadowMask)

- (void)mws_showShadowMaskWithType:(MWSShadowMaskType)type {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    switch (type) {
        case MWSShadowMaskTypeTop:
            gradientLayer.colors = @[(__bridge id)[UIColor mws_colorWithHex:0xaaaaaa].CGColor,
                                     (__bridge id)[UIColor clearColor].CGColor];
            gradientLayer.opacity = 0.5;
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(0, 0.5);
            break;
        case MWSShadowMaskTypeFull:
            gradientLayer.colors = @[(__bridge id)[UIColor mws_colorWithHex:0xcccccc].CGColor,
                                     (__bridge id)[UIColor clearColor].CGColor,
                                     (__bridge id)[UIColor clearColor].CGColor,
                                     (__bridge id)[UIColor mws_colorWithHex:0xaaaaaa].CGColor];
            gradientLayer.opacity = 0.12;
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(0, 1);
            break;
    }
    [self.layer addSublayer:gradientLayer];
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

@end
