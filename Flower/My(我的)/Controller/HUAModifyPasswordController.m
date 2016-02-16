//
//  HUAModifyPasswordController.m
//  Flower
//
//  Created by 程召华 on 16/1/23.
//  Copyright © 2016年 readchen.com. All rights reserved.
//
#define Send_verify  @"privilege/send_verify"
#define Is_registe   @"privilege/is_register"
#import "HUAMyController.h"
#import "HUAModifyPasswordController.h"
#import "HUANewPasswordController.h"

@interface HUAModifyPasswordController ()<UITextFieldDelegate>
{
    __block int         leftTime;
    __block NSTimer     *timer;
}
@property (nonatomic, strong) UITextField *phoneNumberTF;

@property (nonatomic, strong) UITextField *verificationCodeTF;

@property (nonatomic, strong) UIButton *sendVerificationCodeButton;

@property (nonatomic, strong) NSString *code;
@end

@implementation HUAModifyPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HUAColor(0xffffff);
    self.title = @"修改密码";
    [self createView];
}

- (void)createView {
    UIView *separateLine1 = [[UIView alloc] initWithFrame:CGRectMake(hua_scale(20), hua_scale(53), hua_scale(280), 0.5)];
    separateLine1.backgroundColor = HUAColor(0xd0d0d0);
    [self.view addSubview:separateLine1];
    
    UIView *separateLine2 = [[UIView alloc] initWithFrame:CGRectMake(hua_scale(20), hua_scale(100), hua_scale(170), 0.5)];
    separateLine2.backgroundColor = HUAColor(0xd0d0d0);
    [self.view addSubview:separateLine2];
    
    CGRect phoneNumberFrame = CGRectMake(hua_scale(20), hua_scale(14), hua_scale(280), hua_scale(39));
    self.phoneNumberTF = [UITextField textFieldWithFrame:phoneNumberFrame image:@"phone" placeholder:@"输入手机号"];
    //self.phoneNumberTF.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneNumberTF.returnKeyType = UIReturnKeyNext;
    self.phoneNumberTF.delegate = self;
    [self.view addSubview:self.phoneNumberTF];
    
    
    CGRect verificationCodeFrame = CGRectMake(hua_scale(20), hua_scale(61), hua_scale(170), hua_scale(39));
    self.verificationCodeTF = [UITextField textFieldWithFrame:verificationCodeFrame image:@"verification" placeholder:@"输入验证码"];
    self.verificationCodeTF.returnKeyType = UIReturnKeyDone;
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
    
    

    CGRect nextStepFrame = CGRectMake(hua_scale(20), hua_scale(125), screenWidth-hua_scale(40), hua_scale(40));

    UIButton *nextStepButton = [UIButton buttonWithFrame:nextStepFrame title:@"下一步" image:nil font:hua_scale(15) titleColor:HUAColor(0xffffff)];
    [nextStepButton addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    nextStepButton.backgroundColor = HUAColor(0x4da800);
    [self.view addSubview:nextStepButton];
}

- (void)nextStep:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.phoneNumberTF.text.length == 0 || self.verificationCodeTF.text.length == 0) {
        [HUAMBProgress MBProgressFromWindowWithLabelText:@"请输入手机号或者验证码"];
    }else if (![self.verificationCodeTF.text isEqualToString:self.code]){
        [HUAMBProgress MBProgressFromWindowWithLabelText:@"验证码不正确"];
    }else {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *url = [HUA_URL stringByAppendingPathComponent:Is_registe];
        NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
        parameter[@"phone"] = self.phoneNumberTF.text;
        [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            HUALog(@"%@",responseObject);
            [HUAMBProgress MBProgressFromWindowWithLabelText:@"手机验证成功，正在跳转"  dispatch_get_main_queue:^{
                HUANewPasswordController *newPasswordVC = [HUANewPasswordController new];
                newPasswordVC.old_password = responseObject[@"info"][0][@"password"];
                newPasswordVC.phoneNumber = self.phoneNumberTF.text;
                [self.navigationController pushViewController:newPasswordVC animated:YES];
            }];
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            HUALog(@"%@",error);
            [HUAMBProgress MBProgressFromWindowWithLabelText:@"请检查网络设置"];
            return ;

        }];
   };

}


- (void)clickToSendVerificationCode:(UIButton *)sender {
    [self.view endEditing:YES];

    if (![HUAMobileNumber isMobileNumber:self.phoneNumberTF.text]) {
        [HUAMBProgress MBProgressFromWindowWithLabelText:@"请输入有效的手机号"];

    } else {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *url = [HUA_URL stringByAppendingPathComponent:Send_verify];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"phone"] = self.phoneNumberTF.text;
        [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            self.code = [[[NSNumberFormatter alloc] init] stringFromNumber:responseObject[@"info"]];
            HUALog(@"asdasdd%@,,,,%@",responseObject,self.code);
            if ([[[[NSNumberFormatter alloc] init] stringFromNumber:responseObject[@"code"]] isEqualToString:@"3"]) {
                [HUAMBProgress MBProgressFromWindowWithLabelText:@"未注册的手机号,请确认"];
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


- (void)timerAction{
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    BOOL retValue = NO;
    if (textField == self.phoneNumberTF) {
        [self.verificationCodeTF becomeFirstResponder];
        retValue = NO;
    } else
    {
        [self.verificationCodeTF resignFirstResponder];
        retValue = NO;
        
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
