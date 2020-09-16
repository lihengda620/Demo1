//
//  FourViewController.m
//  KBTabbarController
//
//  Created by kangbing on 16/5/31.
//  Copyright © 2016年 kangbing. All rights reserved.
//

#import "FourViewController.h"
#import "ChangeUserInfoViewController.h"
#import "MyFaBuViewController.h"
#import "MyCollectViewController.h"
#import "ChangePhoneViewController.h"
#import "AbloutUsViewController.h"
//#import <SDImageCache.h>

@interface FourViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView * navigationView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * tableHeaderView;
@property (nonatomic, strong) UIButton * userInfoBtn;
@property (nonatomic, strong) UIView * tableFooterView;
@property (nonatomic, strong) UIImageView * userImageView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * phoneLabel;

@end

@implementation FourViewController{
    NSArray * settingArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString * settingArrPath = [[NSBundle mainBundle]pathForResource:@"SetingList" ofType:@"plist"];
    settingArr = [NSArray arrayWithContentsOfFile:settingArrPath];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigationView];
    [self initView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getRootViewwController) name:@"click_PWLoginDismiss" object:nil];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",RBDom,[userinfoDic objectForKey:@"avatar"]]);
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",RBDom,[userinfoDic objectForKey:@"avatar"]]] placeholderImage:[UIImage imageNamed:@"Head"]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"nickname"]];
    
    NSString * phoneStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"mobile"]];
    NSString * phoneFooterStr = [phoneStr substringFromIndex:phoneStr.length - 4];
    NSString * phoneHeaderStr = [phoneStr substringToIndex:3];
    NSString * bankStr = [NSString stringWithFormat:@"%@****%@",phoneHeaderStr,phoneFooterStr];
    self.phoneLabel.text = [NSString stringWithFormat:@"手机号：%@",bankStr];
    [self.tableView reloadData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)getRootViewwController{
    [self.tabBarController setSelectedIndex:0];
}

- (void)initNavigationView
{
    self.navigationView = [FlanceTools viewCreateWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT) BgColor:RGBA(238, 82, 82, 1) BgImage:nil];
    [self.view addSubview:self.navigationView];
    
    self.titleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(SCREEN_WIDTH/2 - FitSizeH(100), STATUS_BAR_HEIGHT + FitSizeH(8), FitSizeW(200), FitSizeH(20)) Font:17.0f IsBold:YES Text:@"个人中心" Color:[UIColor whiteColor] Direction:NSTextAlignmentCenter];
    [self.navigationView addSubview: self.titleLabel];
}

- (void)initView{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0,CGRectGetMaxY(self.navigationView.frame), SCREEN_WIDTH,SCREEN_HEIGHT - CGRectGetMaxY(self.navigationView.frame) - TAB_BAR_HEIGHT) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    self.tableView.showsVerticalScrollIndicator = NO;
    [_tableView setBackgroundColor:RGBA(245, 245, 245, 1.0)];
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //cell无数据时，不显示间隔线
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView setTableFooterView:v];
    [self.view addSubview:_tableView];
    
    self.tableHeaderView = [FlanceTools viewCreateWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FitSizeH(135)) BgColor:RGBA(245, 245, 245, 1.0) BgImage:nil];
    
    UIView * userInfoView = [FlanceTools viewCreateWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FitSizeH(120)) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.tableHeaderView addSubview:userInfoView];
    
    self.userImageView = [FlanceTools imageViewCreateViewWithFrame:CGRectMake(FitSizeW(15), (FitSizeH(120) - FitSizeH(65)) / 2, FitSizeW(65), FitSizeH(65)) ImageName:@""];
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.cornerRadius = FitSizeH(65) / 2;
    [userInfoView addSubview:self.userImageView];
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",RBDom,[userinfoDic objectForKey:@"avatar"]]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    
    self.nameLabel = [FlanceTools labelCreateWithFrame:CGRectMake(CGRectGetMaxX(self.userImageView.frame) + FitSizeW(20), CGRectGetMinY(self.userImageView.frame), FitSizeW(280), FitSizeH(30)) Font:20 IsBold:YES Text:[NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"nickname"]] Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
    [userInfoView addSubview:self.nameLabel];
    
    self.phoneLabel = [FlanceTools labelCreateWithFrame:CGRectMake(CGRectGetMaxX(self.userImageView.frame) + FitSizeW(20), CGRectGetMaxY(self.userImageView.frame) - FitSizeH(20), FitSizeW(280), FitSizeH(20)) Font:14 IsBold:YES Text:[NSString stringWithFormat:@"手机号：%@",[userinfoDic objectForKey:@"mobile"]] Color:RGBA(80, 80, 80, 1.0) Direction:NSTextAlignmentLeft];
    [userInfoView addSubview:self.phoneLabel];
    
    self.userInfoBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FitSizeH(120)) Title:nil Font:12 IsBold:NO TitleColor:nil TitleSelectColor:nil ImageName:nil Target:self Action:@selector(click_userInfo)];
    [userInfoView addSubview:self.userInfoBtn];
    
    self.tableView.tableHeaderView = self.tableHeaderView;
    
    self.tableFooterView = [FlanceTools viewCreateWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FitSizeH(60)) BgColor:RGBA(245, 245, 245, 1.0) BgImage:nil];
    
    UIButton * logOutBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(0, FitSizeH(8), SCREEN_WIDTH, FitSizeH(52)) Title:@"退出登录" Font:15 IsBold:NO TitleColor:RGBA(15, 15, 15, 1.0) TitleSelectColor:RGBA(15, 15, 15, 1.0) ImageName:nil Target:self Action:@selector(click_logOutBtn)];
    [logOutBtn setBackgroundColor:[UIColor whiteColor]];
    [self.tableFooterView addSubview:logOutBtn];
    
    self.tableView.tableFooterView = self.tableFooterView;
}

// 返回行数
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return settingArr.count;
}
/**
 *  设置行高
 */
- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return FitSizeH(55);
}

// 设置cell
- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSString * identifier= @"HomePageCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[settingArr[indexPath.row] objectForKey:@"image"]]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[settingArr[indexPath.row] objectForKey:@"title"]];
    
    
    
    if (indexPath.row == 1) {
        
        UILabel * label = (UILabel *)[cell viewWithTag:3300];
        [label removeFromSuperview];
        
        NSUInteger bytesCache = [[SDImageCache sharedImageCache] getSize];
        float MBCache = bytesCache/1000/1000;
        UILabel * mbLabel = [FlanceTools labelCreateWithFrame:CGRectMake(SCREEN_WIDTH - FitSizeW(150), 0, FitSizeW(135), FitSizeH(55)) Font:14 IsBold:NO Text:[NSString stringWithFormat:@"%.2fMB",MBCache] Color:RGBA(150, 150, 150, 1.0) Direction:NSTextAlignmentRight];
        mbLabel.tag = 3300;
        [cell addSubview:mbLabel];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ChangePhoneViewController  * navc = [[ChangePhoneViewController alloc]init];
        navc.navc = self;
        [self.navigationController pushViewController:navc animated:YES];
    }else if (indexPath.row == 1){
        UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        
        UILabel * MBLabel = (UILabel *)[cell viewWithTag:3300];
        
//        [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
//        [[SDImageCache sharedImageCache] clearMemory];//可不写
        
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.label.text = @"缓存清理成功";
        HUD.mode = MBProgressHUDModeText;
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        }completionBlock:^{
            [HUD removeFromSuperview];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[SDImageCache sharedImageCache] clearDisk];
            });
            MBLabel.text = @"0.00MB";
        }];
    }else if (indexPath.row == 2){
        MyCollectViewController * navc = [[MyCollectViewController alloc]init];
        [self.navigationController pushViewController:navc animated:YES];
    }else if (indexPath.row == 3){
        MyFaBuViewController * navc = [[MyFaBuViewController alloc]init];
        [self.navigationController pushViewController:navc animated:YES];
    }else if (indexPath.row == 4){
        AbloutUsViewController * navc = [[AbloutUsViewController alloc]init];
        navc.urlStr = @"/Index/index/platformintroduce";
        [self.navigationController pushViewController:navc animated:YES];
    }
}

- (void)click_userInfo
{
    ChangeUserInfoViewController * navc = [[ChangeUserInfoViewController alloc]init];
    navc.navc = self;
    [self.navigationController pushViewController:navc animated:YES];
}

- (void)click_logOutBtn{
    [self doLogin_out];
}

- (void)getNewUserInfo:(NSString *)headImageUrl nikeName:(NSString *)nikeName
{
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",RBDom,headImageUrl]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.nameLabel.text = nikeName;
}

- (void)ChangePhoneLogOut
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.label.text = @"修改成功，请重新登录";
    HUD.mode = MBProgressHUDModeText;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    }completionBlock:^{
        [HUD removeFromSuperview];
        [self doLogin_out];
    }];
}


#pragma mark 退出登录UserLogout
- (void)doLogin_out
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",UserLogout];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters=@{@"token":tokenStr};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"responseObject-->%@",responseObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        NSString * currentregistrationID = LDcurrentregistrationID;
        NSUserDefaults *userDefaultes = LDUserDefaults;
        NSString * currentCityStr = [NSString stringWithFormat:@"%@",[userDefaultes stringForKey:@"currentCityStr"]];
        NSString*appDomain = [[NSBundle mainBundle]bundleIdentifier];
        [[NSUserDefaults standardUserDefaults]removePersistentDomainForName:appDomain];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"logout" object:nil];
        [userDefaultes setObject:currentCityStr forKey:@"currentCityStr"];
        LoginViewController *controller = [[LoginViewController alloc] init];
        controller.modalPresentationStyle = 0;
        [self presentViewController:controller animated:YES completion:nil];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"error-->%@",error);
    }];
}

-(AFHTTPSessionManager *)sharedManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //最大请求并发任务数
    manager.operationQueue.maxConcurrentOperationCount = 5;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
    // 超时时间
    manager.requestSerializer.timeoutInterval = 30.0f;
    // 设置请求头
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    // 设置接收的Content-Type
    manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain",nil];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//返回格式 JSON
    //设置返回C的ontent-type
    manager.responseSerializer.acceptableContentTypes=[[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain",nil];
    return manager;
}


- (void)showAlert:(NSString *)text
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:text preferredStyle:UIAlertControllerStyleAlert ];
    //添加确定到UIAlertController中
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:OKAction];
    [self presentViewController:alertController animated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
