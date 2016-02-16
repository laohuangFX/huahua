//
//  HUAConstRowHeight.h
//  Flower
//
//  Created by 程召华 on 16/1/9.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUAConstRowHeight : NSObject
+ (NSAttributedString *)constRowHeightWithText:(NSString *)text rowHeight:(CGFloat)rowHeight font:(CGFloat)font;

//调整字体颜色
+ (void )adjustTheLabel:(UILabel *)label adjustColor:(UIColor *)color adjustRang:(NSRange )makeRang;

//调整两个位置的字体颜色
+ (void )adjustTheLabel:(UILabel *)label adjustColor:(UIColor *)color adjustRang:(NSRange )makeRang towColor:(UIColor *)towColor adjustRang:(NSRange )towMakeRang;


//调整字体大小
+ (void )adjustTheLabel:(UILabel *)label adjustFont:(NSInteger)fontSize adjustRang:(NSRange )makeRang;

//调整颜色和字体大小
+ (void )adjustTheLabel:(UILabel *)label
            adjustColor:(UIColor *)color
        adjustColorRang:(NSRange )colorRang
             adjustFont:(NSInteger)fontSize
         adjustFontRang:(NSRange )fontRang;
@end
