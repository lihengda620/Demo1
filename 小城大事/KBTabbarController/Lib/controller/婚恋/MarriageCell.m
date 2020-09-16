//
//  MarriageCell.m
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/6/27.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "MarriageCell.h"

@implementation MarriageCell

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
        self.cellImageView = [FlanceTools imageViewCreateViewWithFrame:CGRectMake(FitSizeW(15), FitSizeH(20), FitSizeW(90), FitSizeH(80)) ImageName:@"bannerzanwei"];
        self.cellImageView.layer.masksToBounds = YES;
        self.cellImageView.layer.cornerRadius = 5;
        self.cellImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.cellImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        [self.contentView addSubview:self.cellImageView];
        
        self.titleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(CGRectGetMaxX(self.cellImageView.frame) + FitSizeW(10), CGRectGetMinY(self.cellImageView.frame), FitSizeW(250), FitSizeH(20)) Font:16 IsBold:YES Text:@"" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
        [self.contentView addSubview:self.titleLabel];
        
        
        self.detailLabel = [FlanceTools labelCreateWithFrame:CGRectMake(CGRectGetMaxX(self.cellImageView.frame) + FitSizeW(10), CGRectGetMaxY(self.titleLabel.frame) + FitSizeH(40), FitSizeW(250), FitSizeH(40)) Font:13 IsBold:YES Text:@"" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
        [self.contentView addSubview:self.detailLabel];
        
        self.timeLabel = [FlanceTools labelCreateWithFrame:CGRectMake(SCREEN_WIDTH - FitSizeW(150), CGRectGetMidY(self.titleLabel.frame) - FitSizeH(10), FitSizeW(135), FitSizeH(20)) Font:13 IsBold:NO Text:@"" Color:RGBA(150, 150, 150, 1.0) Direction:NSTextAlignmentRight];
        [self.contentView addSubview:self.timeLabel];
        
        self.buttonBGView = [FlanceTools viewCreateWithFrame:CGRectMake(CGRectGetMaxX(self.cellImageView.frame), CGRectGetMaxY(self.titleLabel.frame) + FitSizeH(10), FitSizeW(280), FitSizeH(30)) BgColor:[UIColor whiteColor] BgImage:nil];
        [self.contentView addSubview:self.buttonBGView];
        
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
    
    
    self.detailLabel.text = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"declaration"]];
    
    NSArray *dateStrArr = [[NSString stringWithFormat:@"%@",[self.dic objectForKey:@"createtime"]] componentsSeparatedByString:@" "];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@",[dateStrArr firstObject]];
    
    
    
    NSString * cityStr = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"city"]];
    
    NSString * genderStr = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"gender"]];
    NSString * sexStr = @"";
    if ([genderStr isEqualToString:@"2"]) {
        sexStr = @"女";
    }else{
        sexStr = @"男";
    }
    
    NSString * ageStr = [NSString stringWithFormat:@"%@岁",[self.dic objectForKey:@"age"]];
    
    NSMutableArray * dataArr = [[NSMutableArray alloc]initWithObjects:cityStr,sexStr,ageStr, nil];
    
    [self.buttonBGView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h = FitSizeH(5);//用来控制button距离父视图的高
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
