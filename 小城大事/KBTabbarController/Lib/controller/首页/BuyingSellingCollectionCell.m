//
//  BuyingSellingCollectionCell.m
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/6/26.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "BuyingSellingCollectionCell.h"

@implementation BuyingSellingCollectionCell

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.itmeImageView = [FlanceTools imageViewCreateViewWithFrame:CGRectMake(FitSizeW(6.5), 0, FitSizeW(164), FitSizeH(120)) ImageName:@""];
        self.itmeImageView.layer.cornerRadius = 5;
        self.itmeImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.itmeImageView];
        
        self.titleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(6.5), CGRectGetMaxY(self.itmeImageView.frame),FitSizeW(164), FitSizeH(50)) Font:14 IsBold:NO Text:@"" Color:RGBA(15, 15, 15, 1) Direction:NSTextAlignmentLeft];
        [self.contentView addSubview:self.titleLabel];
        
        self.priceLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(6.5), CGRectGetMaxY(self.titleLabel.frame),FitSizeW(164), FitSizeH(20)) Font:17 IsBold:YES Text:@"" Color:RGBA(238, 82, 82, 1) Direction:NSTextAlignmentLeft];
        [self.contentView addSubview:self.priceLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

@end
