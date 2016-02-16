//
//  UIBarButtonItem+Extension.m
//  黑马微博2期
//
//  Created by apple on 14-10-7.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
@implementation UIBarButtonItem (Extension)
/**
 *  创建一个item
 *  
 *  @param target    点击item后调用哪个对象的方法
 *  @param action    点击item后调用target的哪个方法
 *  @param image     图片
 *  @param highImage 高亮的图片
 *
 *  @return 创建完的item
 */
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage
{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 150, 100);
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    // 设置尺寸
    btn.size = btn.currentBackgroundImage.size;
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage text:(NSString *)text
{
        CGRect frame = CGRectMake(0, 0, 60, 100);
        UIButton *button = [UIButton buttonWithFrame:frame title:text image:image font:hua_scale(12) titleColor:HUAColor(0x4da800)];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 4);
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, 150, 100);
//    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    // 设置图片
//    [btn setTitle:text forState:UIControlStateNormal];
//    btn.titleLabel.font = [UIFont systemFontOfSize:hua_scale(11)];
//    [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
//    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
//    [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
//    // 设置尺寸
//    btn.size = btn.currentBackgroundImage.size;
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *) leftSpace:(CGFloat)leftSpace {
    UIBarButtonItem *leftSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    leftSpacer.width = leftSpace;
    return leftSpacer;
}

+ (UIBarButtonItem *) rightSpace:(CGFloat)rightSpace {
    UIBarButtonItem *rightSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightSpacer.width = rightSpace;
    return rightSpacer;
}

@end
