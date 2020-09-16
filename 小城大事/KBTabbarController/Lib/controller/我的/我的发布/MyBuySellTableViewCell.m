//
//  MyBuySellTableViewCell.m
//  KBTabbarController
//
//  Created by CHUANGSHENG on 2019/7/4.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "MyBuySellTableViewCell.h"

@implementation MyBuySellTableViewCell

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
        
        self.titleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(CGRectGetMaxX(self.cellImageView.frame) + FitSizeW(15), CGRectGetMinY(self.cellImageView.frame), FitSizeW(210), FitSizeH(50)) Font:14 IsBold:YES Text:@"二手95新 三Galaxy S9（SM-G96 00）二手手机 夕雾紫 4G+64G全 网通" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
        [self.contentView addSubview:self.titleLabel];
        
        self.priceLabel = [FlanceTools labelCreateWithFrame:CGRectMake(CGRectGetMaxX(self.cellImageView.frame)+ FitSizeW(15), CGRectGetMaxY(self.cellImageView.frame) - FitSizeH(30), FitSizeW(280), FitSizeH(30)) Font:20 IsBold:NO Text:@"¥4779.00" Color:RGBA(238, 82, 82, 1) Direction:NSTextAlignmentLeft];
        [self.contentView addSubview:self.priceLabel];
        
        UIView * lineView1 = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeH(15), FitSizeH(119), FitSizeW(345), FitSizeH(1)) BgColor:RGBA(245, 245, 245, 1.0) BgImage:nil];
        [self.contentView addSubview:lineView1];
        
        self.dingBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(222), CGRectGetMaxY(lineView1.frame) + FitSizeH(9), FitSizeW(22), FitSizeH(22)) Title:@"顶" Font:14 IsBold:YES TitleColor:RGBA(230, 43, 53, 1.0) TitleSelectColor:RGBA(230, 43, 53, 1.0) ImageName:nil Target:self Action:@selector(clickBuySellTopBtn:)];
        self.dingBtn.layer.borderWidth = FitSizeW(0.8);
        self.dingBtn.layer.cornerRadius = 2.5;
        self.dingBtn.layer.masksToBounds = YES;
        self.dingBtn.layer.borderColor = [RGBA(230, 43, 53, 1.0)CGColor];
        [self.contentView addSubview:self.dingBtn];
        
        self.editBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(10) + CGRectGetMaxX(self.dingBtn.frame), CGRectGetMaxY(lineView1.frame) + FitSizeH(9), FitSizeW(44), FitSizeH(22)) Title:@"编辑" Font:14 IsBold:YES TitleColor:RGBA(80, 80, 80, 1.0) TitleSelectColor:RGBA(80, 80, 80, 1.0) ImageName:nil Target:self Action:@selector(clickBuySellEditBtn:)];
        self.editBtn.layer.borderWidth = FitSizeW(0.8);
        self.editBtn.layer.cornerRadius = 2.5;
        self.editBtn.layer.masksToBounds = YES;
        self.editBtn.layer.borderColor = [RGBA(110, 110, 110, 1.0)CGColor];
        [self.contentView addSubview:self.editBtn];
        
        self.deleteBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(10) + CGRectGetMaxX(self.editBtn.frame), CGRectGetMaxY(lineView1.frame) + FitSizeH(9), FitSizeW(44), FitSizeH(22)) Title:@"删除" Font:14 IsBold:YES TitleColor:RGBA(80, 80, 80, 1.0) TitleSelectColor:RGBA(80, 80, 80, 1.0) ImageName:nil Target:self Action:@selector(clickBuySellDeleteBtn:)];
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







- (void)clickBuySellTopBtn:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickBuySellTopBtn:cell:)]) {
        [self.delegate clickBuySellTopBtn:button cell:self];
    }
}

- (void)clickBuySellEditBtn:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickBuySellEditBtn:cell:)]) {
        [self.delegate clickBuySellEditBtn:button cell:self];
    }
}

- (void)clickBuySellDeleteBtn:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickBuySellDeleteBtn:cell:)]) {
        [self.delegate clickBuySellDeleteBtn:button cell:self];
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
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[self.dic objectForKey:@"price"]];
    
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
