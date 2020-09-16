//
//  MyCollectLivesCell.h
//  KBTabbarController
//
//  Created by CHUANGSHENG on 2019/7/25.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MyCollectLivesCell;
@protocol MyCollectLivesCellDelegate <NSObject>
@optional

- (void)clickLivesDeleteBtn:(UIButton *)button cell:(MyCollectLivesCell *)cell;
@end

@interface MyCollectLivesCell : UITableViewCell
@property (weak, nonatomic) id<MyCollectLivesCellDelegate>delegate;
@property (nonatomic, strong) UIImageView * cellImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * detailLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UIButton * deleteBtn;
@property (nonatomic, strong) UIView * buttonBGView;
@property (nonatomic, strong) NSDictionary * dic;

@end

NS_ASSUME_NONNULL_END
