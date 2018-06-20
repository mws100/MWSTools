//
//  UIViewController+MWSExtension.h
//
//  Created by 马文帅 on 2018/6/19.
//  Copyright © 2018年 mawenshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MWSExtension)

/** 导航栈中的上一个ViewController */
- (UIViewController *)mws_previousViewController;

/** 导航栈中的下一个ViewController */
- (UIViewController *)mws_nextViewController;

@end
