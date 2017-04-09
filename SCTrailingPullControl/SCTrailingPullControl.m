//
//  SCTrailingPullControl.m
//  SCTrailingPullControl
//
//  Created by ShannonChen on 2017/4/9.
//  Copyright © 2017年 ShannonChen. All rights reserved.
//

#import "SCTrailingPullControl.h"
#import "UIView+SCTrailingPullControl.h"


#define kStateTitleFont  [UIFont systemFontOfSize:14]
#define kStateTitleColor [UIColor blackColor]


NSString *const SCTrailingPullControlNormalText = @"滑动查看更多内容";
NSString *const SCTrailingPullControlPullingText = @"释放查看更多内容";

NSString *const SCTrailingPullControlKeyPathContentOffset = @"contentOffset";
NSString *const SCTrailingPullControlKeyPathContentSize = @"contentSize";

@interface SCTrailingPullControl ()

@property (assign, nonatomic) CGFloat insetTDelta;

@property (strong, nonatomic) NSMutableDictionary <NSNumber *, NSString *>*stateTitles;
@property (strong, nonatomic) UILabel *stateLabel;
@property (strong, nonatomic) UIImageView *arrowView;

@end

@implementation SCTrailingPullControl

+ (instancetype)controlWithPullHandler:(SCTrailingPullControlHandler)handler {
    SCTrailingPullControl *control = [[SCTrailingPullControl alloc] init];
    control.pullHandler = handler;
    
    return control;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 准备工作
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = [UIColor clearColor];
        
        // 设置宽度
        self.sc_width = 70;
        
        // 默认是普通状态
        self.state = SCTrailingPullControlStateNormal;
        
        
        // 初始化文字
        [self setTitle:SCTrailingPullControlNormalText forState:SCTrailingPullControlStateNormal];
        [self setTitle:SCTrailingPullControlPullingText forState:SCTrailingPullControlStatePulling];
        [self setTitle:SCTrailingPullControlNormalText forState:SCTrailingPullControlStateReleased];
        
        // 添加子控件
        [self addSubview:self.arrowView];
        [self addSubview:self.stateLabel];
    }
    return self;
}


/*
 * When a view is removed from a superview, the system sends willMoveToSuperview: to the view. The parameter is nil.
 * http://stackoverflow.com/questions/25996906/willmovetosuperview-is-called-twice
 */
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    // 旧的父控件移除监听
    [self resignObserverOfScrollView];
    
    if (newSuperview) { // 新的父控件
        // 设置高度
        self.sc_height = newSuperview.sc_height;
        // 设置位置
        self.sc_y = 0;
        
        
        _scrollView = (UIScrollView *)newSuperview;
        _scrollView.alwaysBounceHorizontal = YES;
        
        // 添加监听
        [self becomeObserverOfScrollView];
    }
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
}

#pragma mark - KVO监听
- (void)becomeObserverOfScrollView {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:SCTrailingPullControlKeyPathContentOffset options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:SCTrailingPullControlKeyPathContentSize options:options context:nil];
}

- (void)resignObserverOfScrollView {
    [self.superview removeObserver:self forKeyPath:SCTrailingPullControlKeyPathContentOffset];
    [self.superview removeObserver:self forKeyPath:SCTrailingPullControlKeyPathContentSize];;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // 遇到这些情况就直接返回
    if (!self.userInteractionEnabled) return;
    
    // 这个就算看不见也需要处理
    if ([keyPath isEqualToString:SCTrailingPullControlKeyPathContentSize]) {
        [self scrollViewContentSizeDidChange:change];
    }
    
    // 看不见
    if (self.hidden) return;
    if ([keyPath isEqualToString:SCTrailingPullControlKeyPathContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    // 当前的contentOffset
    CGFloat offsetX = self.scrollView.contentOffset.x;
    
    // 控件刚好出现的 offsetX
    CGFloat triggerOffsetX = self.scrollView.contentSize.width - self.scrollView.sc_width + self.scrollView.contentInset.left;
    
    // 如果是向➡️滑动到看不见控件，直接返回
    if (offsetX <= triggerOffsetX) return;
    
    // 普通 和 即将触发 的临界点
    CGFloat normal2pullingOffsetX = triggerOffsetX + self.sc_width;
    CGFloat pullingPercent = (offsetX - triggerOffsetX) / self.sc_width;
    
    if (self.scrollView.isDragging) { // 如果正在拖拽
        self.pullingPercent = pullingPercent;
        if (self.state == SCTrailingPullControlStateNormal && offsetX > normal2pullingOffsetX) { // 释放即可触发
            self.state = SCTrailingPullControlStatePulling;
            
            
        } else if (self.state == SCTrailingPullControlStatePulling && offsetX <= normal2pullingOffsetX) { // 重新变为普通状态
            self.state = SCTrailingPullControlStateNormal;
            
            
        }
    } else if (self.state == SCTrailingPullControlStatePulling) { // 即将触发 && 手松开
        // 开始刷新
        self.pullingPercent = 1.0;
        self.state = SCTrailingPullControlStateReleased;
        
        
    } else if (pullingPercent < 1) {
        
        self.pullingPercent = pullingPercent;
    }
    
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change{
    // contentSize 变化时，调整位置
    self.sc_x = self.scrollView.contentSize.width;
}

- (void)setTitle:(NSString *)title forState:(SCTrailingPullControlState)state {
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
}

#pragma mark - 内部方法
- (void)executePullingHandler
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.pullHandler) {
            self.pullHandler();
        }
    });
    
    self.state = SCTrailingPullControlStateNormal;
}

- (void)setState:(SCTrailingPullControlState)state {
    SCTrailingPullControlState oldState = self.state;
    if (state == oldState) return;
    _state = state;
    
    
    // 设置状态文字
    self.stateLabel.text = self.stateTitles[@(state)];
    
    // 根据状态做事情
    if (state == SCTrailingPullControlStateNormal) {
        if (oldState == SCTrailingPullControlStateReleased) {   // 由释放状态到普通状态
            self.pullingPercent = 0.0;
            self.arrowView.transform = CGAffineTransformIdentity;
            
        } else {  // 有其他状态变成普通状态self.arrowView.hidden = NO;
            [UIView animateWithDuration:0.25 animations:^{
                self.arrowView.transform = CGAffineTransformIdentity;
            }];
            
        }
        
    } else if (state == SCTrailingPullControlStatePulling) {  // 由其他状态到即将触发状态
        
        [UIView animateWithDuration:0.25 animations:^{
            self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
        }];
        
    } else if (state == SCTrailingPullControlStateReleased) {  // 由其他状态到释放状态
        [self executePullingHandler];
        
    }
    
    
}

#pragma mark - Lazy Initialization
- (NSMutableDictionary<NSNumber *,NSString *> *)stateTitles {
    if (!_stateTitles) {
        _stateTitles = [NSMutableDictionary dictionary];
    }
    return _stateTitles;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 30, self.sc_height)];
        _stateLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _stateLabel.numberOfLines = 0;
        _stateLabel.font = kStateTitleFont;
        _stateLabel.textAlignment = NSTextAlignmentLeft;
        _stateLabel.textColor = kStateTitleColor;
    }
    return _stateLabel;
}

- (UIImageView *)arrowView {
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pull_arrow"]];
        _arrowView.contentMode = UIViewContentModeScaleAspectFill;
        _arrowView.frame = CGRectMake(0, (self.sc_height - 10) * 0.5, 20, 10);
        _arrowView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    return _arrowView;
}

@end
