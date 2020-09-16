//
//  MyLivesCell.m
//  KBTabbarController
//
//  Created by CHUANGSHENG on 2019/7/16.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "MyLivesCell.h"

@implementation MyLivesCell

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
        
        self.buttonBGView = [FlanceTools viewCreateWithFrame:CGRectMake(CGRectGetMaxX(self.cellImageView.frame), CGRectGetMaxY(self.titleLabel.frame) + FitSizeH(10), FitSizeW(280), FitSizeH(30)) BgColor:[UIColor whiteColor] BgImage:nil];
        [self.contentView addSubview:self.buttonBGView];
        
        UIView * lineView1 = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeH(15), FitSizeH(119), FitSizeW(345), FitSizeH(1)) BgColor:RGBA(245, 245, 245, 1.0) BgImage:nil];
        [self.contentView addSubview:lineView1];
        
        self.dingBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(222), CGRectGetMaxY(lineView1.frame) + FitSizeH(9), FitSizeW(22), FitSizeH(22)) Title:@"顶" Font:14 IsBold:YES TitleColor:RGBA(230, 43, 53, 1.0) TitleSelectColor:RGBA(230, 43, 53, 1.0) ImageName:nil Target:self Action:@selector(clickLivesTopBtn:)];
        self.dingBtn.layer.borderWidth = FitSizeW(0.8);
        self.dingBtn.layer.cornerRadius = 2.5;
        self.dingBtn.layer.masksToBounds = YES;
        self.dingBtn.layer.borderColor = [RGBA(230, 43, 53, 1.0)CGColor];
        [self.contentView addSubview:self.dingBtn];
        
        self.editBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(10) + CGRectGetMaxX(self.dingBtn.frame), CGRectGetMaxY(lineView1.frame) + FitSizeH(9), FitSizeW(44), FitSizeH(22)) Title:@"编辑" Font:14 IsBold:YES TitleColor:RGBA(80, 80, 80, 1.0) TitleSelectColor:RGBA(80, 80, 80, 1.0) ImageName:nil Target:self Action:@selector(clickLivesEditBtn:)];
        self.editBtn.layer.borderWidth = FitSizeW(0.8);
        self.editBtn.layer.cornerRadius = 2.5;
        self.editBtn.layer.masksToBounds = YES;
        self.editBtn.layer.borderColor = [RGBA(110, 110, 110, 1.0)CGColor];
        [self.contentView addSubview:self.editBtn];
        
        self.deleteBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(10) + CGRectGetMaxX(self.editBtn.frame), CGRectGetMaxY(lineView1.frame) + FitSizeH(9), FitSizeW(44), FitSizeH(22)) Title:@"删除" Font:14 IsBold:YES TitleColor:RGBA(80, 80, 80, 1.0) TitleSelectColor:RGBA(80, 80, 80, 1.0) ImageName:nil Target:self Action:@selector(clickLivesDeleteBtn:)];
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


- (void)clickLivesTopBtn:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickLivesTopBtn:cell:)]) {
        [self.delegate clickLivesTopBtn:button cell:self];
    }
}

- (void)clickLivesEditBtn:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickLivesEditBtn:cell:)]) {
        [self.delegate clickLivesEditBtn:button cell:self];
    }
}

- (void)clickLivesDeleteBtn:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickLivesDeleteBtn:cell:)]) {
        [self.delegate clickLivesDeleteBtn:button cell:self];
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
    
    
    self.detailLabel.text = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"declaration"]];
    
    //是否显示置顶
    NSString * isZhiDing = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"tops"]];
    if ([isZhiDing isEqualToString:@"1"]) {
        //显示
        self.dingBtn.hidden = NO;
    }else{
        self.dingBtn.hidden = YES;
    }
    
    
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
