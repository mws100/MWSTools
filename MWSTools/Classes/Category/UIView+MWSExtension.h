//
//  UIView+MWSExtension.h
//
//  Created by 马文帅 on 2018/6/19.
//  Copyright © 2018年 mawenshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MWSExtension)

/**
 *  View 设置View的圆角
 *
 *  @param radius 弧度值
 */
- (void)mws_setCornerRadius:(float)radius;

/**
 * View 左边框到SuperView 左边框的距离
 */
@property (nonatomic) CGFloat mws_left;

/**
 * View 上边框到SuperView 上边框的距离
 */
@property (nonatomic) CGFloat mws_top;

/**
 * View 右边框到SuperView 左边框的距离
 */
@property (nonatomic) CGFloat mws_right;

/**
 * View 下边框到SuperView 上边框的距离
 */
@property (nonatomic) CGFloat mws_bottom;

/**
 * View的宽度
 */
@property (nonatomic) CGFloat mws_width;

/**
 * View的高度
 */
@property (nonatomic) CGFloat mws_height;

/**
 * View的中心点 x坐标
 */
@property (nonatomic) CGFloat mws_centerX;

/**
 * View的中心点 y坐标
 */
@property (nonatomic) CGFloat mws_centerY;

/**
 * View 相对屏幕起始点 x坐标
 */
@property (nonatomic, readonly) CGFloat mws_screenViewX;

/**
 * View 相对屏幕起始点 y坐标
 */
@property (nonatomic, readonly) CGFloat mws_screenViewY;

/**
 * View 相对屏幕 Frame
 */
@property (nonatomic, readonly) CGRect mws_screenFrame;

/**
 * View的起始点坐标
 */
@property (nonatomic) CGPoint mws_origin;

/**
 * View的大小
 */
@property (nonatomic) CGSize mws_size;


/**
 * 移出View中的子View
 */
- (void)mws_removeAllSubviews;

/**
 * View 相对某个SuperView 的起始点坐标
 */
- (CGPoint)mws_offsetFromView:(UIView*)otherView;

@end

@interface UIView (MWSScreenshot)
- (UIImage *)mws_screenshotImage;
@end

/** 遮罩类型 */
typedef NS_ENUM(NSUInteger, MWSShadowMaskType) {
    /** 上半部分有遮罩 */
    MWSShadowMaskTypeTop,
    /** 顶部和底部有遮罩 */
    MWSShadowMaskTypeFull,
};

@interface UIView (MWSShadowMask)
- (void)mws_showShadowMaskWithType:(MWSShadowMaskType)type;

@end
