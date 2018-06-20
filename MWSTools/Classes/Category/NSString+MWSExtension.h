//
//  NSDictionary+MWSExtension.h
//
//  Created by 马文帅 on 2018/6/19.
//  Copyright © 2018年 mawenshuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (MWSExtension)

/**
 *  convert hex string to binary data, e.g. "b3" to 0xb3
 *
 *  @return NSData correspond to the hex string
 */
- (NSData *)mws_dataFromHexString;


/**
 *  remove white space and new line characters of the string
 *
 *  @return original string without leading/trailing spaces and new line symbols
 */
- (NSString *)mws_trim;

/**
 *  MD5 checksum of the given string
 *
 *  @return MD5 of the string
 */
- (NSString *)mws_md5;


/**
 *  check whether the given target string is contained within the receiver
 *
 *  @param aString the string to be checked
 *
 *  @return YES if the target string is contained within the receiver
 */
- (BOOL)mws_containsString:(NSString *)aString;

/**
 *  计算指定字体的String的高度
 */
- (CGFloat)mws_heightWithFont:(int)font maxWidth:(CGFloat)maxWidth;

/**
 *  计算指定样式的String的高度
 *
 *  @param font        字体
 *  @param maxWidth    最大宽度
 *  @param lineSpacing 行间距
 *
 *  @return 给定条件下String的高度
 */
- (CGFloat)mws_heightWithFont:(UIFont *)font
                    maxWidth:(CGFloat)maxWidth
                 lineSpacing:(CGFloat)lineSpacing;
/**
 *  计算指定字体的String的宽度
 *
 */
- (CGFloat)mws_widthWithFont:(int)font maxHeight:(CGFloat)maxHeight;

/**
 *  返回设定好的给定size和line spacing的Attributed String
 *
 *  @return attributed string with given line spacing
 */
- (NSAttributedString *)mws_attributedStringWithColor:(UIColor *)color font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing;


/**
 *  返回设定好的给定size和line spacing的Attributed String，加载html语句
 *
 *  @return attributed string with given line spacing
 */
- (NSAttributedString *)mws_tikuAttributedStringWithColor:(UIColor *)color font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing;

/**
 *  对NSString进行加密
 *
 *  @param key 自定义的加密key
 *
 *  @return 返回加密后的字符串
 */
- (NSString *)mws_aes256Encrypt:(NSString *)key;

/**
 *  对NSString进行解密
 *
 *  @param key 自定义的解密key
 *
 *  @return 返回解密后的字符串
 */
- (NSString *)mws_aes256Decrypt:(NSString *)key;

/**
 * @brief 把格式化的JSON格式的字符串转换成字典
 *
 * @return 返回字典
 */
- (NSDictionary *)mws_jsonStringToDictionary;

/**
 * @brief 把格式化的JSON格式的字符串转换成数组
 *
 * @return 返回字典
 */
- (NSArray *)mws_jsonStringToArray;

/**
 *  判断是不是大陆的手机号
 *
 *  @return 是不是大陆手机号
 */
- (BOOL)mws_isPhoneNumber;

/** 换行 */
- (NSString *)mws_wrap;

/** 检测emoj表情 */
- (BOOL)mws_stringContainsEmoji;

/** 时间戳转化成字符串 */
- (NSString *)mws_dateStrToStr;

/** 是不是身份证号 */
- (BOOL)mws_isIDCard;

/**
 今年
    今天
        1分钟内
            刚刚
            1小时内
 xx分钟前
 其他
 xx小时前
 昨天
 昨天 18:56:34
 其他
 06-23 19:56:23
 
 非今年
 2014-05-08 18:45:30
 */
/** 格式化发帖时间 */
- (NSString *)mws_formatData;

/** 保留一位小数 */
- (NSNumber *)mws_decimalPoint;

@end
