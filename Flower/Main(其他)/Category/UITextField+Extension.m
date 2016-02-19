//
//  UITextField+Extension.m
//  Flower
//
//  Created by 程召华 on 16/1/11.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "UITextField+Extension.h"

@implementation UITextField (Extension)
+ (UITextField *)textFieldWithTarget:(id)target action:(SEL)action Frame:(CGRect)frame image:(NSString *)image placeholder:(NSString *)placeholder{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.width = hua_scale(20);
    imageView.height = hua_scale(20);
    imageView.image = [UIImage imageNamed:image];
    imageView.contentMode = UIViewContentModeCenter;
    
    UITextField *textField = [[UITextField alloc]initWithFrame:frame];
    textField.placeholder = placeholder;
    [textField setValue:HUAColor(0x5F5F62) forKeyPath:@"_placeholderLabel.textColor"];
    [textField setValue:[UIFont boldSystemFontOfSize:hua_scale(11)] forKeyPath:@"_placeholderLabel.font"];
    textField.font = [UIFont systemFontOfSize:hua_scale(13)];
    textField.leftView = imageView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    [textField addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return textField;
}

+ (UITextField *)textFieldWithFrame:(CGRect)frame image:(NSString *)image placeholder:(NSString *)placeholder {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.width = hua_scale(20);
    imageView.height = hua_scale(20);
    imageView.image = [UIImage imageNamed:image];
    imageView.contentMode = UIViewContentModeCenter;
    
    UITextField *textField = [[UITextField alloc]initWithFrame:frame];
    textField.placeholder = placeholder;
    textField.font = [UIFont systemFontOfSize:hua_scale(11)];
    textField.leftView = imageView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    return textField;

}







@end
