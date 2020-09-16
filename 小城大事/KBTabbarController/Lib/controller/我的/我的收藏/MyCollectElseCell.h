//
//  MyCollectElseCell.h
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/7/1.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MyCollectElseCell;
@protocol MyCollectElseCellDelegate <NSObject>
@optional

- (void)clickElseDeleteBtn:(UIButton *)button cell:(MyCollectElseCell *)cell;
@end

@interface MyCollectElseCell : UITableViewCell
@property (weak, nonatomic) id<MyCollectElseCellDelegate>delegate;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * detailLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UIButton * deleteBtn;
@property (nonatomic, strong) NSDictionary * dic;

@end

NS_ASSUME_NONNULL_END
