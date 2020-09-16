//
//  UpLoadImageTestVC.m
//  KBTabbarController
//
//  Created by 李恒达 on 2020/9/1.
//  Copyright © 2020 kangbing. All rights reserved.
//

#import "UpLoadImageTestVC.h"
#import "LookBigImageViewController.h"
#import "SeeBigImageViewController.h"
#import "HZTableViewController.h"
#import "HZPhotoBrowser.h"
#import "SDWebImageManager.h"

@interface UpLoadImageTestVC ()<UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * navigationView;
@property (nonatomic, strong) UIScrollView * mainScrollView;
@property (nonatomic, strong) UIImageView * leftImageView;
@property (nonatomic, strong) UIImageView * rightImageView;
@property (nonatomic, strong) UIButton * leftBtn;
@property (nonatomic, strong) UIButton * rightBtn;
@property (nonatomic, strong) UIButton * uploadBtn;
@property (nonatomic, strong) UIButton * chekBtn;
@property (nonatomic, strong) UIButton * findBtn;
@property (nonatomic, strong) UIImageView * finishImageView;
@property (nonatomic, strong) UIButton * finishBtn;
@property (nonatomic, strong) UILabel * answerLabel;
@end

@implementation UpLoadImageTestVC{
    UIImagePickerController *imagePicker;
    UIButton * currentSender;
    NSMutableArray * powerImageArr;
    UIActionSheet * imageShet1;
    UIActionSheet * imageShet2;
    NSString * dataImageStr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigationView];
    [self initView];
    currentSender = self.leftBtn;
    powerImageArr = [NSMutableArray new];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden=YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getRootViewwController) name:@"click_PWLoginDismiss" object:nil];
}

- (void)getRootViewwController{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden=NO;
    
}

- (void)initNavigationView{
    self.navigationView = [FlanceTools viewCreateWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.view addSubview:self.navigationView];
    
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(0, STATUS_BAR_HEIGHT +((STATUS_BAR_HEIGHT + FitSizeH(8))/2 - FitSizeH(22)), FitSizeW(40), FitSizeH(44));
    [self.backBtn setImage:[UIImage imageNamed:@"fanhuio"] forState:UIControlStateNormal];
    [self.backBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(click_back) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview: self.backBtn];
}

- (void)initView{
    
    self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.navigationView.frame))];
    self.mainScrollView.backgroundColor = [UIColor whiteColor];
    self.mainScrollView.delegate = self;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.mainScrollView];
    
    self.titleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), 0, FitSizeW(200), FitSizeH(38)) Font:17.0f IsBold:YES Text:@"测试对比图片" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
    [self.mainScrollView addSubview: self.titleLabel];
    
    //左侧图片
    self.leftImageView = [FlanceTools imageViewCreateViewWithFrame:CGRectMake(SCREENWIDTH / 2 - FitSizeW(150), CGRectGetMaxY(self.titleLabel.frame) + FitSizeH(50), FitSizeW(120), FitSizeH(120)) ImageName:@"shangchuanzahop"];
    [self.mainScrollView addSubview: self.leftImageView];
    
    UILabel * leftTextLabel = [FlanceTools labelCreateWithFrame:CGRectMake(CGRectGetMinX(self.leftImageView.frame), CGRectGetMaxY(self.leftImageView.frame) + FitSizeH(20), FitSizeW(120), FitSizeH(20)) Font:13 IsBold:YES Text:@"材料标准" Color:RGBA(51, 51, 51, 1.0) Direction:NSTextAlignmentCenter];
    [self.mainScrollView addSubview: leftTextLabel];
    
    //左侧上传图片按钮
    self.leftBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(SCREENWIDTH / 2 - FitSizeW(150), CGRectGetMaxY(self.titleLabel.frame) + FitSizeH(50), FitSizeW(120), FitSizeH(120)) Title:@"" Font:16 IsBold:YES TitleColor:[UIColor whiteColor] TitleSelectColor:[UIColor whiteColor] ImageName:nil Target:self Action:@selector(click_leftBtn:)];
    [self.mainScrollView addSubview: self.leftBtn];
    
    //右侧图片
    self.rightImageView = [FlanceTools imageViewCreateViewWithFrame:CGRectMake(SCREENWIDTH / 2 + FitSizeW(30), CGRectGetMaxY(self.titleLabel.frame) + FitSizeH(50), FitSizeW(120), FitSizeH(120)) ImageName:@"shangchuanzahop"];
    [self.mainScrollView addSubview: self.rightImageView];
    
    UILabel * rightTextLabel = [FlanceTools labelCreateWithFrame:CGRectMake(CGRectGetMinX(self.rightImageView.frame), CGRectGetMaxY(self.rightImageView.frame) + FitSizeH(20), FitSizeW(120), FitSizeH(20)) Font:13 IsBold:YES Text:@"印刷图" Color:RGBA(51, 51, 51, 1.0) Direction:NSTextAlignmentCenter];
    [self.mainScrollView addSubview: rightTextLabel];
    
    //右侧上传图片按钮
    self.rightBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(SCREENWIDTH / 2 + FitSizeW(30), CGRectGetMaxY(self.titleLabel.frame) + FitSizeH(50), FitSizeW(120), FitSizeH(120)) Title:@"" Font:16 IsBold:YES TitleColor:[UIColor whiteColor] TitleSelectColor:[UIColor whiteColor] ImageName:nil Target:self Action:@selector(click_rightBtn:)];
    [self.mainScrollView addSubview: self.rightBtn];
    
    
    //上传按钮
    self.uploadBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(SCREENWIDTH / 2 - FitSizeW(120), CGRectGetMaxY(rightTextLabel.frame) + FitSizeH(10), FitSizeW(240), FitSizeH(35)) Title:@"上传" Font:16 IsBold:YES TitleColor:[UIColor whiteColor] TitleSelectColor:[UIColor whiteColor] ImageName:nil Target:self Action:@selector(click_uploadBtn:)];
    [self.mainScrollView addSubview: self.uploadBtn];
    self.uploadBtn.layer.cornerRadius = 5;
    self.uploadBtn.layer.masksToBounds = YES;
    [self.uploadBtn setBackgroundColor:RGBA(236, 83, 86, 1.0)];
    
    
    //对比按钮
    self.chekBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(SCREENWIDTH / 2 - FitSizeW(120), CGRectGetMaxY(self.uploadBtn.frame) + FitSizeH(30), FitSizeW(240), FitSizeH(35)) Title:@"比对" Font:16 IsBold:YES TitleColor:[UIColor whiteColor] TitleSelectColor:[UIColor whiteColor] ImageName:nil Target:self Action:@selector(click_doGetChek)];
    [self.mainScrollView addSubview: self.chekBtn];
    self.chekBtn.layer.cornerRadius = 5;
    self.chekBtn.layer.masksToBounds = YES;
    [self.chekBtn setBackgroundColor:RGBA(236, 83, 86, 1.0)];
    
    //点击查询按钮
    self.findBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(SCREENWIDTH / 2 - FitSizeW(120), CGRectGetMaxY(self.chekBtn.frame) + FitSizeH(30), FitSizeW(240), FitSizeH(35)) Title:@"查询" Font:16 IsBold:YES TitleColor:[UIColor whiteColor] TitleSelectColor:[UIColor whiteColor] ImageName:nil Target:self Action:@selector(click_doGetFind)];
    [self.mainScrollView addSubview: self.findBtn];
    self.findBtn.layer.cornerRadius = 5;
    self.findBtn.layer.masksToBounds = YES;
    [self.findBtn setBackgroundColor:RGBA(236, 83, 86, 1.0)];
    
    //对比结果图
    self.finishImageView = [FlanceTools imageViewCreateViewWithFrame:CGRectMake(SCREENWIDTH / 2 - FitSizeW(60), CGRectGetMaxY(self.findBtn.frame) + FitSizeH(50), FitSizeW(120), FitSizeH(120)) ImageName:nil];
    [self.mainScrollView addSubview: self.finishImageView];
    
    self.finishBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(SCREENWIDTH / 2 - FitSizeW(60), CGRectGetMaxY(self.findBtn.frame) + FitSizeH(50), FitSizeW(120), FitSizeH(120)) Title:@"" Font:16 IsBold:YES TitleColor:[UIColor whiteColor] TitleSelectColor:[UIColor whiteColor] ImageName:nil Target:self Action:@selector(click_finishBtn)];
    [self.mainScrollView addSubview: self.finishBtn];
    
    self.answerLabel = [FlanceTools labelCreateWithFrame:CGRectMake(CGRectGetMinX(self.finishImageView.frame), CGRectGetMaxY(self.finishImageView.frame) + FitSizeH(20), FitSizeW(120), FitSizeH(20)) Font:14 IsBold:YES Text:@"无差异" Color:RGBA(51, 51, 51, 1.0) Direction:NSTextAlignmentCenter];
    [self.mainScrollView addSubview: self.answerLabel];
    self.answerLabel.hidden = YES;
    
}

#pragma mark 点击左侧按钮
- (void)click_leftBtn:(UIButton *)sender
{
    NSLog(@"点击左侧按钮");
    currentSender = self.leftBtn;
    if (self.leftImageView.image != [UIImage imageNamed:@"shangchuanzahop"]) {
        [self click_ActionSheet:@"1"];
    }else{
        [self click_ActionSheet:@"0"];
    }
}

#pragma mark 点击右侧按钮
- (void)click_rightBtn:(UIButton *)sender
{
    NSLog(@"点击右侧按钮");
    currentSender = self.rightBtn;
    if (self.rightImageView.image != [UIImage imageNamed:@"shangchuanzahop"]) {
        [self click_ActionSheet:@"1"];
    }else{
        [self click_ActionSheet:@"0"];
    }
}

#pragma mark 点击上传图片按钮
- (void)click_uploadBtn:(UIButton*)sender
{
    NSLog(@"点击上传图片按钮");
    
    if (powerImageArr.count < 2) {
        [self showAlert:@"请选择图片"];
        return;
    }else if (powerImageArr.count > 2) {
        [powerImageArr removeObjectAtIndex:2];
        self.finishImageView.image = nil;
        [self upLoadCommunityimage];
    }else{
        [self upLoadCommunityimage];
    }
    
}

#pragma mark 点击结果图片
- (void)click_finishBtn
{
    NSLog(@"点击结果图片");
    if (powerImageArr.count < 2) {
        return;
    }
    if (_finishImageView.image == nil) {
    }else{
        if (powerImageArr.count == 3) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            LookBigImageViewController* navc = [[LookBigImageViewController alloc]init];
            navc.imageDataArr = powerImageArr;
            navc.index = @"2";
            [self.navigationController pushViewController:navc animated:YES];
        }else{
            UIImage * finishImage = self.finishImageView.image;
            [powerImageArr insertObject:finishImage atIndex:2];
            NSLog(@"powerImageArr==%@",powerImageArr);
            if (powerImageArr.count == 3) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                LookBigImageViewController* navc = [[LookBigImageViewController alloc]init];
                navc.imageDataArr = powerImageArr;
                navc.index = @"2";
                [self.navigationController pushViewController:navc animated:YES];
            }
        }
    }
}

#pragma  mark 点击对比
- (void)click_doGetChek
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self doGetCheck:@"0"];
}

#pragma  mark 点击查询
- (void)click_doGetFind
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self doGetCheck:@"1"];
}

- (void)click_ActionSheet:(NSString *)state
{
    if ([state isEqualToString:@"0"]) {
        imageShet1 = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选取", @"拍照", nil];
        [imageShet1 showInView:KEY_WINDOW];
    }else{
        imageShet2 = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选取", @"拍照", @"查看大图", nil];
        [imageShet2 showInView:KEY_WINDOW];
    }
    
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
    }else if (2 == buttonIndex){
        if (actionSheet != imageShet1) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            LookBigImageViewController* navc = [[LookBigImageViewController alloc]init];
            navc.imageDataArr = powerImageArr;
            navc.index = @"0";
            [self.navigationController pushViewController:navc animated:YES];
            
//            SeeBigImageViewController * navc = [[SeeBigImageViewController alloc]init];
//            navc.imageArr = powerImageArr;
//            [self.navigationController pushViewController:navc animated:YES];
        }
    }
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
           
       }];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (currentSender == self.leftBtn) {
        self.leftImageView.image = image;
        [powerImageArr insertObject:image atIndex:0];
    }else{
        self.rightImageView.image = image;
        [powerImageArr insertObject:image atIndex:1];
    }
}

- (void)upLoadCommunityimage
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[SDImageCache sharedImageCache] clearDisk];
    });
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 60;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    // 在parameters里存放照片以外的对象
    [manager POST:@"http://121.196.52.142:12233/api/index/upPython" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
        // 这里的_photoArr是你存放图片的数组
        for (int i = 0; i < self->powerImageArr.count; i++) {
            UIImage *image = self->powerImageArr[i];
            UIImage * yasuoImage = [AppTools scaleToSize:image size:CGSizeMake(500, 500)];
            NSData * currentData = [self resetSizeOfImageData:yasuoImage maxSize:300];
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
            [formData appendPartWithFileData:currentData name:@"img[]" fileName:fileName mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"---上传进度--- %@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"```上传成功``` %@",responseObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showAlert:@"上传成功"];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"xxx上传失败xxx %@", error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showAlert:@"上传失败"];
    }];
    
}



#pragma mark 查询对比
- (void)doGetCheck:(NSString *)type
{   //创建请求地址
    NSString *url = @"http://121.196.52.142:12233/api/index/getCheck";
    NSDictionary * parameters = @{@"type":type};
    //AFN管理者调用POST请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"NoticeLists responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if ([type isEqualToString:@"1"]) {
                NSString * dataImageStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"data"]];
                self->dataImageStr = dataImageStr;
                NSData * ImgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:dataImageStr]];
                self.finishImageView.image = [UIImage imageWithData:ImgData];
            }
            
//            [self.finishImageView sd_setImageWithURL:[NSURL URLWithString:dataImageStr] placeholderImage:[UIImage imageNamed:@"商品占位图"]];
            
//            [self.finishImageView sd_setImageWithURL:[NSURL URLWithString:dataImageStr]
//            placeholderImage:[UIImage imageNamed:@"商品占位图"]
//                     options:SDWebImageRefreshCached];
            
            
            
//            self.answerLabel.hidden = NO;
            
            
            
            
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
    manager.requestSerializer.timeoutInterval = 180.0f;
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



- (void)click_back
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
