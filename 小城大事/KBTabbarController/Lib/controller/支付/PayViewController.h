//
//  PayViewController.h
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/7/3.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RentHouseViewController.h"
#import "FaBuDatingViewController.h"
#import "FaBuElesViewController.h"
#import "FaBuBuySellViewController.h"
#import "FaBuHousekeepingViewController.h"
#import "FaBuRecruitmentViewController.h"
#import "FaBuHunLianViewController.h"





NS_ASSUME_NONNULL_BEGIN

@interface PayViewController : UIViewController
@property (nonatomic, strong) RentHouseViewController * RentHouseVC;
@property (nonatomic, strong) FaBuDatingViewController * FaBuDatingVC;
@property (nonatomic, strong) FaBuElesViewController * FaBuElesVC;
@property (nonatomic, strong) FaBuBuySellViewController * FaBuBuySellVC;
@property (nonatomic, strong) FaBuHousekeepingViewController * FaBuHousekeepingVC;
@property (nonatomic, strong) FaBuRecruitmentViewController * FaBuRecruitmentVC;
@property (nonatomic, strong) FaBuHunLianViewController * FaBuHunLianVC;



@property (nonatomic, strong) NSString * order_noStr;
@property (nonatomic, strong) NSString * total_feeStr;

//0:查看信息  1：发布信息  2：置顶
@property (nonatomic, strong) NSString * payType;

@property (nonatomic, strong) NSString * isALiPayOK;
@property (nonatomic, strong) NSString * isWechartOK;

@end

NS_ASSUME_NONNULL_END
