//
//  MyBuySellTableViewCell.h
//  KBTabbarController
//
//  Created by CHUANGSHENG on 2019/7/4.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MyBuySellTableViewCell;
@protocol MyBuySellTableViewCellDelegate <NSObject>
@optional
- (void)clickBuySellTopBtn:(UIButton *)button cell:(MyBuySellTableViewCell *)cell;

- (void)clickBuySellEditBtn:(UIButton *)button cell:(MyBuySellTableViewCell *)cell;

- (void)clickBuySellDeleteBtn:(UIButton *)button cell:(MyBuySellTableViewCell *)cell;

@end

@interface MyBuySellTableViewCell : UITableViewCell

@property (weak, nonatomic) id<MyBuySellTableViewCellDelegate>delegate;

@property (nonatomic, strong) UIImageView * cellImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * priceLabel;

@property (nonatomic, strong) UIButton * dingBtn;
@property (nonatomic, strong) UIButton * editBtn;
@property (nonatomic, strong) UIButton * deleteBtn;

@property (nonatomic, strong) NSDictionary * dic;

@end

NS_ASSUME_NONNULL_END
