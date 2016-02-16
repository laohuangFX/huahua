//
//  UILabel+Extension.h
//  Flower
//
//  Created by 程召华 on 16/1/10.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)
+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text color:(UIColor *)color font:(CGFloat)font;


//、、、、
+ (UILabel *)labelText:(NSString *)text color:(UIColor *)color font:(CGFloat)font;

/**
 *  设置行距
 */
- (void)setRowSpace:(CGFloat)rowSpace;

@end
