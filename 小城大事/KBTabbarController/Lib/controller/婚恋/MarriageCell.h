//
//  MarriageCell.h
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/6/27.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MarriageCell : UITableViewCell
@property (nonatomic, strong) UIImageView * cellImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * detailLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UIView * buttonBGView;
@property (nonatomic, strong) NSDictionary * dic;

@end

NS_ASSUME_NONNULL_END
