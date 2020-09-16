//
//  MyElseCell.m
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/6/29.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "MyElseCell.h"

@implementation MyElseCell

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
        self.titleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), FitSizeH(8), FitSizeW(355), FitSizeH(30)) Font:17 IsBold:YES Text:@"合资SUV今非昔比，这车纯进口油耗..." Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
        [self.contentView addSubview:self.titleLabel];
        
        self.detailLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), FitSizeH(10) + CGRectGetMaxY(self.titleLabel.frame), FitSizeW(345), FitSizeH(45)) Font:14 IsBold:NO Text:@"汽车市场的发展课题确实有了很大的变化，因为在以前的时候，这么多的年轻消费者最喜欢的基本上都是来自于合资品牌旗下的车型，可是如果" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
        [self.contentView addSubview:self.detailLabel];
        
        self.timeLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.detailLabel.frame) + FitSizeH(10), FitSizeW(355), FitSizeH(20)) Font:14 IsBold:NO Text:@"2019/05/16 发布" Color:RGBA(150, 150, 150, 1) Direction:NSTextAlignmentLeft];
        [self.contentView addSubview:self.timeLabel];
        
        UIView * lineView1 = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeH(15), FitSizeH(130), FitSizeW(345), FitSizeH(1)) BgColor:RGBA(245, 245, 245, 1.0) BgImage:nil];
        [self.contentView addSubview:lineView1];
        
        self.dingBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(222), CGRectGetMaxY(lineView1.frame) + FitSizeH(9), FitSizeW(22), FitSizeH(22)) Title:@"顶" Font:14 IsBold:YES TitleColor:RGBA(230, 43, 53, 1.0) TitleSelectColor:RGBA(230, 43, 53, 1.0) ImageName:nil Target:self Action:@selector(clickElseTopBtn:)];
        self.dingBtn.layer.borderWidth = FitSizeW(0.8);
        self.dingBtn.layer.cornerRadius = 2.5;
        self.dingBtn.layer.masksToBounds = YES;
        self.dingBtn.layer.borderColor = [RGBA(230, 43, 53, 1.0)CGColor];
        [self.contentView addSubview:self.dingBtn];
        
        self.editBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(10) + CGRectGetMaxX(self.dingBtn.frame), CGRectGetMaxY(lineView1.frame) + FitSizeH(9), FitSizeW(44), FitSizeH(22)) Title:@"编辑" Font:14 IsBold:YES TitleColor:RGBA(80, 80, 80, 1.0) TitleSelectColor:RGBA(80, 80, 80, 1.0) ImageName:nil Target:self Action:@selector(clickElseEditBtn:)];
        self.editBtn.layer.borderWidth = FitSizeW(0.8);
        self.editBtn.layer.cornerRadius = 2.5;
        self.editBtn.layer.masksToBounds = YES;
        self.editBtn.layer.borderColor = [RGBA(110, 110, 110, 1.0)CGColor];
        [self.contentView addSubview:self.editBtn];
        
        self.deleteBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(10) + CGRectGetMaxX(self.editBtn.frame), CGRectGetMaxY(lineView1.frame) + FitSizeH(9), FitSizeW(44), FitSizeH(22)) Title:@"删除" Font:14 IsBold:YES TitleColor:RGBA(80, 80, 80, 1.0) TitleSelectColor:RGBA(80, 80, 80, 1.0) ImageName:nil Target:self Action:@selector(clickElseDeleteBtn:)];
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

- (void)clickElseTopBtn:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickElseTopBtn:cell:)]) {
        [self.delegate clickElseTopBtn:button cell:self];
    }
}

- (void)clickElseEditBtn:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickElseEditBtn:cell:)]) {
        [self.delegate clickElseEditBtn:button cell:self];
    }
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
