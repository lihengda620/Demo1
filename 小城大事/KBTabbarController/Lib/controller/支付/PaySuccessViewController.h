//
//  PaySuccessViewController.h
//  KBTabbarController
//
//  Created by CHUANGSHENG on 2019/7/5.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RentHouseViewController.h"
#import "FaBuDatingViewController.h"
#import "FaBuBuySellViewController.h"
#import "FaBuHousekeepingViewController.h"
#import "FaBuRecruitmentViewController.h"
#import "FaBuHunLianViewController.h"
#import "RecruitmentDetailsViewController.h"
#import "HousekeepingDetailViewController.h"
#import "RentHouseDetailViewController.h"
#import "BaySellDetailViewController.h"
#import "FriendDetailViewController.h"
#import "ElseDetailViewController.h"
#import "HunLianDetailViewController.h"



NS_ASSUME_NONNULL_BEGIN

@interface PaySuccessViewController : UIViewController
@property (nonatomic, strong) RentHouseViewController * RentHouseVC;
@property (nonatomic, strong) FaBuDatingViewController * FaBuDatingVC;
@property (nonatomic, strong) FaBuElesViewController * FaBuElesVC;
@property (nonatomic, strong) FaBuBuySellViewController * FaBuBuySellVC;
@property (nonatomic, strong) FaBuHousekeepingViewController * FaBuHousekeepingVC;
@property (nonatomic, strong) FaBuRecruitmentViewController * FaBuRecruitmentVC;
@property (nonatomic, strong) FaBuHunLianViewController * FaBuHunLianVC;

//0:查看信息  1：发布信息  2：置顶
@property (nonatomic, strong) NSString * payType;

@end

NS_ASSUME_NONNULL_END
