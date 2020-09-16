//
//  RentHouseCell.h
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/6/26.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RentHouseCell : UITableViewCell

@property (nonatomic, strong) UIImageView * cellImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * specificationsLabel;
@property (nonatomic, strong) UILabel * addressLabel;
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) NSDictionary * dic;

@end

NS_ASSUME_NONNULL_END
