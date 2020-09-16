//
//  RecommendedCell.h
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/6/26.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecommendedCell : UITableViewCell

@property (nonatomic, strong) UITextView * titleTextView;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UIImageView * cellImageView;
@property (nonatomic, strong) NSDictionary * dic;

@end

NS_ASSUME_NONNULL_END
