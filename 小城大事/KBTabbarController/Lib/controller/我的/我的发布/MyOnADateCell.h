//
//  MyOnADateCell.h
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/6/29.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MyOnADateCell;
@protocol MyOnADateCellDelegate <NSObject>
@optional
- (void)clickOnADateTopBtn:(UIButton *)button cell:(MyOnADateCell *)cell;

- (void)clickOnADatelEditBtn:(UIButton *)button cell:(MyOnADateCell *)cell;

- (void)clickOnADateDeleteBtn:(UIButton *)button cell:(MyOnADateCell *)cell;

@end

@interface MyOnADateCell : UITableViewCell

@property (weak, nonatomic) id<MyOnADateCellDelegate>delegate;

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * typeLabel;
@property (nonatomic, strong) UILabel * detailLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UIView * buttonBGView;
@property (nonatomic, strong) UIButton * dingBtn;
@property (nonatomic, strong) UIButton * editBtn;
@property (nonatomic, strong) UIButton * deleteBtn;

@property (nonatomic, strong) NSDictionary * dic;

@end

NS_ASSUME_NONNULL_END
