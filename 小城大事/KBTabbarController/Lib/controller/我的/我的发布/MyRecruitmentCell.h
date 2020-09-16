//
//  MyRecruitmentCell.h
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/6/29.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MyRecruitmentCell;
@protocol MyRecruitmentCellDelegate <NSObject>
@optional
- (void)clickRecruitmentTopBtn:(UIButton *)button cell:(MyRecruitmentCell *)cell;

- (void)clickRecruitmentEditBtn:(UIButton *)button cell:(MyRecruitmentCell *)cell;

- (void)clickRecruitmentDeleteBtn:(UIButton *)button cell:(MyRecruitmentCell *)cell;
@end

@interface MyRecruitmentCell : UITableViewCell
@property (weak, nonatomic) id<MyRecruitmentCellDelegate>delegate;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * typeLabel;
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UILabel * companyNamelabel;
@property (nonatomic, strong) UILabel * personNumLabel;
@property (nonatomic, strong) UIView * buttonBGView;
@property (nonatomic, strong) UIButton * dingBtn;
@property (nonatomic, strong) UIButton * editBtn;
@property (nonatomic, strong) UIButton * deleteBtn;
@property (nonatomic, strong) NSDictionary * dic;

@end

NS_ASSUME_NONNULL_END
