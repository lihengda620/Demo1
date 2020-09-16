//
//  ThreeViewController.m
//  KBTabbarController
//
//  Created by kangbing on 16/5/31.
//  Copyright © 2016年 kangbing. All rights reserved.
//

#import "ThreeViewController.h"
#import "MessageCell.h"
#import "MessageDetailViewController.h"
#import "MessageWebViewController.h"

@interface ThreeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView * navigationView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UITableView * tableView;

@end

@implementation ThreeViewController{
    //推荐列表
    NSMutableArray * mutaMessageArr;
    NSArray * messageArr;
    NSInteger  page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    mutaMessageArr = [NSMutableArray array];
    [self initNavigationView];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getRootViewwController) name:@"click_PWLoginDismiss" object:nil];
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
    
    self.titleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(SCREEN_WIDTH/2 - FitSizeH(100), STATUS_BAR_HEIGHT + FitSizeH(8), FitSizeW(200), FitSizeH(20)) Font:17.0f IsBold:YES Text:@"消息中心" Color:[UIColor whiteColor] Direction:NSTextAlignmentCenter];
    [self.navigationView addSubview: self.titleLabel];
}

- (void)initView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0,CGRectGetMaxY(self.navigationView.frame), SCREEN_WIDTH, ScreenSizeHeight - CGRectGetMaxY(self.navigationView.frame) - TAB_BAR_HEIGHT) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    self.tableView.showsVerticalScrollIndicator = NO;
    [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [_tableView setSectionIndexColor:[UIColor darkGrayColor]];
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //cell无数据时，不显示间隔线
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView setTableFooterView:v];
    [self.view addSubview:_tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self->page = 1;
        [self doGetMessageLists];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadOnceData方法）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMessageListsMoreData)];
}


- (void)loadMessageListsMoreData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self->page ++;
    [self doGetMessageLists];
}

// 返回行数
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mutaMessageArr.count;
}
/**
 *  设置行高
 */
- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return FitSizeH(130);
}

// 设置cell
- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    NSString * identifier= @"OnADateCell";
    MessageCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dic = mutaMessageArr[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary * dic = mutaMessageArr[indexPath.row];
    NSString * type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"image"]];
    if ([type isEqualToString:@"system"]) {
        MessageWebViewController * navc = [[MessageWebViewController alloc]init];
        navc.idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        [self.navigationController pushViewController:navc animated:YES];
    }else{
        MessageDetailViewController * navc = [[MessageDetailViewController alloc]init];
        navc.dataDic = dic;
        [self.navigationController pushViewController:navc animated:YES];
    }
    
}


#pragma mark 消息列表
- (void)doGetMessageLists
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",MessageLists];
    //构造参数
    NSNumber  * pageNum = [NSNumber numberWithInteger:page];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"num":@"10",@"page":pageNum,@"token":tokenStr};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"ElsesLists responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            self->messageArr = [dataDic objectForKey:@"data"];
            if (self->page == 1) {
                self->mutaMessageArr  = [NSMutableArray arrayWithArray:self->messageArr];
                NSLog(@"mutaMessageArr ====%@",self->mutaMessageArr);
            }else{
                [self->mutaMessageArr addObjectsFromArray:self->messageArr];
                NSLog(@"mutaMessageArr ====%@",self->mutaMessageArr);
            }
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            // 隐藏当前的上拉刷新控件
            int allpage = [[dataDic valueForKey:@"allpage"]intValue];
            if (self->page == allpage) {
                self.tableView.mj_footer.hidden = YES;
            }else{
                self.tableView.mj_footer.hidden = NO;
            }
        }else if (code == 99){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.label.text = @"请登录后进行查看";
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2);
            }completionBlock:^{
                [HUD removeFromSuperview];
                LoginViewController *controller = [[LoginViewController alloc] init];
                controller.modalPresentationStyle = 0;
                [self presentViewController:controller animated:YES completion:nil];
            }];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString * messageStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]];
            [self showAlert:messageStr];
        }
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
