//
//  RentHouseCell.m
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/6/26.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "RentHouseCell.h"

@implementation RentHouseCell

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
        
        
        self.titleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(CGRectGetMaxX(self.cellImageView.frame) + FitSizeW(10), CGRectGetMinY(self.cellImageView.frame), FitSizeW(100), FitSizeH(20)) Font:16 IsBold:YES Text:@"" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
        [self.contentView addSubview:self.titleLabel];
        
        self.specificationsLabel = [FlanceTools labelCreateWithFrame:CGRectMake(CGRectGetMaxX(self.cellImageView.frame) + FitSizeW(10), CGRectGetMidY(self.cellImageView.frame) - FitSizeH(10), FitSizeW(300), FitSizeH(20)) Font:14 IsBold:NO Text:@"" Color:RGBA(150, 150, 150, 1.0) Direction:NSTextAlignmentLeft];
        [self.contentView addSubview:self.specificationsLabel];
        
        self.addressLabel = [FlanceTools labelCreateWithFrame:CGRectMake(CGRectGetMaxX(self.cellImageView.frame) + FitSizeW(10), CGRectGetMaxY(self.cellImageView.frame) - FitSizeH(20), FitSizeW(280), FitSizeH(20)) Font:14 IsBold:NO Text:@"" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
        [self.contentView addSubview:self.addressLabel];
        
        self.priceLabel = [FlanceTools labelCreateWithFrame:CGRectMake(SCREEN_WIDTH - FitSizeW(200), CGRectGetMidY(self.titleLabel.frame) - FitSizeH(15), FitSizeW(185), FitSizeH(30)) Font:20 IsBold:NO Text:@"" Color:RGBA(238, 82, 82, 1) Direction:NSTextAlignmentRight];
        [self.contentView addSubview:self.priceLabel];
        
        UIView * lineView = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(15), FitSizeH(119.5), FitSizeW(343), FitSizeH(0.5)) BgColor:RGBA(220, 220, 220, 1.0) BgImage:nil];
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
        self.cellImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.cellImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    }
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"name"]];
    
    self.specificationsLabel.text = [NSString stringWithFormat:@"%@  %@平",[self.dic objectForKey:@"layout"],[self.dic objectForKey:@"space"]];
    
    self.priceLabel.text = [NSString stringWithFormat:@"%@元",[self.dic objectForKey:@"rental"]];
    
    self.addressLabel.text = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"address"]];
}

- (UIImage *)cutImage:(UIImage*)originImage
{
    CGSize newImageSize;
    CGImageRef imageRef = nil;
    
    CGSize imageViewSize = self.imageView.frame.size;
    CGSize originImageSize = originImage.size;
    
    if ((originImageSize.width / originImageSize.height) < (imageViewSize.width / imageViewSize.height))
    {
        // imageView的宽高比 > image的宽高比
        newImageSize.width = originImageSize.width;
        newImageSize.height = imageViewSize.height * (originImageSize.width / imageViewSize.width);
        
        imageRef = CGImageCreateWithImageInRect([originImage CGImage], CGRectMake(0, fabs(originImageSize.height - newImageSize.height) / 2, newImageSize.width, newImageSize.height));
    }
    else
    {
        // image的宽高比 > imageView的宽高比   ： 也就是说原始图片比较狭长
        newImageSize.height = originImageSize.height;
        newImageSize.width = imageViewSize.width * (originImageSize.height / imageViewSize.height);
        
        imageRef = CGImageCreateWithImageInRect([originImage CGImage], CGRectMake(fabs(originImageSize.width - newImageSize.width) / 2, 0, newImageSize.width, newImageSize.height));
    }
    
    return [UIImage imageWithCGImage:imageRef];
    
}
@end
