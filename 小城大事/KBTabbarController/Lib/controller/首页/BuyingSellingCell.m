//
//  BuyingSellingCell.m
//  KBTabbarController
//
//  Created by CHUANGSHENG on 2019/7/15.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "BuyingSellingCell.h"

@implementation BuyingSellingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellImageView = [FlanceTools imageViewCreateViewWithFrame:CGRectMake(FitSizeW(15), FitSizeH(22), FitSizeW(115), FitSizeH(80)) ImageName:@""];
        self.cellImageView.layer.masksToBounds = YES;
        self.cellImageView.layer.cornerRadius = 5;
        self.cellImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.cellImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        [self.contentView addSubview:self.cellImageView];
        
        self.titleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(CGRectGetMaxX(self.cellImageView.frame) + FitSizeW(15), CGRectGetMinY(self.cellImageView.frame), FitSizeW(210), FitSizeH(50)) Font:14 IsBold:YES Text:@"" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
        [self.contentView addSubview:self.titleLabel];
        
        self.priceLabel = [FlanceTools labelCreateWithFrame:CGRectMake(CGRectGetMaxX(self.cellImageView.frame)+ FitSizeW(15), CGRectGetMaxY(self.cellImageView.frame) - FitSizeH(30), FitSizeW(280), FitSizeH(30)) Font:20 IsBold:NO Text:@"" Color:RGBA(238, 82, 82, 1) Direction:NSTextAlignmentLeft];
        [self.contentView addSubview:self.priceLabel];
        
        UIView * lineView = [FlanceTools viewCreateWithFrame:CGRectMake(0, FitSizeH(127), SCREEN_WIDTH, FitSizeH(3)) BgColor:RGBA(245, 245, 245, 1.0) BgImage:nil];
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSString * imageStr = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"image"]];
    NSArray *imageArr = [imageStr componentsSeparatedByString:@","];
    if (imageArr.count > 0) {
        [self.cellImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",RBDom,imageArr[0]]] placeholderImage:[UIImage imageNamed:@"bannerzanwei"]];
    }
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"name"]];
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[self.dic objectForKey:@"price"]];
}

@end
