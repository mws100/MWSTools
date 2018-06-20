//
//  NSData+MWSExtension.h
//
//  Created by 马文帅 on 2018/6/19.
//  Copyright © 2018年 mawenshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (MWSExtension)

/**
 *  对NSData进行加密
 *
 *  @param key 自定义的加密的key
 *
 *  @return 返回加密后的NSData
 */
- (NSData *)mws_aes256Encrypt:(NSString *)key;

/**
 *  对NSData进行解密
 *
 *  @param key 自定义的解密的key
 *
 *  @return 返回解密后的NSData
 */
- (NSData *)mws_aes256Decrypt:(NSString *)key;

@end
