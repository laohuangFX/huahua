//
//  UIButton+Extension.h
//  Flower
//
//  Created by 程召华 on 16/1/12.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)
+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title image:(NSString *)image font:(CGFloat)font titleColor:(UIColor *)titleColor;

+ (UIButton *)buttonWithTarget:(id)target action:(SEL)action Frame:(CGRect)frame  url:(NSString *)url;
@end
