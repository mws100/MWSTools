//
//  UIViewController+MWSExtension.h
//
//  Created by 马文帅 on 2018/6/19.
//  Copyright © 2018年 mawenshuai. All rights reserved.
//

#import "UIViewController+MWSExtension.h"

@implementation UIViewController (MWSExtension)

- (UIViewController *)mws_previousViewController {
    if(self.navigationController.viewControllers.count <= 1) {
        return nil;
    }
    return self.navigationController.viewControllers[[self.navigationController.viewControllers indexOfObject:self]-1];
    
}

- (UIViewController *)mws_nextViewController {
    if (self.navigationController.topViewController == self) {
        return nil;
    }
    return self.navigationController.viewControllers[[self.navigationController.viewControllers indexOfObject:self]+1];
}

@end
