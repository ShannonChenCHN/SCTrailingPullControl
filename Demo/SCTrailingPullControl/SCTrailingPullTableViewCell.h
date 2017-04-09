//
//  SCTrailingPullTableViewCell.h
//  SCTrailingPullControl
//
//  Created by ShannonChen on 2017/4/9.
//  Copyright © 2017年 ShannonChen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SCChallengeTalentTaskCellTrailingPullBlock) (void);

@interface SCTrailingPullTableViewCell : UITableViewCell

@property (copy, nonatomic) SCChallengeTalentTaskCellTrailingPullBlock trailingPullBlock;  ///< 左拉查看更多

- (void)reloadData;

@end
