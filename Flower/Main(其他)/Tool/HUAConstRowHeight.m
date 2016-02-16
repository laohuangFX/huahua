//
//  HUAConstRowHeight.m
//  Flower
//
//  Created by 程召华 on 16/1/9.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAConstRowHeight.h"

@implementation HUAConstRowHeight
+(NSAttributedString *)constRowHeightWithText:(NSString *)text rowHeight:(CGFloat)rowHeight font:(CGFloat)font{
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:rowHeight];//调整行间距
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = rowHeight;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:font],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    return  [[NSAttributedString alloc] initWithString:text attributes:attributes];
   
}
//调整字体颜色
+ (void)adjustTheLabel:(UILabel *)label adjustColor:(UIColor *)color adjustRang:(NSRange )makeRang{
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:label.text];
    [att addAttributes:@{NSForegroundColorAttributeName:color} range:NSMakeRange(makeRang.location, makeRang.length) ];
    label.attributedText = att;
    
}
//调整两个位置的字体颜色
+ (void )adjustTheLabel:(UILabel *)label adjustColor:(UIColor *)color adjustRang:(NSRange )makeRang towColor:(UIColor *)towColor adjustRang:(NSRange )towMakeRang{
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:label.text];
    [att addAttributes:@{NSForegroundColorAttributeName:color} range:NSMakeRange(makeRang.location, makeRang.length) ];
    [att addAttributes:@{NSForegroundColorAttributeName:color} range:NSMakeRange(towMakeRang.location, towMakeRang.length) ];
    label.attributedText = att;
    
}
//调整字体大小
+ (void )adjustTheLabel:(UILabel *)label adjustFont:(NSInteger)fontSize adjustRang:(NSRange )makeRang{
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:label.text];
    [att addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:hua_scale(fontSize)]} range:NSMakeRange(makeRang.location, makeRang.length) ];
    label.attributedText = att;
}

//调整颜色和字体大小
+ (void )adjustTheLabel:(UILabel *)label
            adjustColor:(UIColor *)color
        adjustColorRang:(NSRange )colorRang
             adjustFont:(NSInteger)fontSize
         adjustFontRang:(NSRange )fontRang{
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:label.text];
    [att addAttributes:@{NSForegroundColorAttributeName:color} range:NSMakeRange(colorRang.location, colorRang.length) ];
    [att addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:hua_scale(fontSize)]} range:NSMakeRange(fontRang.location, fontRang.length) ];
    label.attributedText = att;
    
}

@end
