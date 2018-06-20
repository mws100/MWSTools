//
//  NSDate+MWSExtension.h
//
//  Created by 马文帅 on 2018/6/19.
//  Copyright © 2018年 mawenshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (MWSExtension)
- (NSString *)mws_MMdd;
- (NSString *)mws_yyyyMMdd;
- (NSString *)mws_yyyyMMddHHmmss;
- (NSString *)mws_yyyyMMddHHmm;
- (NSString *)mws_HHmm;
- (NSString *)mws_readable;

- (NSString *)mws_yyyy;
- (NSString *)mws_MM;
- (NSString *)mws_dd;

+ (NSDate *)mws_dateFromZone:(NSString *)dateString;
+ (NSDate *)mws_dateFromCST:(NSString *)dateString;

/**
 * 比较from和self的时间差值
 */
- (NSDateComponents *)mws_deltaFrom:(NSDate *)from;

/**
 * 比较from和self的间隔天数
 */
- (NSInteger)mws_deltaDaysTo:(NSDate *)to;

/**
 * 比较from和self的间隔分钟数
 */
- (NSInteger)mws_deltaMinutesTo:(NSDate *)to;

/**
 * 是否为今年
 */
- (BOOL)mws_isThisYear;

/**
 * 是否为今天
 */
- (BOOL)mws_isToday;

/**
 * 是否为昨天
 */
- (BOOL)mws_isYesterday;

@end
