//
//  MyCollectElseCell.m
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/7/1.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "MyCollectElseCell.h"

@implementation MyCollectElseCell

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
        self.titleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), FitSizeH(8), FitSizeW(355), FitSizeH(30)) Font:17 IsBold:YES Text:@"" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
        [self.contentView addSubview:self.titleLabel];
        
        self.detailLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), FitSizeH(10) + CGRectGetMaxY(self.titleLabel.frame), FitSizeW(345), FitSizeH(45)) Font:14 IsBold:NO Text:@"" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
        [self.contentView addSubview:self.detailLabel];
        
        self.timeLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.detailLabel.frame) + FitSizeH(10), FitSizeW(355), FitSizeH(20)) Font:14 IsBold:NO Text:@"" Color:RGBA(150, 150, 150, 1) Direction:NSTextAlignmentLeft];
        [self.contentView addSubview:self.timeLabel];
        
        UIView * lineView1 = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeH(15), FitSizeH(129), FitSizeW(345), FitSizeH(1)) BgColor:RGBA(245, 245, 245, 1.0) BgImage:nil];
        [self.contentView addSubview:lineView1];
        
        
        self.deleteBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(315), CGRectGetMaxY(lineView1.frame) + FitSizeH(9), FitSizeW(44), FitSizeH(22)) Title:@"删除" Font:14 IsBold:YES TitleColor:RGBA(80, 80, 80, 1.0) TitleSelectColor:RGBA(80, 80, 80, 1.0) ImageName:nil Target:self Action:@selector(clickElseDeleteBtn:)];
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

- (void)clickElseDeleteBtn:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickElseDeleteBtn:cell:)]) {
        [self.delegate clickElseDeleteBtn:button cell:self];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"name"]];
    
    self.detailLabel.text = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"content"]];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@发布",[self.dic objectForKey:@"createtime"]];
    
}

@end
