//
//  ChangeUserInfoViewController.m
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/6/29.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "ChangeUserInfoViewController.h"

@interface ChangeUserInfoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * navigationView;
@property (nonatomic, strong) UIButton * rightBtn;

@property (nonatomic, strong) UIButton * userImageBtn;
@property (nonatomic, strong) UIImageView * userHeadImageView;
@property (nonatomic, strong) UITextField * nameTF;

@end

@implementation ChangeUserInfoViewController{
    UIImagePickerController *imagePicker;
    NSString * headImageUrl;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden=YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden=NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBA(245, 245, 245, 1.0);
    [self initNavigationView];
    [self initView];
    UITapGestureRecognizer *keyboardDownTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(KeyboardDown)];
    [self.view addGestureRecognizer:keyboardDownTap];
}

-(void)KeyboardDown
{
    [self.nameTF resignFirstResponder];
}



- (void)initNavigationView{
    self.navigationView = [FlanceTools viewCreateWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.view addSubview:self.navigationView];
    
    self.titleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(SCREEN_WIDTH/2 - FitSizeH(100), STATUS_BAR_HEIGHT + FitSizeH(8), FitSizeW(200), FitSizeH(20)) Font:17.0f IsBold:YES Text:@"个人信息" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentCenter];
    [self.navigationView addSubview: self.titleLabel];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(0, CGRectGetMidY(self.titleLabel.frame) - FitSizeH(22), FitSizeW(40), FitSizeH(44));
    [self.backBtn setImage:[UIImage imageNamed:@"fanhuio"] forState:UIControlStateNormal];
    [self.backBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(click_back) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview: self.backBtn];
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.frame = CGRectMake(SCREEN_WIDTH - FitSizeW(80), STATUS_BAR_HEIGHT +(NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT) / 2 - FitSizeH(14.5), FitSizeW(61), FitSizeH(29));
    [self.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.rightBtn setBackgroundColor:RGBA(238, 82, 82, 1)];
    self.rightBtn.layer.cornerRadius = FitSizeW(5);
    self.rightBtn.layer.masksToBounds = YES;
    [self.rightBtn addTarget:self action:@selector(click_rightBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview: self.rightBtn];
}

- (void)initView{
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    self->headImageUrl = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"avatar"]];
    NSString * headUrl = [NSString stringWithFormat:@"%@%@",RBDom,[userinfoDic objectForKey:@"avatar"]];
    NSString * nickname = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"nickname"]];
    
    
    
    UIView * HeadView = [FlanceTools viewCreateWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationView.frame) + FitSizeH(6), SCREEN_WIDTH, FitSizeH(88)) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.view addSubview:HeadView];
    
    self.userHeadImageView = [FlanceTools imageViewCreateViewWithFrame:CGRectMake(FitSizeW(15), FitSizeH(14), FitSizeW(60), FitSizeH(60)) ImageName:@"默认头像"];
    self.userHeadImageView.layer.cornerRadius = FitSizeH(30);
    self.userHeadImageView.layer.masksToBounds = YES;
    [HeadView addSubview:self.userHeadImageView];
    [self.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    
    self.userImageBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FitSizeH(88)) Title:@"点击更换头像" Font:14 IsBold:NO TitleColor:RGBA(150, 150, 150, 1.0) TitleSelectColor:RGBA(150, 150, 150, 1.0) ImageName:@"" Target:self Action:@selector(click_addPhotoBt)];
    [HeadView addSubview:self.userImageBtn];
    
    UIView * nameView = [FlanceTools viewCreateWithFrame:CGRectMake(0, CGRectGetMaxY(HeadView.frame) + FitSizeH(6), SCREEN_WIDTH, FitSizeH(50)) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.view addSubview:nameView];
    
    UILabel * nameTextLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), 0, FitSizeW(60), FitSizeH(50)) Font:15 IsBold:NO Text:@"昵称" Color:RGBA(80, 80, 80, 1.0) Direction:NSTextAlignmentLeft];
    [nameView addSubview:nameTextLabel];
    
    self.nameTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(CGRectGetMaxX(nameTextLabel.frame), 0, FitSizeW(300), FitSizeH(50)) placeholder:@"输入修改的昵称" passWord:NO leftImageView:nil rightImageView:nil Font:14 backgRoundImageName:nil];
    [nameView addSubview:self.nameTF];
    self.nameTF.text = nickname;
    
}

- (void)click_addPhotoBt{
    UIActionSheet * imageSheet = [[UIActionSheet alloc] initWithTitle:nil
                                             delegate:self
                                    cancelButtonTitle:@"取消"
                               destructiveButtonTitle:nil
                                    otherButtonTitles:@"从相册中选取", @"拍照", nil];
    [imageSheet showInView:KEY_WINDOW];
}

#pragma mark UIActionSheetDelegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    if (0 == buttonIndex) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            __weak typeof(self) weakSelf = self;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [weakSelf presentViewController:self->imagePicker animated:YES completion:nil];
            }];
        }
    } else if (1 == buttonIndex) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.allowsEditing = YES;
            imagePicker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            __weak typeof(self) weakSelf = self;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [weakSelf presentViewController:self->imagePicker animated:YES completion:nil];
            }];
        }
    }
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage * yasuoImage = [AppTools scaleToSize:image size:CGSizeMake(image.size.width/2, image.size.height/2)];
    NSData * currentData = [self resetSizeOfImageData:yasuoImage maxSize:400];
    [self upLoadCommunityimage:currentData];
}


#pragma mark 保存用户资料
- (void)doGetUserProfile
{
    if ([AppTools stringContainsEmoji:self.nameTF.text]) {
        //有表情
        [self showAlert:@"昵称不允许有表情符号"];
        return;
    }
    if (self.nameTF.text.length == 0) {
        [self showAlert:@"请输入昵称"];
        return;
    }
    //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",UserProfile];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSLog(@"%@",tokenStr);
    NSLog(@"%@",self->headImageUrl);
    NSLog(@"%@",self.nameTF.text);
    
    NSDictionary *parameters = @{@"token":tokenStr,@"avatar":self->headImageUrl,@"nickname":self.nameTF.text};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"UserProfile responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.label.text = @"保存成功";
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            }completionBlock:^{
                [HUD removeFromSuperview];
                
                NSString * idStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"id"]];
                NSString * expires_in = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"expires_in"]];
                NSString * createtime = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"createtime"]];
                NSString * mobile = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"mobile"]];
                NSString * user_id = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"user_id"]];
                NSString * expiretime = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"expiretime"]];
                NSString * username = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"username"]];
                NSString * score = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"score"]];
                NSString * free_release = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"free_release"]];
                NSString * free_view = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"free_view"]];
                
                
                
                NSDictionary * newUserinfoDic = @{@"id":idStr,@"expires_in":expires_in,@"createtime":createtime,@"mobile":mobile,@"user_id":user_id,@"avatar":self->headImageUrl,@"expiretime":expiretime,@"username":user_id,@"user_id":username,@"nickname":self.nameTF.text,@"score":score,@"token":tokenStr,@"free_release":free_release,@"free_view":free_view};
                [userDefaultes setValue:newUserinfoDic forKey:@"userinfoDic"];
                
                [self.navc getNewUserInfo:self->headImageUrl nikeName:self.nameTF.text];
                [self.navigationController popViewControllerAnimated:YES];
            }];
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


- (void)upLoadCommunityimage:(NSData *)imageData
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSString *url=[NSString stringWithFormat:@"%@/index/Ajax/upload",RBDom];
    NSDictionary * parameters = @{@"token":tokenStr};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    // 在parameters里存放照片以外的对象
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
        // 这里的_photoArr是你存放图片的数组
        
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        // 要解决此问题，
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
        /*
         *该方法的参数
         1. appendPartWithFileData：要上传的照片[二进制流]
         2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
         3. fileName：要保存在服务器上的文件名
         4. mimeType：上传的文件的类型
         */
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"---上传进度--- %@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"```上传成功``` %@",responseObject);
        NSDictionary * dataDic = [responseObject objectForKey:@"data"];
        self->headImageUrl = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"url"]];
        [self.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",RBDom,self->headImageUrl]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"xxx上传失败xxx %@", error);
        
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

#pragma mark - 压缩图片
- (NSData *)resetSizeOfImageData:(UIImage *)sourceImage maxSize:(NSInteger)maxSize {
    //先判断当前质量是否满足要求，不满足再进行压缩
    __block NSData *finallImageData = UIImageJPEGRepresentation(sourceImage,1.0);
    NSUInteger sizeOrigin   = finallImageData.length;
    NSUInteger sizeOriginKB = sizeOrigin / 1000;
    
    if (sizeOriginKB <= maxSize) {
        return finallImageData;
    }
    //获取原图片宽高比
    CGFloat sourceImageAspectRatio = sourceImage.size.width/sourceImage.size.height;
    //先调整分辨率
    CGSize defaultSize = CGSizeMake(1024, 1024/sourceImageAspectRatio);
    UIImage *newImage = [self newSizeImage:defaultSize image:sourceImage];
    
    finallImageData = UIImageJPEGRepresentation(newImage,1.0);
    
    //保存压缩系数
    NSMutableArray *compressionQualityArr = [NSMutableArray array];
    CGFloat avg   = 1.0/250;
    CGFloat value = avg;
    for (int i = 250; i >= 1; i--) {
        value = i*avg;
        [compressionQualityArr addObject:@(value)];
    }
    
    /*
     调整大小
     说明：压缩系数数组compressionQualityArr是从大到小存储。
     */
    //思路：使用二分法搜索
    finallImageData = [self halfFuntion:compressionQualityArr image:newImage sourceData:finallImageData maxSize:maxSize];
    //如果还是未能压缩到指定大小，则进行降分辨率
    while (finallImageData.length == 0) {
        //每次降100分辨率
        CGFloat reduceWidth = 100.0;
        CGFloat reduceHeight = 100.0/sourceImageAspectRatio;
        if (defaultSize.width-reduceWidth <= 0 || defaultSize.height-reduceHeight <= 0) {
            break;
        }
        defaultSize = CGSizeMake(defaultSize.width-reduceWidth, defaultSize.height-reduceHeight);
        UIImage *image = [self newSizeImage:defaultSize
                                      image:[UIImage imageWithData:UIImageJPEGRepresentation(newImage,[[compressionQualityArr lastObject] floatValue])]];
        finallImageData = [self halfFuntion:compressionQualityArr image:image sourceData:UIImageJPEGRepresentation(image,1.0) maxSize:maxSize];
    }
    return finallImageData;
}
#pragma mark 调整图片分辨率/尺寸（等比例缩放）
- (UIImage *)newSizeImage:(CGSize)size image:(UIImage *)sourceImage {
    CGSize newSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
    
    CGFloat tempHeight = newSize.height / size.height;
    CGFloat tempWidth = newSize.width / size.width;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempWidth, sourceImage.size.height / tempWidth);
    } else if (tempHeight > 1.0 && tempWidth < tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempHeight, sourceImage.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [sourceImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark 二分法
- (NSData *)halfFuntion:(NSArray *)arr image:(UIImage *)image sourceData:(NSData *)finallImageData maxSize:(NSInteger)maxSize {
    NSData *tempData = [NSData data];
    NSUInteger start = 0;
    NSUInteger end = arr.count - 1;
    NSUInteger index = 0;
    
    NSUInteger difference = NSIntegerMax;
    while(start <= end) {
        index = start + (end - start)/2;
        
        finallImageData = UIImageJPEGRepresentation(image,[arr[index] floatValue]);
        
        NSUInteger sizeOrigin = finallImageData.length;
        NSUInteger sizeOriginKB = sizeOrigin / 1024;
        NSLog(@"当前降到的质量：%ld", (unsigned long)sizeOriginKB);
        NSLog(@"\nstart：%zd\nend：%zd\nindex：%zd\n压缩系数：%lf", start, end, (unsigned long)index, [arr[index] floatValue]);
        
        if (sizeOriginKB > maxSize) {
            start = index + 1;
        } else if (sizeOriginKB < maxSize) {
            if (maxSize-sizeOriginKB < difference) {
                difference = maxSize-sizeOriginKB;
                tempData = finallImageData;
            }
            if (index<=0) {
                break;
            }
            end = index - 1;
        } else {
            break;
        }
    }
    return tempData;
}

- (void)click_rightBtn
{
    [self doGetUserProfile];
}

- (void)click_back
{
    [self.navigationController popViewControllerAnimated:YES];
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
