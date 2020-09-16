//
//  MyCollecBaySellCell.h
//  KBTabbarController
//
//  Created by CHUANGSHENG on 2019/7/4.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MyCollecBaySellCell;
@protocol MyCollecBaySellCellDelegate <NSObject>
@optional

- (void)clickBaySellDeleteBtn:(UIButton *)button cell:(MyCollecBaySellCell *)cell;
@end

@interface MyCollecBaySellCell : UITableViewCell
@property (weak, nonatomic) id<MyCollecBaySellCellDelegate>delegate;
@property (nonatomic, strong) UIImageView * cellImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UIButton * deleteBtn;
@property (nonatomic, strong) NSDictionary * dic;

@end

NS_ASSUME_NONNULL_END
