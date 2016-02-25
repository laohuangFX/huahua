//
//  HUATabBarController.m
//  huahua
//
//  Created by 程召华 on 16/1/4.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUATabBarController.h"
#import "HUANavigationController.h"
#import "HUAHomeController.h"
#import "HUAActivityController.h"
#import "HUAProductController.h"
#import "HUAMyController.h"
#import "HUALoginController.h"
#import "HUStatusAViewController.h"
#import "HUARechargeViewController.h"
@interface HUATabBarController ()<UITabBarControllerDelegate>

@end

@implementation HUATabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITabBarItem appearance]setTitlePositionAdjustment:UIOffsetMake(0, -2)];
    
    self.tabBar.translucent = NO;
    self. delegate = self ;
    [self.tabBar setBarTintColor:HUAColor(0xF5F6F7)];

    HUStatusAViewController *statusVC = [[HUStatusAViewController alloc]init];
    [self addSubViewController:statusVC title:@"动态" image:@"status" selectedImage:@"status_select"];
    
    HUAActivityController *activityVC = [[HUAActivityController alloc]init];
    [self addSubViewController:activityVC title:@"活动" image:@"activity" selectedImage:@"activity_select"];
    
    HUAHomeController *homeVC = [[HUAHomeController alloc]init];
    [self addSubViewController:homeVC title:@"主页" image:@"homepage" selectedImage:@"homepage_select"];
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    
    HUAProductController *productVC = [[HUAProductController alloc]initWithCollectionViewLayout:flowLayout];
    [self addSubViewController:productVC title:@"产品" image:@"product" selectedImage:@"product_select"];
    
    HUAMyController *myVC = [[HUAMyController alloc]init];
    [self addSubViewController:myVC title:@"我的" image:@"my" selectedImage:@"my_select"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addSubViewController:(UIViewController *)subViewController title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    //设置子控制器的文字
    subViewController.title = title;
    
    //设置子控制器的图片
    
    subViewController.tabBarItem.image = [UIImage imageNamed:image];
    subViewController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //设置文字的样式
    NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
    textAttributes[NSForegroundColorAttributeName] = HUAColor(0x494949);
    textAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    NSMutableDictionary *selectTextAttributes = [NSMutableDictionary dictionary];
    selectTextAttributes[NSForegroundColorAttributeName] = HUAColor(0x4da800);
    selectTextAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    [subViewController.tabBarItem setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    [subViewController.tabBarItem setTitleTextAttributes:selectTextAttributes forState:UIControlStateSelected];
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    HUANavigationController *navigationController = [[HUANavigationController alloc] initWithRootViewController:subViewController];
    navigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
    //添加为子控制器
    [self addChildViewController:navigationController];
}



@end
