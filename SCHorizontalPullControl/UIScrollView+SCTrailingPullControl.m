//
//  UIScrollView+SCTrailingPullControl.m
//  SCTrailingPullControl
//
//  Created by ShannonChen on 2017/4/9.
//  Copyright © 2017年 ShannonChen. All rights reserved.
//

#import "UIScrollView+SCTrailingPullControl.h"
#import <objc/runtime.h>

@implementation UIScrollView (SCTrailingPullControl)

static const char *SCTrailingPullControlKey = "SCTrailingPullControl";


- (void)setSc_trailingPullControl:(SCTrailingPullControl *)sc_trailingPullControl {
    
    if (sc_trailingPullControl != self.sc_trailingPullControl) {
        // 删除旧的，添加新的
        [self.sc_trailingPullControl removeFromSuperview];
        [self insertSubview:sc_trailingPullControl atIndex:0];
        
        // 存储新的
        objc_setAssociatedObject(self, &SCTrailingPullControlKey, sc_trailingPullControl, OBJC_ASSOCIATION_RETAIN);
    }
}

- (SCTrailingPullControl *)sc_trailingPullControl {
    return objc_getAssociatedObject(self, &SCTrailingPullControlKey);
}
@end
