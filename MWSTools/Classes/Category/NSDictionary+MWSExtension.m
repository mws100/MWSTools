//
//  NSDictionary+MWSExtension.h
//
//  Created by 马文帅 on 2018/6/19.
//  Copyright © 2018年 mawenshuai. All rights reserved.
//

#import "NSDictionary+MWSExtension.h"

@implementation NSDictionary (MWSExtension)

- (NSString *)mws_dictionaryToJson {
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
