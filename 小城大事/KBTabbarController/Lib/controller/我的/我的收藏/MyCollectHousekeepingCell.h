//
//  MyCollectHousekeepingCell.h
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/7/1.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MyCollectHousekeepingCell;
@protocol MyCollectHousekeepingCellDelegate <NSObject>
@optional

- (void)clickHousekeepingDeleteBtn:(UIButton *)button cell:(MyCollectHousekeepingCell *)cell;
@end

@interface MyCollectHousekeepingCell : UITableViewCell
@property (weak, nonatomic) id<MyCollectHousekeepingCellDelegate>delegate;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * typeLabel;
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UILabel * companyNamelabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UIButton * deleteBtn;
@property (nonatomic, strong) UIView * buttonBGView;
@property (nonatomic, strong) NSDictionary * dic;

@end

NS_ASSUME_NONNULL_END
