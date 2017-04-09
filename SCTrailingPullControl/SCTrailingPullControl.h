//
//  SCTrailingPullControl.h
//  SCTrailingPullControl
//
//  Created by ShannonChen on 2017/4/9.
//  Copyright © 2017年 ShannonChen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SCTrailingPullControlHandler)();

typedef NS_ENUM(NSInteger, SCTrailingPullControlState) {
    SCTrailingPullControlStateNormal,       // 普通状态
    SCTrailingPullControlStatePulling,      // 释放即可触发回调事件
    SCTrailingPullControlStateReleased,     // 释放并触发回调事件
};

NS_ASSUME_NONNULL_BEGIN

@interface SCTrailingPullControl : UIView

@property (nonatomic, assign) SCTrailingPullControlState state;

@property (nonatomic, weak, readonly) UIScrollView *scrollView;

@property (nonatomic, copy, nullable) SCTrailingPullControlHandler pullHandler;

@property (assign, nonatomic) CGFloat pullingPercent;


/// 构造方法创建 SCTrailingPullControl，默认设置了 frame
+ (instancetype)controlWithPullHandler:(SCTrailingPullControlHandler)handler;

@end


NS_ASSUME_NONNULL_END
