//
//  RecruitmentCell.m
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/6/26.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "RecruitmentCell.h"

@implementation RecruitmentCell

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
        self.titleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), FitSizeH(8), FitSizeW(260), FitSizeH(30)) Font:17 IsBold:YES Text:@"" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
        [self.contentView addSubview:self.titleLabel];
        
        self.priceLabel = [FlanceTools labelCreateWithFrame:CGRectMake(SCREEN_WIDTH - FitSizeW(150), FitSizeH(15), FitSizeW(120), FitSizeH(25)) Font:20 IsBold:NO Text:@"" Color:RGBA(238, 82, 82, 1) Direction:NSTextAlignmentRight];
        [self.contentView addSubview:self.priceLabel];
        
        self.buttonBGView = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(5), CGRectGetMaxY(self.titleLabel.frame) + FitSizeH(3), SCREEN_WIDTH, FitSizeH(20)) BgColor:[UIColor whiteColor] BgImage:nil];
        [self.contentView addSubview:self.buttonBGView];
        
        
        self.companyNamelabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), FitSizeH(36) + CGRectGetMaxY(self.titleLabel.frame), FitSizeH(300), FitSizeH(20)) Font:14 IsBold:NO Text:@"" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
        [self.contentView addSubview:self.companyNamelabel];
        
        self.personNumLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.companyNamelabel.frame) + FitSizeH(5), FitSizeW(300), FitSizeH(20)) Font:14 IsBold:NO Text:@"" Color:RGBA(150, 150, 150, 1.0) Direction:NSTextAlignmentLeft];
        [self.contentView addSubview:self.personNumLabel];
        
        UIView * lineView = [FlanceTools viewCreateWithFrame:CGRectMake(0, FitSizeH(127), SCREEN_WIDTH, FitSizeH(3)) BgColor:RGBA(245, 245, 245, 1.0) BgImage:nil];
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"name"]];
    
    self.priceLabel.text = [NSString stringWithFormat:@"%@-%@K",[self.dic objectForKey:@"min_salary"],[self.dic objectForKey:@"max_salary"]];
    
    self.companyNamelabel.text = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"company"]];
    
    self.personNumLabel.text = [NSString stringWithFormat:@"%@ %@",[self.dic objectForKey:@"unit_nature_name"],[self.dic objectForKey:@"scale"]];
    
    NSString * cityStr = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"city"]];
    
    NSString * experience_nameStr = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"experience_name"]];
    
    NSString * education_nameStr = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"education_name"]];
    
    NSMutableArray * dataArr = [[NSMutableArray alloc]initWithObjects:cityStr,experience_nameStr,education_nameStr, nil];
    
    [self.buttonBGView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h = 0;//用来控制button距离父视图的高
    for (int i = 0; i < dataArr.count; i++) {
        NSString * buttonTitleStr = dataArr[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.backgroundColor = RGBA(245, 245, 245, 1.0);
        [button setTitleColor:RGBA(15, 15, 15, 1) forState:UIControlStateNormal];
        //根据计算文字的大小
        
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGFloat length = [buttonTitleStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        //为button赋值
        [button setTitle:buttonTitleStr forState:UIControlStateNormal];
        //设置button的frame
        button.frame = CGRectMake(FitSizeW(10) + w, h, length + FitSizeW(15) , FitSizeH(20));
        button.layer.cornerRadius = 2;
        button.layer.masksToBounds = YES;
        //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
        if(FitSizeW(10) + w + length + FitSizeW(25) > SCREEN_WIDTH){
            w = 0; //换行时将w置为0
            h = h + button.frame.size.height + FitSizeH(10);//距离父视图也变化
            button.frame = CGRectMake(FitSizeW(10) + w, h, length + FitSizeW(15), FitSizeH(30));//重设button的frame
        }
        w = button.frame.size.width + button.frame.origin.x;
        [self.buttonBGView addSubview:button];
    }
}
@end
