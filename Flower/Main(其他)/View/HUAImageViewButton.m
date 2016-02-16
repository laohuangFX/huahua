//
//  HUAImageViewButton.m
//  Flower
//
//  Created by 程召华 on 16/1/12.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAImageViewButton.h"

@implementation HUAImageViewButton

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:HUAColor(0x575757) forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:hua_scale(12)];
        [self setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"select_green"] forState:UIControlStateSelected];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 如果仅仅是调整按钮内部titleLabel和imageView的位置，那么在layoutSubviews中单独设置位置即可
    
    // 1.计算titleLabel的frame
    self.titleLabel.x = self.imageView.x;
    
    // 2.计算imageView的frame
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame);
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    // 只要修改了文字，就让按钮重新计算自己的尺寸
    [self sizeToFit];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    
    // 只要修改了图片，就让按钮重新计算自己的尺寸
    [self sizeToFit];
}

@end
