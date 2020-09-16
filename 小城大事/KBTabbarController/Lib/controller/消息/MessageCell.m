//
//  MessageCell.m
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/6/27.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

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
        self.cellImageView = [FlanceTools imageViewCreateViewWithFrame:CGRectMake(FitSizeW(15), FitSizeH(20), FitSizeW(90), FitSizeH(80)) ImageName:@""];
        self.cellImageView.layer.masksToBounds = YES;
        self.cellImageView.layer.cornerRadius = 5;
        [self.contentView addSubview:self.cellImageView];
        
        self.titleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(CGRectGetMaxX(self.cellImageView.frame) + FitSizeW(10), CGRectGetMinY(self.cellImageView.frame), FitSizeW(100), FitSizeH(20)) Font:16 IsBold:YES Text:@"" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
        [self.contentView addSubview:self.titleLabel];
        
        self.detailLabel = [FlanceTools labelCreateWithFrame:CGRectMake(CGRectGetMaxX(self.cellImageView.frame) + FitSizeW(10), CGRectGetMaxY(self.cellImageView.frame) - FitSizeH(40), FitSizeW(230), FitSizeH(45)) Font:14 IsBold:YES Text:@"" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
        [self.contentView addSubview:self.detailLabel];
        
        self.timeLabel = [FlanceTools labelCreateWithFrame:CGRectMake(SCREEN_WIDTH - FitSizeW(160), CGRectGetMidY(self.titleLabel.frame) - FitSizeH(10), FitSizeW(145), FitSizeH(20)) Font:14 IsBold:NO Text:@"" Color:RGBA(150, 150, 150, 1) Direction:NSTextAlignmentRight];
        [self.contentView addSubview:self.timeLabel];
        
        UIView * lineView = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(15), FitSizeH(129), SCREEN_WIDTH - FitSizeW(30), FitSizeH(1)) BgColor:RGBA(245, 245, 245, 1.0) BgImage:nil];
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSString * type_name = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"title"]];
    NSString * createtime = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"createtime"]];
    NSString * content = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"content"]];
    NSString * type = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"image"]];
    
    self.titleLabel.text = type_name;
    self.detailLabel.text = content;
    self.timeLabel.text = createtime;
    if ([type isEqualToString:@"system"]) {
        self.cellImageView.image = [UIImage imageNamed:@"tupian_xitong"];
    }else if ([type isEqualToString:@"staff"]){
        
        self.cellImageView.image = [UIImage imageNamed:@"tupian_qiuzhi"];
    }else if ([type isEqualToString:@"housekeep"]){
        
        self.cellImageView.image = [UIImage imageNamed:@"tupian_jiazheng"];
    }else if ([type isEqualToString:@"lease"]){
        
        self.cellImageView.image = [UIImage imageNamed:@"tupian_zufang"];
    }else if ([type isEqualToString:@"goods"]){
        
        self.cellImageView.image = [UIImage imageNamed:@"tupian_maimai"];
    }else if ([type isEqualToString:@"appointment"]){
        self.cellImageView.image = [UIImage imageNamed:@"tupian_xiangyue"];
        
    }else if ([type isEqualToString:@"live"]){
        
        self.cellImageView.image = [UIImage imageNamed:@"tupian_hunlian"];
    }else if ([type isEqualToString:@"else"]){
        
        self.cellImageView.image = [UIImage imageNamed:@"tupian_qita"];
    }
    
}

@end
