//
//  UIDevice+MWSExtension.h
//
//  Created by 马文帅 on 2018/6/19.
//  Copyright © 2018年 mawenshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (MWSExtension)

/**
 *  MAC address for app wall, lower case, no colon
 *
 *  @return MAC address, lower case, no ":"
 */
+ (NSString *)mws_getMacAddressForAppWall;

/**
 *  get the MAC address of current device
 *
 *  @return MAC address of current device
 */
+ (NSString *)mws_getMacAddress;

/**
 *  advertisingIdentifier string
 *
 *  @return advertisingIdentifier string
 */
+ (NSString *)mws_getIDFA;


/**
 *  identifierForVendor string
 *
 *  @return identifierForVendorstring
 */
+ (NSString *)mws_getIDFV;

/**
 *  get IP address
 *
 *  @return 本机的IP地址
 */
+ (NSString *)mws_getIPAddress ;

@end
