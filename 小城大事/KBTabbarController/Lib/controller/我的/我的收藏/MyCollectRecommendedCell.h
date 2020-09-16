//
//  MyCollectRecommendedCell.h
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/7/1.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MyCollectRecommendedCell;
@protocol MyCollectRecommendedCellDelegate <NSObject>
@optional

- (void)clickRecommendedDeleteBtn:(UIButton *)button cell:(MyCollectRecommendedCell *)cell;
@end

@interface MyCollectRecommendedCell : UITableViewCell
@property (weak, nonatomic) id<MyCollectRecommendedCellDelegate>delegate;
@property (nonatomic, strong) UITextView * titleTextView;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UIImageView * cellImageView;
@property (nonatomic, strong) UIButton * deleteBtn;
@property (nonatomic, strong) NSDictionary * dic;

@end

NS_ASSUME_NONNULL_END
