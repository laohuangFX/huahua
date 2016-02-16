//
//  HUACreateButton.m
//  Flower
//
//  Created by 程召华 on 16/1/8.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUACreateButton.h"

@implementation HUACreateButton

+ (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:0];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:HUAColor(0x000000) forState:UIControlStateNormal];
    [button setTitleColor:HUAColor(0xFFFFFF) forState:UIControlStateSelected];
    button.backgroundColor = [UIColor greenColor];
    return button;
    
}

@end
