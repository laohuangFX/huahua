//
//  UITextField+Extension.h
//  Flower
//
//  Created by 程召华 on 16/1/11.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Extension)
+ (UITextField *)textFieldWithTarget:(id)target action:(SEL)action Frame:(CGRect)frame image:(NSString *)image placeholder:(NSString *)placeholder;

+ (UITextField *)textFieldWithFrame:(CGRect)frame image:(NSString *)image placeholder:(NSString *)placeholder;
@end
