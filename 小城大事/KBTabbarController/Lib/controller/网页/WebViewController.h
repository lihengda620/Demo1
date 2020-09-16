//
//  WebViewController.h
//  KBTabbarController
//
//  Created by CHUANGSHENG on 2019/7/23.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : UIViewController

@property (nonatomic ,strong) NSString * type;
@property (nonatomic ,strong) NSString * idStr;
@property (nonatomic ,strong) NSString * titleStr;
@property (nonatomic ,strong) NSString * isRecommend;
@property (nonatomic ,strong) NSString * type_id;

@end

NS_ASSUME_NONNULL_END
