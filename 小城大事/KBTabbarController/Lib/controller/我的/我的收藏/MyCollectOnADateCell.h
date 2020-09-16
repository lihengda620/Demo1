//
//  MyCollectOnADateCell.h
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/7/1.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MyCollectOnADateCell;
@protocol MyCollectOnADateCellCellDelegate <NSObject>
@optional

- (void)clickOnADateDeleteBtn:(UIButton *)button cell:(MyCollectOnADateCell *)cell;
@end

@interface MyCollectOnADateCell : UITableViewCell
@property (weak, nonatomic) id<MyCollectOnADateCellCellDelegate>delegate;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * typeLabel;
@property (nonatomic, strong) UILabel * detailLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UIButton * deleteBtn;
@property (nonatomic, strong) UIView * buttonBGView;
@property (nonatomic, strong) NSDictionary * dic;

@end

NS_ASSUME_NONNULL_END
