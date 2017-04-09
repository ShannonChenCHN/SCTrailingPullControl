//
//  SCHorizontalCollectionViewContainerView.m
//  SCTrailingPullControl
//
//  Created by ShannonChen on 2017/4/9.
//  Copyright © 2017年 ShannonChen. All rights reserved.
//

#import "SCHorizontalCollectionViewContainerView.h"


@interface SCHorizontalCollectionViewContainerView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (strong, nonatomic, readwrite) UICollectionView *collectionView;

@end



@implementation SCHorizontalCollectionViewContainerView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initial setup
        _itemSize = CGSizeZero;
        _numberOfItems = 0;
        _interitemSpacing = 0;
        _contentInsets = UIEdgeInsetsZero;
        
        // Add subviews
        [self addSubview:self.collectionView];
        
    }
    return self;
}

- (void)registerCollectionViewCellClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma mark  <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.numberOfItems;
}

// cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(collectionViewContainerView:cellForItemAtIndex:)]) {
        return [self.delegate collectionViewContainerView:self cellForItemAtIndex:indexPath.row];
    }
    return [[UICollectionViewCell alloc] init];
}

#pragma mark <UICollectionViewDelegate>
// 点击cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionViewContainerView:didSelectItemAtIndex:)]) {
        [self.delegate collectionViewContainerView:self didSelectItemAtIndex:indexPath.row];
    }
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.itemSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.interitemSpacing;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return self.contentInsets;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self p_invokeScrollingEndingCallback];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self p_invokeScrollingEndingCallback];
    }
}

#pragma mark - Private methods
- (void)p_invokeScrollingEndingCallback {
    if ([self.delegate respondsToSelector:@selector(collectionViewContainerView:didStopScrollingWithContentOffset:)]) {
        [self.delegate collectionViewContainerView:self didStopScrollingWithContentOffset:self.collectionView.contentOffset.x];
    }
}

#pragma mark - Lazy Initialization
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = ({
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        });
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

@end
