//
//  MyCollectRecommendedCell.m
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/7/1.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "MyCollectRecommendedCell.h"

@implementation MyCollectRecommendedCell

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
        
        self.timeLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.titleTextView.frame) + FitSizeH(5), FitSizeW(210), FitSizeH(20)) Font:13 IsBold:NO Text:@"" Color:RGBA(150, 150, 150, 1.0) Direction:NSTextAlignmentLeft];
        [self.contentView addSubview:self.timeLabel];
        
        self.cellImageView = [FlanceTools imageViewCreateViewWithFrame:CGRectMake(FitSizeW(244), FitSizeH(20), FitSizeW(115), FitSizeH(80)) ImageName:@"bannerzanwei"];
        self.cellImageView.layer.masksToBounds = YES;
        self.cellImageView.layer.cornerRadius = 5;
        self.cellImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.cellImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        [self.contentView addSubview:self.cellImageView];
        
        UIView * lineView1 = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeH(15), FitSizeH(120), FitSizeW(345), FitSizeH(1)) BgColor:RGBA(245, 245, 245, 1.0) BgImage:nil];
        [self.contentView addSubview:lineView1];
        
        
        self.deleteBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(315), CGRectGetMaxY(lineView1.frame) + FitSizeH(9), FitSizeW(44), FitSizeH(22)) Title:@"删除" Font:14 IsBold:YES TitleColor:RGBA(80, 80, 80, 1.0) TitleSelectColor:RGBA(80, 80, 80, 1.0) ImageName:nil Target:self Action:@selector(clickRecommendedDeleteBtn:)];
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

- (void)clickRecommendedDeleteBtn:(UIButton *)button{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickRecommendedDeleteBtn:cell:)]) {
        [self.delegate clickRecommendedDeleteBtn:button cell:self];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSString * titleStr = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"title"]];
    self.titleTextView.text = titleStr;
    
    NSString * imageStr = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"image"]];
    NSArray *imageArr = [imageStr componentsSeparatedByString:@","];
    if (imageArr.count > 0) {
        [self.cellImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",RBDom,imageArr[0]]] placeholderImage:[UIImage imageNamed:@"bannerzanwei"]];
    }
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"createtime"]];
}


@end
