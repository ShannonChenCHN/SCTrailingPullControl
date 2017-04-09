//
//  UIView+SCTrailingPullControl.m
//  SCTrailingPullControl
//
//  Created by ShannonChen on 2017/4/9.
//  Copyright © 2017年 ShannonChen. All rights reserved.
//

#import "UIView+SCTrailingPullControl.h"

@implementation UIView (SCTrailingPullControl)

- (void)setSc_x:(CGFloat)sc_x {
    CGRect frame = self.frame;
    frame.origin.x = sc_x;
    self.frame = frame;
}

- (CGFloat)sc_x {
    return self.frame.origin.x;
}

- (void)setSc_y:(CGFloat)sc_y {
    CGRect frame = self.frame;
    frame.origin.y = sc_y;
    self.frame = frame;
}

- (CGFloat)sc_y {
    return self.frame.origin.y;
}

- (void)setSc_width:(CGFloat)sc_width {
    CGRect frame = self.frame;
    frame.size.width = sc_width;
    self.frame = frame;
}

- (CGFloat)sc_width {
    return self.frame.size.width;
}

- (void)setSc_height:(CGFloat)sc_height {
    CGRect frame = self.frame;
    frame.size.height = sc_height;
    self.frame = frame;
}

- (CGFloat)sc_height {
    return self.frame.size.height;
}

@end
