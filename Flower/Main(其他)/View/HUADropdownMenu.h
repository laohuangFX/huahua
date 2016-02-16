//
//  HUADropdownMenu.h
//  Flower
//
//  Created by 程召华 on 16/1/7.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HUADropdownMenu : UIView
+ (instancetype)menu;


// 显示
- (void)showFrom:(UIView *)from;

//销毁
- (void)dismiss;

//内容

@property (nonatomic, strong) UIView *content;

// 内容控制器
@property (nonatomic, strong) UIViewController *contentController;
@end
