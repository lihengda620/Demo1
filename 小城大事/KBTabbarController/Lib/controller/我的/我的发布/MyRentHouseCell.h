//
//  MyRentHouseCell.h
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/6/29.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MyRentHouseCell;
@protocol MyRentHouseCellDelegate <NSObject>
@optional
- (void)clickRentHouseTopBtn:(UIButton *)button cell:(MyRentHouseCell *)cell;

- (void)clickRentHouseEditBtn:(UIButton *)button cell:(MyRentHouseCell *)cell;

- (void)clickRentHouseDeleteBtn:(UIButton *)button cell:(MyRentHouseCell *)cell;

@end

@interface MyRentHouseCell : UITableViewCell

@property (weak, nonatomic) id<MyRentHouseCellDelegate>delegate;

@property (nonatomic, strong) UIImageView * cellImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * specificationsLabel;
@property (nonatomic, strong) UILabel * addressLabel;
@property (nonatomic, strong) UILabel * priceLabel;

@property (nonatomic, strong) UIButton * dingBtn;
@property (nonatomic, strong) UIButton * editBtn;
@property (nonatomic, strong) UIButton * deleteBtn;

@property (nonatomic, strong) NSDictionary * dic;

@end

NS_ASSUME_NONNULL_END
