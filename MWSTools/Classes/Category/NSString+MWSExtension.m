//
//  NSDictionary+MWSExtension.h
//
//  Created by 马文帅 on 2018/6/19.
//  Copyright © 2018年 mawenshuai. All rights reserved.
//

#import "NSString+MWSExtension.h"
#import "CommonCrypto/CommonDigest.h"
#import "NSData+MWSExtension.h"
#import "NSDate+MWSExtension.h"

@implementation NSString (HHExtension)

- (NSData *)mws_dataFromHexString {
    const char *chars = [self UTF8String];
    NSUInteger i = 0, len = self.length;

    NSMutableData *data = [NSMutableData dataWithCapacity:len / 2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;

    while (i < len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }

    return data;
}

- (NSString *)mws_trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)mws_md5 {
    const char *cStr = self.UTF8String;
    uint8_t result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

- (BOOL)mws_containsString:(NSString *)aString {
    if ([self respondsToSelector:@selector(containsString:)]) {
        return [self containsString:aString];
    }
    return [self rangeOfString:aString].location != NSNotFound;
}

- (CGFloat)mws_heightWithFont:(int)font maxWidth:(CGFloat)maxWidth {
    return [self boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil].size.height;
}

- (CGFloat)mws_heightWithFont:(UIFont *)font
                    maxWidth:(CGFloat)maxWidth
                 lineSpacing:(CGFloat)lineSpacing {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpacing;
    NSDictionary *attributes = @{ NSFontAttributeName : font,
                                  NSParagraphStyleAttributeName : style };
    CGRect rect = [self boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:attributes
                                  context:nil];
    return rect.size.height;
}

- (CGFloat)mws_widthWithFont:(int)font maxHeight:(CGFloat)maxHeight {
    return [self boundingRectWithSize:CGSizeMake(MAXFLOAT, maxHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil].size.width;
}

- (NSAttributedString *)mws_attributedStringWithColor:(UIColor *)color
                                                font:(UIFont *)font
                                         lineSpacing:(CGFloat)lineSpacing {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpacing;
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    NSDictionary *attributes = @{ NSFontAttributeName : font,
                                  NSForegroundColorAttributeName : color,
                                  NSParagraphStyleAttributeName : style };

    return [[NSAttributedString alloc] initWithString:self
                                           attributes:attributes];
}

- (NSAttributedString *)mws_tikuAttributedStringWithColor:(UIColor *)color font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing {
//    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//    style.lineSpacing = lineSpacing;
//    style.lineBreakMode = NSLineBreakByTruncatingTail;
//    NSDictionary *attributes = @{NSFontAttributeName : font,  NSForegroundColorAttributeName : MWSGlobalTextColor, NSParagraphStyleAttributeName : style};
//    
//    NSAttributedString *attrStr= [[NSAttributedString alloc] initWithData:[self dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:&attributes error:nil];
    
    
    
//    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//    style.lineSpacing = lineSpacing;
//    style.lineBreakMode = NSLineBreakByTruncatingTail;
//    NSDictionary *attributes = @{NSFontAttributeName : font,  NSForegroundColorAttributeName : MWSGlobalTextColor, NSParagraphStyleAttributeName : style};
    
    NSString *htmlStr = [NSString stringWithFormat:@"<div style=\"font-size:16;color:#333333;line-height:2;\">%@</div>", self];
    NSMutableAttributedString *attrStr= [[NSMutableAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    return attrStr;
}

- (NSString *)mws_aes256Encrypt:(NSString *)key {
//    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
//    NSData *data = [NSData dataWithBytes:cstr length:self.length];

    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    //对数据进行加密
    NSData *result = [data mws_aes256Encrypt:key];
    
    //转换为2进制字符串
    if (result && result.length > 0) {
        
        Byte *datas = (Byte*)[result bytes];
        NSMutableString *output = [NSMutableString stringWithCapacity:result.length * 2];
        for(int i = 0; i < result.length; i++){
            [output appendFormat:@"%02x", datas[i]];
        }
        return output;
    }
    return nil;
}

- (NSString *)mws_aes256Decrypt:(NSString *)key {
    //转换为2进制Data
    NSMutableData *data = [NSMutableData dataWithCapacity:self.length / 2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [self length] / 2; i++) {
        byte_chars[0] = [self characterAtIndex:i*2];
        byte_chars[1] = [self characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    
    //对数据进行解密
    NSData* result = [data mws_aes256Decrypt:key];
    if (result && result.length > 0) {
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (NSDictionary *)mws_jsonStringToDictionary {
    if (self == nil)    return nil;
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if(error) {
        NSLog(@"json解析失败：%@",error);
        return nil;
    }
    return dic;
}

- (NSArray *)mws_jsonStringToArray {
    if (self == nil)    return nil;
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if(error) {
        NSLog(@"json解析失败：%@",error);
        return nil;
    }
    return arr;
}


- (BOOL)mws_match:(NSString *)pattern {
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    return results.count > 0;
}

//大陆手机号验证
- (BOOL)mws_isPhoneNumber {
    return [self mws_match:@"^1\\d{10}$"];
}

/** 换行 */
- (NSString *)mws_wrap {
    if (![self mws_containsString:@"\\n"]) return self;
    
    NSArray *arr = [self componentsSeparatedByString:@"\\n"];
    NSString *finalStr = [[NSString alloc] init];
    for (int i=0; i<arr.count; i++) {
        finalStr = [finalStr stringByAppendingString:arr[i]];
        if (i != arr.count-1) {
            finalStr = [finalStr stringByAppendingString:@"\n"];
        }
    }
    return finalStr;
}

/** 检测emoj表情 */
- (BOOL)mws_stringContainsEmoji {
    __block BOOL returnValue = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    
    return returnValue;
}

- (NSString *)mws_dateStrToStr {
    NSTimeInterval interval = [self doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    return [formatter stringFromDate:date];
}

- (BOOL)mws_isIDCard {
    if (self.length <= 0) {
        return NO;
    }
    NSString *regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/** 格式化发帖时间 */
- (NSString *)mws_formatData {
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置日期格式(y:年,M:月,d:日,H:时,m:分,s:秒)
    fmt.dateFormat = @"yyyy-MM-dd HH:mm";
    
    NSString *dateStr = [fmt stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.doubleValue]];

    // 帖子的创建时间
    NSDate *create = [fmt dateFromString:dateStr];
    
    if (create.mws_isThisYear) { // 今年
        if (create.mws_isToday) { // 今天
            NSDateComponents *cmps = [[NSDate date] mws_deltaFrom:create];
            
            if (cmps.hour >= 1) { // 时间差距 >= 1小时
                return [NSString stringWithFormat:@"%ld小时前", (long)cmps.hour];
            } else if (cmps.minute >= 1) { // 1小时 > 时间差距 >= 1分钟
                return [NSString stringWithFormat:@"%ld分钟前", (long)cmps.minute];
            } else { // 1分钟 > 时间差距
                return @"刚刚";
            }
        } else if (create.mws_isYesterday) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:create];
        } else { // 其他
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:create];
        }
    } else { // 非今年
        return dateStr;
    }
}

- (NSNumber *)mws_decimalPoint {
    NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
    format.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *num = [format numberFromString:self];
    return num;
}

@end
