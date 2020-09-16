//
//  PayFailureViewController.h
//  KBTabbarController
//
//  Created by CHUANGSHENG on 2019/7/5.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayFailureViewController : UIViewController

@property (nonatomic, strong) NSString * order_noStr;
@property (nonatomic, strong) NSString * total_feeStr;

//0:查看信息  1：发布信息  2：置顶
@property (nonatomic, strong) NSString * payType;

@end

NS_ASSUME_NONNULL_END
