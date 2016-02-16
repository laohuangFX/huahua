//
//  HUASortView.m
//  Flower
//
//  Created by 程召华 on 16/1/28.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUASortView.h"

@interface HUASortView ()
@property (nonatomic, strong) UIView *backGroundView;
@end


@implementation HUASortView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIView *chooseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, hua_scale(60))];
        chooseView.backgroundColor = HUAColor(0xffffff);
        [self addSubview:chooseView];
        
        NSArray *array = @[@"按人气",@"按距离",@"按名字"];
        for (int i = 0; i < array.count; i++) {
            
            CGRect buttonFrame = CGRectMake(hua_scale(10)+hua_scale(102)*i, hua_scale(14.5), hua_scale(96), hua_scale(31));
            UIButton *button = [UIButton buttonWithFrame:buttonFrame title:array[i] image:nil font:hua_scale(12) titleColor:HUAColor(0x666666)];
            [button setTitle:array[i] forState:UIControlStateNormal];
            [button setTitleColor:HUAColor(0xffffff) forState:UIControlStateHighlighted];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = hua_scale(3);
            button.layer.borderWidth = 0.5;
            button.tag = i + 10086;
            button.layer.borderColor = HUAColor(0xbfbfbf).CGColor;
            [chooseView addSubview:button];
            [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(clickDown:) forControlEvents:UIControlEventTouchDown];
            
        }
        UIView *seperateTop= [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        seperateTop.backgroundColor = HUAColor(0xcdcdcd);
        [chooseView addSubview:seperateTop];
        
        UIView *seperateBottom= [[UIView alloc] initWithFrame:CGRectMake(0, 59.5, SCREEN_WIDTH, 0.5)];
        seperateBottom.backgroundColor = HUAColor(0xcdcdcd);
        [chooseView addSubview:seperateBottom];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,hua_scale(60), screenWidth, hua_scale(1000))];
        imageView.backgroundColor = HUAColor(0x000000);
        imageView.alpha = 0.5;
        imageView.userInteractionEnabled = YES;
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
        [imageView addGestureRecognizer:gesture];
        [self addSubview:imageView];
    }
    return self;
}


- (void)clickDown:(UIButton *)sender {
    sender.backgroundColor = HUAColor(0x4da800);
}

- (void)click:(UIButton *)sender {
    
 
    sender.backgroundColor = HUAColor(0x4da800);
    
    [self removeFromSuperview];

    if ([self.delegate respondsToSelector:@selector(sortMenuDidDismiss:)]) {
        [self.delegate sortMenuDidDismiss:sender];
    }
    
}

- (void)backgroundTapped:(UITapGestureRecognizer *)tap {
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(sortMenuDidDismiss:)]) {
        [self.delegate sortMenuDidDismiss:nil];
    }
}


@end
