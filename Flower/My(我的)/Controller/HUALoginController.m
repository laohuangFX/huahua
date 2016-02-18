//
//  HUALoginController.m
//  Flower
//
//  Created by 程召华 on 16/1/11.
//  Copyright © 2016年 readchen.com. All rights reserved.
//
#define Login @"privilege/login"

#import "HUALoginController.h"
#import "HUARegisterController.h"
#import "HUATabBarController.h"
#import "HUAUserInfo.h"
#import "HUAUserDetailInfo.h"
#import "HUAForgetPasswordController.h"
#import "HUAMyController.h"

@interface HUALoginController ()<UITextFieldDelegate>
//上部视图
@property (nonatomic, strong) UIImageView *topImageView;
//头像
@property (nonatomic, strong) UIImageView *headPortraitImageView;
//用户输入框
@property (nonatomic, strong) UITextField *userNameTF;
//密码输入框
@property (nonatomic, strong) UITextField *passWordTF;
//分割线
@property (nonatomic, strong) UIView *upSeparateLine;
//分割线
@property (nonatomic, strong) UIView *downSeparateLine;
//登录按钮
@property (nonatomic, strong) UIButton *loginButton;
//注册按钮
@property (nonatomic, strong) UIButton *registerButton;
//忘记密码按钮
@property (nonatomic, strong) UIButton *forgetPassWordButton;
//游客模式登录按钮
@property (nonatomic, strong) UIButton *visitorModeLoginButton;
@end

@implementation HUALoginController

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.hidesBottomBarWhenPushed = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HUAColor(0xFFFFFF);
//    UIImageView *logoIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logoIcon];
   self.tabBarController.tabBar.hidden = YES;
    UIBarButtonItem *backButton = [UIBarButtonItem itemWithTarget:self action:@selector(backAction) image:@"back_green" highImage:@"back_green" text:@"返回"];
    UIBarButtonItem *leftSpace = [UIBarButtonItem leftSpace:hua_scale(-10)];
    backButton.tintColor = HUAColor(0x47A300);
    self.navigationItem.leftBarButtonItems = @[leftSpace, backButton];
    [self setLoginPage];
}

//判断登录页面是从哪个页面推出
- (void)backAction{
    NSArray *vcsArray = [self.navigationController viewControllers];
    NSInteger vcCount = vcsArray.count;
    UIViewController *lastVC = vcsArray[vcCount-2];
    if (![lastVC isKindOfClass:[HUAMyController class]]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        
        self.tabBarController.selectedIndex = 2;
        self.tabBarController.tabBar.hidden = NO;
    }
    

    
}
#pragma mark -- 登录页面搭建
- (void)setLoginPage {
    self.topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, hua_scale(114))];
    self.topImageView.image = [UIImage imageNamed:@"background"];
    [self.view addSubview:self.topImageView];
    
    self.headPortraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(hua_scale(130), hua_scale(84), hua_scale(60), hua_scale(60))];
    self.headPortraitImageView.image = [UIImage imageNamed:@"headPortrait"];
    [self.view addSubview:self.headPortraitImageView];
    
    CGRect userNameFrame = CGRectMake(hua_scale(35), hua_scale(172), hua_scale(250), hua_scale(37));
    self.userNameTF = [UITextField textFieldWithFrame:userNameFrame image:@"my" placeholder: @"请输入用户名"];
    //self.userNameTF.keyboardType = UIKeyboardTypeNumberPad;
    self.userNameTF.returnKeyType = UIReturnKeyNext;
    self.userNameTF.delegate = self;
    [self.view addSubview:self.userNameTF];
    
    self.upSeparateLine = [[UIView alloc] initWithFrame:CGRectMake(hua_scale(35), hua_scale(209), hua_scale(250), 0.5)];
    self.upSeparateLine.backgroundColor = HUAColor(0xd0d0d0);
    [self.view addSubview:self.upSeparateLine];
    
    
    CGRect passWordFrame = CGRectMake(hua_scale(35), hua_scale(217), hua_scale(250), hua_scale(37));
    self.passWordTF = [UITextField textFieldWithFrame:passWordFrame image:@"password" placeholder:@"输入密码"];
    self.passWordTF.returnKeyType = UIReturnKeyDone;
    self.passWordTF.delegate = self;
    self.passWordTF.secureTextEntry = YES;
    [self.view addSubview:self.passWordTF];

    self.downSeparateLine = [[UIView alloc] initWithFrame:CGRectMake(hua_scale(35), hua_scale(254), hua_scale(250), 0.5)];
    self.downSeparateLine.backgroundColor = HUAColor(0xd0d0d0);
    [self.view addSubview:self.downSeparateLine];
    
    
    self.loginButton = [UIButton buttonWithType:0];
    self.loginButton.frame = CGRectMake(hua_scale(35), hua_scale(280), hua_scale(250), hua_scale(40));
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    self.loginButton.backgroundColor = HUAColor(0x4da800);
    [self.loginButton setTitleColor:HUAColor(0xFFFFFF) forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:hua_scale(15)];
    [self.loginButton addTarget:self action:@selector(clickToLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    
    self.registerButton = [UIButton buttonWithType:0];
    self.registerButton.frame = CGRectMake(hua_scale(35), hua_scale(330), hua_scale(250), hua_scale(40));
    [self.registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerButton setTitleColor:HUAColor(0x333333) forState:UIControlStateNormal];
    self.registerButton.titleLabel.font = [UIFont systemFontOfSize:hua_scale(15)];
    self.registerButton.layer.borderWidth = 0.5;
    self.registerButton.layer.borderColor = HUAColor(0xd0d0d0).CGColor;
    [self.registerButton addTarget:self action:@selector(clickToRegister:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerButton];
    
    
    self.forgetPassWordButton = [UIButton buttonWithType:0];
    self.forgetPassWordButton.frame = CGRectMake(hua_scale(35), hua_scale(388), hua_scale(50), hua_scale(12));
    [self.forgetPassWordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [self.forgetPassWordButton setTitleColor:HUAColor(0x999999) forState:UIControlStateNormal];
    self.forgetPassWordButton.titleLabel.font = [UIFont systemFontOfSize:hua_scale(12)];
    [self.forgetPassWordButton addTarget:self action:@selector(clickToRetrievePassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.forgetPassWordButton];
    
    self.visitorModeLoginButton = [UIButton buttonWithType:0];
    self.visitorModeLoginButton.frame = CGRectMake(screenWidth - hua_scale(107), hua_scale(388), hua_scale(72), hua_scale(12));
    [self.visitorModeLoginButton setTitle:@"游客模式登录" forState:UIControlStateNormal];
    [self.visitorModeLoginButton setTitleColor:HUAColor(0x494949) forState:UIControlStateNormal];
    self.visitorModeLoginButton.titleLabel.font = [UIFont systemFontOfSize:hua_scale(12)];
    [self.visitorModeLoginButton addTarget:self action:@selector(clickToVisitorModeLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.visitorModeLoginButton];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
     [self.view endEditing:YES];
}


//登录
- (void)clickToLogin:(UIButton *)sender {
    if (self.userNameTF.text.length == 0 || self.passWordTF.text.length == 0) {

        [HUAMBProgress MBProgressFromWindowWithLabelText:@"用户名或密码不能为空！"];
    } else if (![HUAMobileNumber isMobileNumber:self.userNameTF.text]) {
        [HUAMBProgress MBProgressFromWindowWithLabelText:@"请输入有效的手机号"];
        [HUAMBProgress MBProgressFromView:self.view andLabelText:@"用户名或密码不能为空！"];
    } else if (![HUAMobileNumber isMobileNumber:self.userNameTF.text]) {
        [HUAMBProgress MBProgressFromView:self.view andLabelText:@"请输入有效的手机号"];

    }
    else {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *url = [HUA_URL stringByAppendingPathComponent:Login];
        NSString *password = [MyMD5 md5:self.passWordTF.text];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"phone"] = self.userNameTF.text;
        parameters[@"password"] = password;
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[[[NSNumberFormatter alloc]init] stringFromNumber:responseObject[@"code"]] isEqualToString:@"8"]) {
                [HUAMBProgress MBProgressFromWindowWithLabelText:@"账户不存在或密码错误！"];
                return ;
            }else {
                [HUAMBProgress MBProgressFromWindowWithLabelText:@"登录成功!正在跳转" dispatch_get_main_queue:^{
                    HUALog(@"%@",responseObject);
                    NSString *token = responseObject[@"token"];
                    HUALog(@"token=%@",token);
                    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
                    HUAUserDetailInfo *detailInfo = [HUAUserDetailInfo userDetailInfoWithDictionary:responseObject[@"info"]];
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:detailInfo];
                    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"data"];
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"popCenter" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            HUALog(@"vsdfdsfsf%@",error);
            [HUAMBProgress MBProgressFromWindowWithLabelText:@"请检查网络设置"];
            return ;
        }];
    }
}
//注册
- (void)clickToRegister:(UIButton *)sender {
    HUARegisterController *registerViewController = [[HUARegisterController alloc] init];

    [self.navigationController pushViewController:registerViewController animated:YES];
}
//忘记密码
- (void)clickToRetrievePassword:(UIButton *)sender {
    HUALog(@"找回密码");
    HUAForgetPasswordController *forgetVC = [HUAForgetPasswordController new];
    [self.navigationController pushViewController:forgetVC animated:YES];
}
//游客登录
- (void)clickToVisitorModeLogin:(UIButton *)sender {
     UIWindow *window = [UIApplication sharedApplication].keyWindow;
    HUATabBarController *tabBarVC = [[HUATabBarController alloc] init];
    tabBarVC.selectedIndex = 2;
    window.rootViewController= tabBarVC;
    HUALog(@"游客登录");
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL retValue = NO;
    if (textField == self.userNameTF) {
        [self.passWordTF becomeFirstResponder];
        retValue = NO;
    }else {
        [self.passWordTF resignFirstResponder];
    }
    
    return NO;
}

@end
