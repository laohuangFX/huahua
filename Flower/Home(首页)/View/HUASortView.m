//
//  HUASortView.m
//  Flower
//
//  Created by 程召华 on 16/1/28.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUASortView.h"

@interface HUASortView ()
//记录按钮上一次点击
@property (nonatomic, strong) UIButton *lastButton;
//人气按钮
@property (nonatomic, strong) UIButton *popularityButton;
//距离按钮
@property (nonatomic, strong) UIButton *distanceButton;
//名字按钮
@property (nonatomic, strong) UIButton *shopNameButton;
//
@property (nonatomic, strong) UIView *chooseView;
@end


@implementation HUASortView

- (UIView *)chooseView {
    if (!_chooseView) {
        _chooseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, hua_scale(60))];
        _chooseView.backgroundColor = HUAColor(0xffffff);
    }
    return _chooseView;
}


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.chooseView];
        self.popularityButton = [self setupBtnWithTitle:@"按人气" type:HUASortViewButtonTypePopularity];
        self.distanceButton = [self setupBtnWithTitle:@"按距离" type:HUASortViewButtonTypeDistance];
        self.shopNameButton = [self setupBtnWithTitle:@"按名字" type:HUASortViewButtonTypeShopName];
        
        
        UIView *seperateTop= [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        seperateTop.backgroundColor = HUAColor(0xcdcdcd);
        [self.chooseView addSubview:seperateTop];
        
        UIView *seperateBottom= [[UIView alloc] initWithFrame:CGRectMake(0, hua_scale(59.5), SCREEN_WIDTH, 0.5)];
        seperateBottom.backgroundColor = HUAColor(0xcdcdcd);
        [self.chooseView addSubview:seperateBottom];
        
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

/**
 *创建button
 */
- (UIButton *)setupBtnWithTitle:(NSString *)title type:(HUASortViewButtonType)type {
    UIButton *button = [UIButton buttonWithType:0];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:hua_scale(12)];
    [button setTitleColor:HUAColor(0x666666) forState:UIControlStateNormal];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = hua_scale(3);
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = HUAColor(0xbfbfbf).CGColor;
    button.tag = type;
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(clickDown:) forControlEvents:UIControlEventTouchDown];
    [self.chooseView addSubview:button];
    return button;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // GRect buttonFrame = CGRectMake(hua_scale(10)+hua_scale(102)*i, hua_scale(14.5), hua_scale(96), hua_scale(31));
    // 设置所有按钮的frame
    NSUInteger count = 3;
    CGFloat btnW = hua_scale(96);
    CGFloat btnH = hua_scale(31);
    for (NSUInteger i = 0; i<count; i++) {
        UIButton *btn = self.chooseView.subviews[i];
        btn.y = hua_scale(14.5);
        btn.width = btnW;
        btn.x = hua_scale(10)+hua_scale(102)*i;
        btn.height = btnH;
    }
}


- (void)clickDown:(UIButton *)sender {
    [sender setTitleColor:HUAColor(0xffffff) forState:UIControlStateNormal];
    sender.backgroundColor = HUAColor(0x4da800);
}

- (void)click:(UIButton *)sender {
//    if (sender == self.lastButton) {
//         [self removeFromSuperview];
//    }
    if (self.lastButton) {
        self.lastButton.selected = NO;
        [self.lastButton setTitleColor:HUAColor(0x666666) forState:UIControlStateNormal];
        self.lastButton.backgroundColor = HUAColor(0xffffff);
        //之前的按钮开启交互
        self.lastButton.userInteractionEnabled = YES;
    }
    sender.selected = YES;
    [sender setTitleColor:HUAColor(0xffffff) forState:UIControlStateNormal];
    sender.backgroundColor = HUAColor(0x4da800);
    self.lastButton = sender;
    //选中按钮取消交互功能
    self.lastButton.userInteractionEnabled = NO;

    if ([self.delegate respondsToSelector:@selector(sortMenuDidDismiss:)]) {
        [self.delegate sortMenuDidDismiss:sender.tag];
    }
    
    
}

- (void)backgroundTapped:(UITapGestureRecognizer *)tap {
    self.y = screenHeight;
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(sortMenuDidDismiss:)]) {
        [self.delegate sortMenuDidDismiss:6];
    }
}
@end