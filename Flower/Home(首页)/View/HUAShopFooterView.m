//
//  HUAShopFooterView.m
//  Flower
//
//  Created by 程召华 on 16/1/14.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAShopFooterView.h"

@interface HUAShopFooterView ()
@property (nonatomic, strong) UIButton *button;

@end


@implementation HUAShopFooterView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        for (int i = 0; i < self.coverArray.count; i ++) {
            if (i % 3 == 0) {
                UIButton *button = [UIButton buttonWithType:0];
                button.frame = CGRectMake(hua_scale(10), (i / 3) *hua_scale(252), hua_scale(147), hua_scale(hua_scale(116)));
                button.tag = [self.idArray[i] integerValue];
                [button setBackgroundImage:[UIImage imageNamed:self.coverArray[i]] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
            }
            if (i % 3 == 1) {
                UIButton *button = [UIButton buttonWithType:0];
                button.frame = CGRectMake(hua_scale(163), (i / 3) *hua_scale(252), hua_scale(147), hua_scale(hua_scale(116)));
                button.tag = [self.idArray[i] integerValue];
                [button setBackgroundImage:[UIImage imageNamed:self.coverArray[i]] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
            }
            if (i % 3 == 2) {
                UIButton *button = [UIButton buttonWithType:0];
                button.frame = CGRectMake(hua_scale(10), (i / 3) *hua_scale(252)+hua_scale(116), hua_scale(300), hua_scale(hua_scale(116)));
                button.tag = [self.idArray[i] integerValue];
                [button setBackgroundImage:[UIImage imageNamed:self.coverArray[i]] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
                
            }
        }

    }
    return self;
}

- (void)click:(UIButton *)sender {
    NSInteger activeID = sender.tag;
    NSString *string = [NSString stringWithFormat:@"%ld",(long)activeID];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(clickToJump:)]) {
        [self.delegate clickToJump:string];
    }
     HUALog(@"%@,,////%@",self.coverArray,self.idArray);
}


@end
