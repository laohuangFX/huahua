//
//  HUAHomeSortDropdownMenuController.m
//  Flower
//
//  Created by 程召华 on 16/1/7.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAHomeSortDropdownMenuController.h"

#define sortDropdownWidth ((([UIScreen mainScreen].bounds.size.width)-32)/3)


@interface HUAHomeSortDropdownMenuController ()

@end

@implementation HUAHomeSortDropdownMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *popularityButton = [UIButton buttonWithType:0];
    popularityButton.frame = CGRectMake(10, sortButtonHeight/2, sortDropdownWidth, sortButtonHeight);
    popularityButton.backgroundColor = HUAColor(0X409C02);
    [popularityButton setTitle:@"按人气" forState:UIControlStateNormal];
    [popularityButton setTitleColor:HUAColor(0x484848) forState:UIControlStateNormal];
    [popularityButton setTitleColor:HUAColor(0xFFFFFF) forState:UIControlStateSelected];
    [popularityButton addTarget:self action:@selector(popularityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popularityButton];
}

- (void)popularityButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    HUALog(@"人气排序");
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
