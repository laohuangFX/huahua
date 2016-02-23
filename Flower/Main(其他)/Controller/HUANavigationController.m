//
//  HUANavigationController.m
//  huahua
//
//  Created by 程召华 on 16/1/4.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUANavigationController.h"

@interface HUANavigationController ()

@end

@implementation HUANavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
    [self.navigationBar setBarTintColor:HUAColor(0xF5F6F7)];
    
    
    

}

+ (void)initialize
{
    
    
    // 设置整个项目所有item的主题样式
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // 设置普通状态
    // key：NS****AttributeName
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = HUAColor(0x47A300);
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置不可用状态
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[NSForegroundColorAttributeName] = HUAColor(0x067AB5);
    disableTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateHighlighted];
    
     //获取特定类的所有导航条

    UINavigationBar *navigationBar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    navigationBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back_green"]];
//    navigationBar.backIndicatorImage = [[UIImage imageNamed:@"back_green"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    navigationBar.backIndicatorTransitionMaskImage = [[UIImage imageNamed:@"back_green"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, hua_scale(2.5)) forBarMetrics:UIBarMetricsDefault];
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : HUAColor(0x434343)}];
    [navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:hua_scale(14)]}];
    
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{

    if (self.viewControllers.count > 0) { // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        /* 自动显示和隐藏tabbar */
        viewController.hidesBottomBarWhenPushed = YES;
        UIBarButtonItem *backButton = [UIBarButtonItem itemWithTarget:self action:@selector(backAction:) image:@"back_green" highImage:@"back_green" text:@"返回"];
        UIBarButtonItem *leftSpace = [UIBarButtonItem leftSpace:hua_scale(-10)];
        backButton.tintColor = HUAColor(0x47A300);
         viewController.navigationItem.leftBarButtonItems = @[leftSpace, backButton];
    }
    
        [super pushViewController:viewController animated:animated];
}

- (void)backAction:(UIButton *)sender
{
    
#warning 这里要用self，不是self.navigationController
    // 因为self本来就是一个导航控制器，self.navigationController这里是nil的
    [self popViewControllerAnimated:YES];
}

- (void)more
{
    [self popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
