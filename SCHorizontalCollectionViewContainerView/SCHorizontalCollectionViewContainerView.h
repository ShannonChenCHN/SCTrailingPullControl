//
//  SCHorizontalCollectionViewContainerView.h
//  SCTrailingPullControl
//
//  Created by ShannonChen on 2017/4/9.
//  Copyright © 2017年 ShannonChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCHorizontalCollectionViewContainerView;


NS_ASSUME_NONNULL_BEGIN

@protocol SCHorizontalCollectionViewContainerViewProtocol <NSObject>

// cell 展示
- (UICollectionViewCell *)collectionViewContainerView:(SCHorizontalCollectionViewContainerView *)containerView cellForItemAtIndex:(NSInteger)index;

@optional
// 点击 cell
- (void)collectionViewContainerView:(SCHorizontalCollectionViewContainerView *)containerView didSelectItemAtIndex:(NSInteger)index;

// 停止滑动时的水平位移
- (void)collectionViewContainerView:(SCHorizontalCollectionViewContainerView *)containerView didStopScrollingWithContentOffset:(CGFloat)offset;

@end



/**
 水平滚动的卡片列表
 */
@interface SCHorizontalCollectionViewContainerView : UIView


@property (weak, nonatomic, nullable) id <SCHorizontalCollectionViewContainerViewProtocol> delegate;
@property (strong, nonatomic, readonly) UICollectionView *collectionView;

@property (assign, nonatomic) CGSize itemSize;              ///< item 尺寸
@property (assign, nonatomic) NSUInteger numberOfItems;     ///< item 个数
@property (assign, nonatomic) CGFloat interitemSpacing;     ///< item 间距
@property (assign, nonatomic) UIEdgeInsets contentInsets;   ///< 上下左右边距

- (void)registerCollectionViewCellClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index;

/// 刷新数据
- (void)reloadData;

@end


NS_ASSUME_NONNULL_END
