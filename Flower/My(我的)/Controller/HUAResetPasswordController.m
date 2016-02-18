//
//  HUAResetPasswordController.m
//  Flower
//
//  Created by 程召华 on 16/1/23.
//  Copyright © 2016年 readchen.com. All rights reserved.
//
#define Password_reset @"privilege/password_reset"
#import "HUAResetPasswordController.h"
#import "HUALoginController.h"
@interface HUAResetPasswordController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *firstPassWordTF;

@property (nonatomic, strong) UITextField *secondPassWordTF;
@end

@implementation HUAResetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HUAColor(0xffffff);
    self.title = @"重新设置密码";
    [self createView];
}

- (void)createView {
    UIView *separateLine1 = [[UIView alloc] initWithFrame:CGRectMake(hua_scale(20), hua_scale(53), screenWidth - hua_scale(40), 0.5)];
    separateLine1.backgroundColor = HUAColor(0xd0d0d0);
    [self.view addSubview:separateLine1];
    
    UIView *separateLine2 = [[UIView alloc] initWithFrame:CGRectMake(hua_scale(20), hua_scale(100), screenWidth - hua_scale(40), 0.5)];
    separateLine2.backgroundColor = HUAColor(0xd0d0d0);
    [self.view addSubview:separateLine2];

    
    CGRect firstPasswordFrame = CGRectMake(hua_scale(20), hua_scale(14), screenWidth - hua_scale(40), hua_scale(39));
    self.firstPassWordTF = [UITextField textFieldWithFrame:firstPasswordFrame image:@"password" placeholder:@"输入新密码"];
    self.firstPassWordTF.returnKeyType = UIReturnKeyNext;
    self.firstPassWordTF.delegate = self;
    self.firstPassWordTF.secureTextEntry = YES;
    [self.view addSubview:self.firstPassWordTF];
    
    
    CGRect secondPasswordFrame = CGRectMake(hua_scale(20), hua_scale(61), screenWidth - hua_scale(40), hua_scale(39));
    self.secondPassWordTF = [UITextField textFieldWithFrame:secondPasswordFrame image:@"password" placeholder:@"重复密码"];
    self.secondPassWordTF.returnKeyType = UIReturnKeyDone;
    self.secondPassWordTF.delegate = self;
    self.secondPassWordTF.secureTextEntry = YES;
    [self.view addSubview:self.secondPassWordTF];
    
    CGRect makeSureFrame = CGRectMake(hua_scale(20), hua_scale(125), screenWidth-hua_scale(40), hua_scale(40));
    UIButton *makeSureButton = [UIButton buttonWithFrame:makeSureFrame title:@"确认" image:nil font:hua_scale(15) titleColor:HUAColor(0xffffff)];
    [makeSureButton addTarget:self action:@selector(makeSure:) forControlEvents:UIControlEventTouchUpInside];
    makeSureButton.backgroundColor = HUAColor(0x4da800);
    [self.view addSubview:makeSureButton];
}


- (void)makeSure:(UIButton *)sender {
    if (self.firstPassWordTF.text.length == 0 || self.secondPassWordTF.text.length == 0) {
        [HUAMBProgress MBProgressFromWindowWithLabelText:@"请输入密码"];
    }else if (![self.firstPassWordTF.text isEqualToString:self.secondPassWordTF.text]){
        [HUAMBProgress MBProgressFromWindowWithLabelText:@"两次密码不一样,请验证"];
    }else if ((self.firstPassWordTF.text.length < 6 || self.firstPassWordTF.text.length > 15) || (self.secondPassWordTF.text.length < 6 || self.secondPassWordTF.text.length > 15)) {
        [HUAMBProgress MBProgressFromWindowWithLabelText:@"请输入6-15位字符密码"];
    }else {

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *url = [HUA_URL stringByAppendingPathComponent:Password_reset];
        NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
        NSString *password = [MyMD5 md5:self.firstPassWordTF.text];
        parameter[@"password"] = password;
        parameter[@"phone"] = self.phoneNumber;
        parameter[@"old_password"] = self.old_password;
        [manager POST:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            HUALog(@"123%@",responseObject);
            if ([[[[NSNumberFormatter alloc] init] stringFromNumber:responseObject[@"code"]] isEqualToString:@"8"]) {
                [HUAMBProgress MBProgressFromWindowWithLabelText:@"修改密码失败"];
            }else {
                [HUAMBProgress MBProgressFromWindowWithLabelText:@"修改密码成功,正在跳转登陆页面" dispatch_get_main_queue:^{
                    NSArray *vcs= self.navigationController.viewControllers;
                    for (UIViewController *vc in vcs) {
                        if([vc isKindOfClass:[HUALoginController class]]){
                            [self.navigationController popToViewController:vc animated:YES];
                        }
                    }

                }];
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            HUALog(@"%@",error);
            [HUAMBProgress MBProgressFromWindowWithLabelText:@"请检查网络设置"];
            return ;
        }];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    BOOL retValue = NO;
    if (textField == self.firstPassWordTF) {
        [self.secondPassWordTF becomeFirstResponder];
        retValue = NO;
    } else
    {
        [self.secondPassWordTF resignFirstResponder];
        retValue = NO;
        
    }
    
    return retValue;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
