//
//  UIExPickerView.m
//  test
//
//  Created by zhangjingfei on 17/5/2019.
//  Copyright © 2019 zhangjingfei. All rights reserved.
//

#import "UIExPickerView.h"

@implementation UIExPickerView

- (instancetype)initWithFrame:(CGRect)frame arr:(NSArray *)arrData
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.arr = [[NSMutableArray alloc ] initWithArray:arrData];
        [self initCtrl:frame];
    }
    return self;
}

-(void)initCtrl:(CGRect)frame
{
    UIButton *btnCancel = [[UIButton alloc ] initWithFrame:CGRectMake(0, 0, 80, 40)];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(onButtonCancel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnCancel];
    
    UIButton *btnFinish = [[UIButton alloc ] initWithFrame:CGRectMake(self.frame.size.width-80, 0, 80, 40)];
    [btnFinish setTitle:@"完成" forState:UIControlStateNormal];
    [btnFinish setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnFinish addTarget:self action:@selector(onButtonFinish) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnFinish];
    
    UIPickerView *pickerView = [[UIPickerView alloc ] initWithFrame:CGRectMake(0, 40, frame.size.width, frame.size.height-40)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [pickerView setBackgroundColor:[UIColor grayColor]];
    [self addSubview:pickerView];
    
}

-(void) onButtonCancel
{
    if (self)
    {
        [self removeFromSuperview];
    }
}

-(void) onButtonFinish
{
    if ([self.delegate respondsToSelector:@selector(selectIndex:)]) {
        [self.delegate selectIndex:_indexSelect];
    }
    //点击完成后，关闭当前view
    [self onButtonCancel];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.arr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.arr objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    NSLog(@"%@",self.arr[row]);
    _indexSelect = row;
}

@end
