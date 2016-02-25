//
//  UIButton+Extension.m
//  Flower
//
//  Created by 程召华 on 16/1/12.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)

+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title image:(NSString *)image font:(CGFloat)font titleColor:(UIColor *)titleColor{
    UIButton *button = [UIButton buttonWithType:0];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    
    return button;
}

+ (UIButton *)buttonWithTarget:(id)target action:(SEL)action Frame:(CGRect)frame  url:(NSString *)url {
    UIButton *button = [UIButton buttonWithType:0];
    button.frame = frame;
    [button setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:url] placeholderImage:nil];
   button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loading_picture_middle"]];
    //button.backgroundColor = [UIColor greenColor];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    return button;
}



@end
