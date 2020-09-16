//
//  MyHousekeepingCell.h
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/6/29.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MyHousekeepingCell;
@protocol MyHousekeepingCellDelegate <NSObject>
@optional
- (void)clickHousekeepingTopBtn:(UIButton *)button cell:(MyHousekeepingCell *)cell;

- (void)clickHousekeepingEditBtn:(UIButton *)button cell:(MyHousekeepingCell *)cell;

- (void)clickHousekeepingDeleteBtn:(UIButton *)button cell:(MyHousekeepingCell *)cell;
@end

@interface MyHousekeepingCell : UITableViewCell
@property (weak, nonatomic) id<MyHousekeepingCellDelegate>delegate;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * typeLabel;
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UILabel * companyNamelabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UIView * buttonBGView;
@property (nonatomic, strong) UIButton * dingBtn;
@property (nonatomic, strong) UIButton * editBtn;
@property (nonatomic, strong) UIButton * deleteBtn;

@property (nonatomic, strong) NSDictionary * dic;

@end

NS_ASSUME_NONNULL_END
