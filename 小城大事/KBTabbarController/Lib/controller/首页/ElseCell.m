//
//  ElseCell.m
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/6/26.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "ElseCell.h"

@implementation ElseCell

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
        
        UIView * lineView = [FlanceTools viewCreateWithFrame:CGRectMake(0, FitSizeH(127), SCREEN_WIDTH, FitSizeH(3)) BgColor:RGBA(245, 245, 245, 1.0) BgImage:nil];
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"name"]];
    
    self.detailLabel.text = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"content"]];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@发布",[self.dic objectForKey:@"createtime"]];
    
}
@end
