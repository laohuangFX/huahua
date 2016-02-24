//
//  HUAMembersPayViewController.m
//  Flower
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAMembersPayViewController.h"

@interface HUAMembersPayViewController ()

@end

@implementation HUAMembersPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付结果";
    self.view.backgroundColor = HUAColor(0xeeeeee);
    self.navigationItem.leftBarButtonItems = nil;
    [self.navigationItem setHidesBackButton:YES];

    [HUAMBProgress MBProgressFromWindowWithLabelText:@"支付成功"];
    //初始化界面
    [self initPayView];
    
}
- (void)initPayView{

    //图标
    UIImageView *gouImage = [UIImageView new];
    gouImage.image = [UIImage imageNamed:@"pay_success"];
    [self.view addSubview:gouImage];
    [gouImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hua_scale(18));
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(hua_scale(45), hua_scale(45)));
    }];
    
    //支付成功
    UILabel *lable = [UILabel labelText:@"支付成功" color:HUAColor(0x4da800) font:hua_scale(15)];
    [self.view addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(gouImage.mas_bottom).mas_equalTo(hua_scale(10));
        make.centerX.mas_equalTo(0);
    }];
    [lable setSingleLineAutoResizeWithMaxWidth:200];
    
    //背景
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(lable.mas_bottom).mas_equalTo(hua_scale(17));
        make.height.mas_equalTo(hua_scale(80));
    }];
    
    //价格
    UILabel *money = [UILabel labelText:@"¥ 100.00" color:HUAColor(0x4da800) font:hua_scale(24)];

    [money sizeToFit];
    [self.view addSubview:money];
    [money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(hua_scale(15));
        make.top.mas_equalTo(bgView.mas_top).mas_equalTo(hua_scale(1));
        make.height.mas_equalTo(hua_scale(39));
    }];
    [money setSingleLineAutoResizeWithMaxWidth:200];
    
    //中分线
    UIView *thView = [UIView new];
    thView.backgroundColor = HUAColor(0xf1f1f1);
    [self.view addSubview:thView];
    [thView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(money.mas_bottom);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(money);
        make.right.mas_equalTo(hua_scale(-15));
    }];
    
    UILabel *title = [UILabel labelText:@"会员余额:" color:HUAColor(0x999999) font:hua_scale(12)];
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(money);
        make.top.mas_equalTo(thView.mas_bottom).mas_equalTo(0);
    }];
    [title setSingleLineAutoResizeWithMaxWidth:200];
    
    UILabel *balanceMoney = [UILabel labelText:@"¥ 1000.00元" color:HUAColor(0x999999) font:hua_scale(12)];
    [self.view addSubview:balanceMoney];
    [balanceMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.centerY.mas_equalTo(title);
        make.right.mas_equalTo(thView.mas_right);
    }];
    [balanceMoney setSingleLineAutoResizeWithMaxWidth:200];
    
    UIButton *successButton = [UIButton buttonWithType:UIButtonTypeCustom];
    successButton.backgroundColor = HUAColor(0x4da800);
    successButton.clipsToBounds = YES;
    successButton.layer.borderWidth =1;
    successButton.layer.borderColor = HUAColor(0x4da800).CGColor;//设置边框颜色
    successButton.layer.cornerRadius =3.f;
    [successButton setTitle:@"完成" forState:0];
    [successButton setTitleColor:HUAColor(0xffffff) forState:0];
    [successButton addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:successButton];
    [successButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView.mas_bottom).mas_equalTo(hua_scale(15));
        make.size.mas_equalTo(CGSizeMake(hua_scale(290), hua_scale(44)));
        make.right.mas_equalTo(self.view.mas_right).mas_equalTo(hua_scale(-15));
        
    }];
  
}
- (void)complete{

    [self.navigationController popViewControllerAnimated:YES];
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
