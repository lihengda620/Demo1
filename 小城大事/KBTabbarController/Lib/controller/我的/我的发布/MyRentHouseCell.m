//
//  MyRentHouseCell.m
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/6/29.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "MyRentHouseCell.h"

@implementation MyRentHouseCell

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
        self.cellImageView = [FlanceTools imageViewCreateViewWithFrame:CGRectMake(FitSizeW(15), FitSizeH(22), FitSizeW(115), FitSizeH(80)) ImageName:@"bannerzanwei"];
        self.cellImageView.layer.masksToBounds = YES;
        self.cellImageView.layer.cornerRadius = 5;
        self.cellImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.cellImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        [self.contentView addSubview:self.cellImageView];
        
        self.titleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(CGRectGetMaxX(self.cellImageView.frame) + FitSizeW(10), CGRectGetMinY(self.cellImageView.frame), FitSizeW(100), FitSizeH(20)) Font:16 IsBold:YES Text:@"" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
        [self.contentView addSubview:self.titleLabel];
        
        self.specificationsLabel = [FlanceTools labelCreateWithFrame:CGRectMake(CGRectGetMaxX(self.cellImageView.frame) + FitSizeW(10), CGRectGetMidY(self.cellImageView.frame) - FitSizeH(10), FitSizeW(300), FitSizeH(20)) Font:14 IsBold:NO Text:@"" Color:RGBA(150, 150, 150, 1.0) Direction:NSTextAlignmentLeft];
        [self.contentView addSubview:self.specificationsLabel];
        
        self.addressLabel = [FlanceTools labelCreateWithFrame:CGRectMake(CGRectGetMaxX(self.cellImageView.frame) + FitSizeW(10), CGRectGetMaxY(self.cellImageView.frame) - FitSizeH(20), FitSizeW(280), FitSizeH(20)) Font:14 IsBold:NO Text:@"" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
        [self.contentView addSubview:self.addressLabel];
        
        self.priceLabel = [FlanceTools labelCreateWithFrame:CGRectMake(SCREEN_WIDTH - FitSizeW(200), CGRectGetMidY(self.titleLabel.frame) - FitSizeH(15), FitSizeW(185), FitSizeH(30)) Font:20 IsBold:NO Text:@"" Color:RGBA(238, 82, 82, 1) Direction:NSTextAlignmentRight];
        [self.contentView addSubview:self.priceLabel];
        
        UIView * lineView1 = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeH(15), FitSizeH(119), FitSizeW(345), FitSizeH(1)) BgColor:RGBA(245, 245, 245, 1.0) BgImage:nil];
        [self.contentView addSubview:lineView1];
        
        self.dingBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(222), CGRectGetMaxY(lineView1.frame) + FitSizeH(9), FitSizeW(22), FitSizeH(22)) Title:@"顶" Font:14 IsBold:YES TitleColor:RGBA(230, 43, 53, 1.0) TitleSelectColor:RGBA(230, 43, 53, 1.0) ImageName:nil Target:self Action:@selector(clickRentHouseTopBtn:)];
        self.dingBtn.layer.borderWidth = FitSizeW(0.8);
        self.dingBtn.layer.cornerRadius = 2.5;
        self.dingBtn.layer.masksToBounds = YES;
        self.dingBtn.layer.borderColor = [RGBA(230, 43, 53, 1.0)CGColor];
        [self.contentView addSubview:self.dingBtn];
        
        self.editBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(10) + CGRectGetMaxX(self.dingBtn.frame), CGRectGetMaxY(lineView1.frame) + FitSizeH(9), FitSizeW(44), FitSizeH(22)) Title:@"编辑" Font:14 IsBold:YES TitleColor:RGBA(80, 80, 80, 1.0) TitleSelectColor:RGBA(80, 80, 80, 1.0) ImageName:nil Target:self Action:@selector(clickRentHouseEditBtn:)];
        self.editBtn.layer.borderWidth = FitSizeW(0.8);
        self.editBtn.layer.cornerRadius = 2.5;
        self.editBtn.layer.masksToBounds = YES;
        self.editBtn.layer.borderColor = [RGBA(110, 110, 110, 1.0)CGColor];
        [self.contentView addSubview:self.editBtn];
        
        self.deleteBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(10) + CGRectGetMaxX(self.editBtn.frame), CGRectGetMaxY(lineView1.frame) + FitSizeH(9), FitSizeW(44), FitSizeH(22)) Title:@"删除" Font:14 IsBold:YES TitleColor:RGBA(80, 80, 80, 1.0) TitleSelectColor:RGBA(80, 80, 80, 1.0) ImageName:nil Target:self Action:@selector(clickRentHouseDeleteBtn:)];
        self.deleteBtn.layer.borderWidth = FitSizeW(0.8);
        self.deleteBtn.layer.borderColor = [RGBA(110, 110, 110, 1.0)CGColor];
        self.deleteBtn.layer.cornerRadius = 2.5;
        self.deleteBtn.layer.masksToBounds = YES;
        [self.contentView addSubview:self.deleteBtn];
        
        UIView * lineView2 = [FlanceTools viewCreateWithFrame:CGRectMake(0, FitSizeH(167), SCREEN_WIDTH, FitSizeH(3)) BgColor:RGBA(245, 245, 245, 1.0) BgImage:nil];
        [self.contentView addSubview:lineView2];
    }
    return self;
}

- (void)clickRentHouseTopBtn:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickRentHouseTopBtn:cell:)]) {
        [self.delegate clickRentHouseTopBtn:button cell:self];
    }
}

- (void)clickRentHouseEditBtn:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickRentHouseEditBtn:cell:)]) {
        [self.delegate clickRentHouseEditBtn:button cell:self];
    }
}

- (void)clickRentHouseDeleteBtn:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickRentHouseDeleteBtn:cell:)]) {
        [self.delegate clickRentHouseDeleteBtn:button cell:self];
    }
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
    
    self.specificationsLabel.text = [NSString stringWithFormat:@"%@  %@平",[self.dic objectForKey:@"layout"],[self.dic objectForKey:@"space"]];
    
    self.priceLabel.text = [NSString stringWithFormat:@"%@元",[self.dic objectForKey:@"rental"]];
    
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@",[self.dic objectForKey:@"province"],[self.dic objectForKey:@"city"],[self.dic objectForKey:@"area"]];
    
    //是否显示置顶
    NSString * isZhiDing = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"tops"]];
    if ([isZhiDing isEqualToString:@"1"]) {
        //显示
        self.dingBtn.hidden = NO;
    }else{
        self.dingBtn.hidden = YES;
    }
}

@end
