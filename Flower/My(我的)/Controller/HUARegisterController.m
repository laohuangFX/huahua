//
//  HUARegisterController.m
//  Flower
//
//  Created by 程召华 on 16/1/11.
//  Copyright © 2016年 readchen.com. All rights reserved.
//
#define Send_verify  @"privilege/send_verify"
#define User_create  @"privilege/user_create"
#define Login  @"privilege/login"


#import "HUARegisterController.h"
#import "HUAMyController.h"
#import "HUAUserDetailInfo.h"

@interface HUARegisterController ()<UITextFieldDelegate>
{
    __block int         leftTime;
    __block NSTimer     *timer;
}
@property (nonatomic, strong) UITextField *phoneNumberTF;

@property (nonatomic, strong) UITextField *verificationCodeTF;

@property (nonatomic, strong) UITextField *firstPassWordTF;

@property (nonatomic, strong) UITextField *secondPassWordTF;

@property (nonatomic, strong) UIButton *sendVerificationCodeButton;

@property (nonatomic, strong) UIButton *maleButton;

@property (nonatomic, strong) UIButton *femaleButton;

@property (nonatomic, strong) UIButton *registButton;

@property (nonatomic, strong) HUAUserInfo *userInfo;

@property (nonatomic, strong) NSString *code;

@end

@implementation HUARegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.view.backgroundColor = HUAColor(0xFFFFFF);
    [self setRegisterPage];
}

- (void)setRegisterPage {
    UIView *separateLine1 = [[UIView alloc] initWithFrame:CGRectMake(hua_scale(20), hua_scale(53), hua_scale(280), 0.5)];
    separateLine1.backgroundColor = HUAColor(0xd0d0d0);
    [self.view addSubview:separateLine1];
    
    UIView *separateLine2 = [[UIView alloc] initWithFrame:CGRectMake(hua_scale(20), hua_scale(100), hua_scale(170), 0.5)];
    separateLine2.backgroundColor = HUAColor(0xd0d0d0);
    [self.view addSubview:separateLine2];
    
    UIView *separateLine3 = [[UIView alloc] initWithFrame:CGRectMake(hua_scale(20), hua_scale(147), hua_scale(280), 0.5)];
    separateLine3.backgroundColor = HUAColor(0xd0d0d0);
    [self.view addSubview:separateLine3];
    
    UIView *separateLine4 = [[UIView alloc] initWithFrame:CGRectMake(hua_scale(20), hua_scale(194), hua_scale(280), 0.5)];
    separateLine4.backgroundColor = HUAColor(0xd0d0d0);
    [self.view addSubview:separateLine4];
    
    
    
    CGRect phoneNumberFrame = CGRectMake(hua_scale(20), hua_scale(14), hua_scale(280), hua_scale(39));
    self.phoneNumberTF = [UITextField textFieldWithFrame:phoneNumberFrame image:@"phone" placeholder:@"输入手机号"];
    //self.phoneNumberTF.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneNumberTF.returnKeyType = UIReturnKeyNext;
    self.phoneNumberTF.delegate = self;
    [self.view addSubview:self.phoneNumberTF];
    
    
    CGRect verificationCodeFrame = CGRectMake(hua_scale(20), hua_scale(61), hua_scale(170), hua_scale(39));
    self.verificationCodeTF = [UITextField textFieldWithFrame:verificationCodeFrame image:@"verification" placeholder:@"输入验证码"];
    //self.verificationCodeTF.keyboardType = UIKeyboardTypeNumberPad;
    self.verificationCodeTF.returnKeyType = UIReturnKeyNext;
    self.verificationCodeTF.delegate = self;
    [self.view addSubview:self.verificationCodeTF];
    
    
    self.sendVerificationCodeButton = [UIButton buttonWithType:0];
    self.sendVerificationCodeButton.frame = CGRectMake(hua_scale(200), hua_scale(65), hua_scale(100), hua_scale(37));
    [self.sendVerificationCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [self.sendVerificationCodeButton setTitleColor:HUAColor(0x4da800) forState:UIControlStateNormal];
    self.sendVerificationCodeButton.titleLabel.font = [UIFont systemFontOfSize:hua_scale(13)];
    self.sendVerificationCodeButton.layer.borderColor = HUAColor(0x4da800).CGColor;
    self.sendVerificationCodeButton.layer.borderWidth = 0.5;
    [self.sendVerificationCodeButton addTarget:self action:@selector(clickToSendVerificationCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sendVerificationCodeButton];
    
    
    
    CGRect firstPasswordFrame = CGRectMake(hua_scale(20), hua_scale(108), hua_scale(280), hua_scale(39));
    self.firstPassWordTF = [UITextField textFieldWithFrame:firstPasswordFrame image:@"password" placeholder:@"输入密码"];
    self.firstPassWordTF.returnKeyType = UIReturnKeyNext;
    self.firstPassWordTF.delegate = self;
    self.firstPassWordTF.secureTextEntry = YES;
    [self.view addSubview:self.firstPassWordTF];
    
    
    CGRect secondPasswordFrame = CGRectMake(hua_scale(20), hua_scale(155), hua_scale(280), hua_scale(39));
    self.secondPassWordTF = [UITextField textFieldWithFrame:secondPasswordFrame image:@"password" placeholder:@"重复密码"];
    self.secondPassWordTF.returnKeyType = UIReturnKeyDone;
    self.secondPassWordTF.delegate = self;
    self.secondPassWordTF.secureTextEntry = YES;
    [self.view addSubview:self.secondPassWordTF];
    
    self.maleButton = [UIButton buttonWithType:0];
    self.maleButton.frame = CGRectMake(hua_scale(20), hua_scale(210), hua_scale(135), hua_scale(40));
    [self.maleButton setTitle:@"男" forState:UIControlStateNormal];
    self.maleButton.tag = 1;
    [self.maleButton setTitleColor:HUAColor(0x4da800) forState:UIControlStateSelected];
    [self.maleButton setTitleColor:HUAColor(0xd0d0d0) forState:UIControlStateNormal];
    [self.maleButton setBackgroundImage:[UIImage imageNamed:@"register"] forState:UIControlStateNormal];
    [self.maleButton setBackgroundImage:[UIImage imageNamed:@"register_select"] forState:UIControlStateSelected];
    self.maleButton.titleLabel.font = [UIFont systemFontOfSize:hua_scale(13)];
    [self.maleButton addTarget:self action:@selector(clickToChooseSex:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.maleButton];
    
    self.femaleButton = [UIButton buttonWithType:0];
    self.femaleButton.frame = CGRectMake(hua_scale(165), hua_scale(210), hua_scale(135), hua_scale(40));
    [self.femaleButton setTitle:@"女" forState:UIControlStateNormal];
    self.femaleButton.tag = 0;
    [self.femaleButton setTitleColor:HUAColor(0x4da800) forState:UIControlStateSelected];
    [self.femaleButton setTitleColor:HUAColor(0xd0d0d0) forState:UIControlStateNormal];
    [self.femaleButton setBackgroundImage:[UIImage imageNamed:@"register"] forState:UIControlStateNormal];
    [self.femaleButton setBackgroundImage:[UIImage imageNamed:@"register_select"] forState:UIControlStateSelected];
    self.femaleButton.titleLabel.font = [UIFont systemFontOfSize:hua_scale(13)];
    [self.femaleButton addTarget:self action:@selector(clickToChooseSex:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.femaleButton];
    
    self.registButton = [UIButton buttonWithType:0];
    self.registButton.frame = CGRectMake(hua_scale(20), hua_scale(275), hua_scale(280), hua_scale(40));
    [self.registButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.registButton setTitleColor:HUAColor(0xffffff) forState:UIControlStateNormal];
    self.registButton.titleLabel.font = [UIFont systemFontOfSize:hua_scale(15)];
    self.registButton.backgroundColor = HUAColor(0x4da800);
    [self.registButton addTarget:self action:@selector(clickToRegister:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registButton];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


//点击发送验证码
- (void)clickToSendVerificationCode:(UIButton *)sender {
    [self.view endEditing:YES];
    if (![HUAMobileNumber isMobileNumber:self.phoneNumberTF.text]) {
        [HUAMBProgress MBProgressFromWindowWithLabelText:@"请输入有效手机号码"];


    }else {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *url = [HUA_URL stringByAppendingPathComponent:Send_verify];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"phone"] = self.phoneNumberTF.text;
        parameters[@"type"] = @"1";
        [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            HUALog(@"asdasdd%@",responseObject);
            self.code = [[[NSNumberFormatter alloc] init] stringFromNumber:responseObject[@"info"]];
            if (responseObject == nil) {
                [HUAMBProgress MBProgressFromWindowWithLabelText:@"该手机号已经注册过"];
            }else if ([[[[NSNumberFormatter alloc]init] stringFromNumber:responseObject[@"code"]] isEqualToString:@"1"]) {
                [HUAMBProgress MBProgressFromWindowWithLabelText:@"该手机号已经注册过"];
            }else {
                [HUAMBProgress MBProgressFromWindowWithLabelText:@"已经发送验证码" dispatch_get_main_queue:^{
                    leftTime = 60;
                    [self.sendVerificationCodeButton setEnabled:NO];
                    [self.sendVerificationCodeButton setTitle:[NSString stringWithFormat:@"%d秒后可以重新发送",leftTime] forState:UIControlStateNormal];
                    [self.sendVerificationCodeButton setTitle:[NSString stringWithFormat:@"%d秒后可以重新发送",leftTime] forState:UIControlStateDisabled];
                    if(timer)
                        [timer invalidate];
                    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
                }];
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            HUALog(@"%@",error);
            [HUAMBProgress MBProgressFromWindowWithLabelText:@"请检查网络设置"];
            return ;
        }];
    }
}

- (void)timerAction
{
    leftTime--;
    if(leftTime<=0)
    {
        [self.sendVerificationCodeButton setEnabled:YES];
        [self.sendVerificationCodeButton setEnabled:YES];
        [self.sendVerificationCodeButton setTitle:@"点击重新发送" forState:UIControlStateNormal];
        [self.sendVerificationCodeButton setTitle:@"点击重新发送" forState:UIControlStateDisabled];
        
        
    }
    else
    {
        
        [self.sendVerificationCodeButton setEnabled:NO];
        [self.sendVerificationCodeButton setTitle:[NSString stringWithFormat:@"%d秒后重新发送",leftTime] forState:UIControlStateNormal];
        [self.sendVerificationCodeButton setTitle:[NSString stringWithFormat:@"%d秒后重新发送",leftTime] forState:UIControlStateDisabled];
        
    }
}


UIButton *lastBtn = nil;
- (void)clickToChooseSex:(UIButton *)sender {
    [self.view endEditing:YES];
    if (lastBtn) {
        lastBtn.selected = NO;
    }
    sender.selected = YES;
    lastBtn = sender;
}



//点击注册
- (void)clickToRegister:(UIButton *)sender {
    [self.view endEditing:YES];
    if ([self.phoneNumberTF.text isEqualToString:@""] || [self.verificationCodeTF.text isEqualToString:@""] || [self.firstPassWordTF.text isEqualToString:@""] || [self.secondPassWordTF.text isEqualToString:@""] || (lastBtn != self.maleButton && lastBtn != self.femaleButton)) {
        [HUAMBProgress MBProgressFromWindowWithLabelText:@"请完善注册信息"];
    } else if (self.firstPassWordTF.text != self.secondPassWordTF.text) {
      [HUAMBProgress MBProgressFromWindowWithLabelText:@"输入的密码不一致"];
    } else if (![self.verificationCodeTF.text isEqualToString:self.code]) {
      [HUAMBProgress MBProgressFromWindowWithLabelText:@"验证码不正确"];
    } else if ((self.firstPassWordTF.text.length < 6 || self.firstPassWordTF.text.length > 20) || (self.secondPassWordTF.text.length < 6 || self.secondPassWordTF.text.length > 20)) {
        [HUAMBProgress MBProgressFromWindowWithLabelText:@"请输入6-20位字符密码"];
    }
    else{
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *url = [HUA_URL stringByAppendingPathComponent:User_create];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSString *sexTag = [NSString stringWithFormat:@"%ld",(long)lastBtn.tag];
        NSString *password= [MyMD5 md5:self.firstPassWordTF.text];
        parameters[@"phone"] = self.phoneNumberTF.text;
        parameters[@"password"] = password;
        parameters[@"sex"] = sexTag;
        parameters[@"type"] = @"1";
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, NSDictionary *responseObject) {
            HUALog(@"response%@",responseObject);
            
            HUAUserInfo *useInfo = [HUAUserInfo userInfoWithDictionary:responseObject[@"info"]];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSString *url = [HUA_URL stringByAppendingPathComponent:Login];

            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"phone"] = useInfo.phone;
            parameters[@"password"] = useInfo.password;
            HUALog(@"userInfo:%@,%@",useInfo.phone,useInfo.password);
            [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                HUALog(@"response%@",responseObject);
                if ([[[[NSNumberFormatter alloc]init] stringFromNumber:responseObject[@"code"]] isEqualToString:@"0"]) {
                    [HUAMBProgress MBProgressFromWindowWithLabelText:@"注册成功,正在跳转" dispatch_get_main_queue:^{
                        NSString *token = responseObject[@"token"];
                        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
                        HUAUserDetailInfo *detailInfo = [HUAUserDetailInfo userDetailInfoWithDictionary:responseObject[@"info"]];
                        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:detailInfo];
                        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"data"];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }];
                }
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                HUALog(@"error%@",error);
               [HUAMBProgress MBProgressFromWindowWithLabelText:@"请检查网络设置"];
                return ;
                
            }];
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            HUALog(@"%@",error);
            [HUAMBProgress MBProgressFromWindowWithLabelText:@"请检查网络设置"];
            return ;
        }];
        
    }
    
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    BOOL retValue = NO;
    if (textField == self.phoneNumberTF) {
        [self.verificationCodeTF becomeFirstResponder];
        retValue = NO;
    } else if (textField == self.verificationCodeTF)
    {
        [self.firstPassWordTF becomeFirstResponder];
        retValue = NO;
    } else if (textField == self.firstPassWordTF)
    {
        [self.secondPassWordTF becomeFirstResponder];
    } else {
        [self.secondPassWordTF resignFirstResponder];
    }
    
    
    return retValue;
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
