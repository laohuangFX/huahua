//
//  UILabel+Extension.m
//  Flower
//
//  Created by 程召华 on 16/1/10.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)
+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text color:(UIColor *)color font:(CGFloat)font {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = color;
    //[label sizeToFit];
    label.font = [UIFont systemFontOfSize:font];
    return label;
}

+ (UILabel *)labelText:(NSString *)text color:(UIColor *)color font:(CGFloat)font{

    UILabel *label = [[UILabel alloc]init];
    label.text = text;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:font];
    return label;
}

- (void)setRowSpace:(CGFloat)rowSpace
{
    self.numberOfLines = 0;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    //调整行距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = rowSpace;
    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    self.attributedText = attributedString;
}


@end
