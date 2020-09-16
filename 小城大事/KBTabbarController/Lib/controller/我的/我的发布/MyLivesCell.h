//
//  MyLivesCell.h
//  KBTabbarController
//
//  Created by CHUANGSHENG on 2019/7/16.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MyLivesCell;
@protocol MyLivesCellDelegate <NSObject>
@optional
- (void)clickLivesTopBtn:(UIButton *)button cell:(MyLivesCell *)cell;

- (void)clickLivesEditBtn:(UIButton *)button cell:(MyLivesCell *)cell;

- (void)clickLivesDeleteBtn:(UIButton *)button cell:(MyLivesCell *)cell;

@end

@interface MyLivesCell : UITableViewCell
@property (weak, nonatomic) id<MyLivesCellDelegate>delegate;
@property (nonatomic, strong) UIImageView * cellImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * detailLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UIView * buttonBGView;
@property (nonatomic, strong) UIButton * dingBtn;
@property (nonatomic, strong) UIButton * editBtn;
@property (nonatomic, strong) UIButton * deleteBtn;


@property (nonatomic, strong) NSDictionary * dic;

@end

NS_ASSUME_NONNULL_END
