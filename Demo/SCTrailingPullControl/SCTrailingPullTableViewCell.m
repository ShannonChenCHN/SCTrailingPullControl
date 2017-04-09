//
//  SCTrailingPullTableViewCell.m
//  SCTrailingPullControl
//
//  Created by ShannonChen on 2017/4/9.
//  Copyright © 2017年 ShannonChen. All rights reserved.
//

#import "SCTrailingPullTableViewCell.h"
#import "SCTrailingPullCollectionViewCell.h"

#import "SCHorizontalCollectionViewContainerView.h"
#import "UIScrollView+SCTrailingPullControl.h"

#define kSingleImageSize    CGSizeMake(157, 90)
#define kItemSize           kSingleImageSize

@interface SCTrailingPullTableViewCell () <SCHorizontalCollectionViewContainerViewProtocol>

@property (strong, nonatomic) SCHorizontalCollectionViewContainerView *containerView;

@end

@implementation SCTrailingPullTableViewCell

static NSString * const kSCTrailingPullCollectionViewCellID = @"kSCTrailingPullCollectionViewCellID";

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.exclusiveTouch = YES;
        
        
        [self.containerView registerCollectionViewCellClass:[SCTrailingPullCollectionViewCell class] forCellWithReuseIdentifier:kSCTrailingPullCollectionViewCellID];
        [self addSubview:self.containerView];
        
        // 左拉进入下一页
        __weak typeof(self) weakSelf = self;
        self.containerView.collectionView.sc_trailingPullControl = [SCTrailingPullControl controlWithPullHandler:^{
            if (weakSelf.trailingPullBlock) {
                weakSelf.trailingPullBlock();
            }
        }];
        self.containerView.collectionView.sc_trailingPullControl.hidden = YES;
        
        
    }
    return self;
}

#pragma mark - <SCHorizontalCollectionViewContainerViewProtocol>
// item 展示
- (UICollectionViewCell *)collectionViewContainerView:(SCHorizontalCollectionViewContainerView *)containerView cellForItemAtIndex:(NSInteger)index {
    
    SCTrailingPullCollectionViewCell *cell = [containerView dequeueReusableCellWithReuseIdentifier:kSCTrailingPullCollectionViewCellID forIndex:index];
    cell.backgroundColor = index % 2 ? [UIColor redColor] : [UIColor blueColor];
    
    return cell;
}

// 选中 item
- (void)collectionViewContainerView:(SCHorizontalCollectionViewContainerView *)containerView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"点击了第 %li 个 cell", index);
}

#pragma mark - Public Methods
- (void)reloadData {
    self.containerView.numberOfItems = 5;
    self.containerView.collectionView.sc_trailingPullControl.hidden = NO;
    [self.containerView reloadData];
}

#pragma mark - Lazy initialization
- (SCHorizontalCollectionViewContainerView *)containerView {
    if (!_containerView) {
        _containerView = [[SCHorizontalCollectionViewContainerView alloc] initWithFrame:self.bounds];
        _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _containerView.delegate = self;
        _containerView.itemSize = kItemSize;
        _containerView.interitemSpacing = 15;
        _containerView.contentInsets = UIEdgeInsetsMake(0, 15, 15, 15);
        _containerView.collectionView.scrollsToTop = NO;
    }
    return _containerView;
}


@end
