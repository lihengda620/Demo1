//
//  MyElseCell.h
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/6/29.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MyElseCell;
@protocol MyElseCellDelegate <NSObject>
@optional
- (void)clickElseTopBtn:(UIButton *)button cell:(MyElseCell *)cell;

- (void)clickElseEditBtn:(UIButton *)button cell:(MyElseCell *)cell;

- (void)clickElseDeleteBtn:(UIButton *)button cell:(MyElseCell *)cell;

@end

@interface MyElseCell : UITableViewCell
@property (weak, nonatomic) id<MyElseCellDelegate>delegate;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * detailLabel;
@property (nonatomic, strong) UILabel * timeLabel;

@property (nonatomic, strong) UIButton * dingBtn;
@property (nonatomic, strong) UIButton * editBtn;
@property (nonatomic, strong) UIButton * deleteBtn;

@property (nonatomic, strong) NSDictionary * dic;

@end

NS_ASSUME_NONNULL_END
