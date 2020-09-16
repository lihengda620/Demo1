//
//  RecommendedCell.m
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/6/26.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "RecommendedCell.h"

@implementation RecommendedCell

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
        self.titleTextView = [[UITextView alloc]initWithFrame:CGRectMake(FitSizeW(15), FitSizeH(20), FitSizeW(210), FitSizeH(70))];
        self.titleTextView.text = @"";
        self.titleTextView.userInteractionEnabled = NO;
        self.titleTextView.backgroundColor = [UIColor whiteColor];
        [self.titleTextView setFont:[UIFont systemFontOfSize:17]];
        [self.titleTextView setTextColor:RGBA(15, 15, 15, 1)];
        [self.contentView addSubview:self.titleTextView];
        
        self.timeLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.titleTextView.frame) + FitSizeH(5), FitSizeW(210), FitSizeH(20)) Font:13 IsBold:NO Text:@"5分钟前" Color:RGBA(150, 150, 150, 1.0) Direction:NSTextAlignmentLeft];
        [self.contentView addSubview:self.timeLabel];
        
        self.cellImageView = [FlanceTools imageViewCreateViewWithFrame:CGRectMake(FitSizeW(244), FitSizeH(20), FitSizeW(115), FitSizeH(80)) ImageName:@""];
        self.cellImageView.layer.masksToBounds = YES;
        self.cellImageView.layer.cornerRadius = 5;
        self.cellImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.cellImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        [self.contentView addSubview:self.cellImageView];
        
        UIView * lineView = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(15), FitSizeH(119.5), FitSizeW(343), FitSizeH(0.5)) BgColor:RGBA(220, 220, 220, 1.0) BgImage:nil];
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSString * titleStr = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"title"]];
    self.titleTextView.text = titleStr;
    
    [self.cellImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",RBDom,[self.dic objectForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"bannerzanwei"]];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"createtime"]];
}

@end
