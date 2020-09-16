//
//  MyCollectRentHouseCell.h
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/7/1.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MyCollectRentHouseCell;
@protocol MyCollectRentHouseCellDelegate <NSObject>
@optional

- (void)clickRentHouseDeleteBtn:(UIButton *)button cell:(MyCollectRentHouseCell *)cell;
@end

@interface MyCollectRentHouseCell : UITableViewCell
@property (weak, nonatomic) id<MyCollectRentHouseCellDelegate>delegate;
@property (nonatomic, strong) UIImageView * cellImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * specificationsLabel;
@property (nonatomic, strong) UILabel * addressLabel;
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UIButton * deleteBtn;
@property (nonatomic, strong) NSDictionary * dic;

@end

NS_ASSUME_NONNULL_END
