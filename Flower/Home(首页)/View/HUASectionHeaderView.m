//
//  HUASectionHeaderView.m
//  Flower
//
//  Created by 程召华 on 16/1/5.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUASectionHeaderView.h"
#import "HUAHomeSortDropdownMenuController.h"

@interface HUASectionHeaderView()

@property (nonatomic, strong) UIView *cover;
@property (nonatomic, strong) UIView *view;
@end


@implementation HUASectionHeaderView



- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        //创建排序按钮
        UIButton *sortButton = [UIButton buttonWithType:0];
        sortButton.tag = 1000;
        sortButton.frame = CGRectMake(0, 0, screenWidth, sortButtonHeight);
        sortButton.backgroundColor = HUAColor(0xF6F6F6);
        sortButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [sortButton setTitle:@"排序" forState:UIControlStateNormal];
        [sortButton setTitleColor:HUAColor(0x575757) forState:UIControlStateNormal];
        [sortButton setTitleColor:HUAColor(0x4da800) forState:UIControlStateSelected];
        [sortButton setImage:[UIImage imageNamed:@"sort_gray"] forState:UIControlStateNormal];
        [sortButton setImage:[UIImage imageNamed:@"sort_green"] forState:UIControlStateSelected];
        [sortButton setTitleEdgeInsets:UIEdgeInsetsMake(0, screenWidth-hua_scale(100), 0, 0)];
        [sortButton setImageEdgeInsets:UIEdgeInsetsMake(0, screenWidth-hua_scale(20), 0, 0)];
        [sortButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sortButton];
    }
    return self;
}
- (void)click:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickSortButton:)]) {
        [self.delegate clickSortButton:sender];
    }
   
}

@end
