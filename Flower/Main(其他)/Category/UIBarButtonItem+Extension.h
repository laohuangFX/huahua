//
//  UIBarButtonItem+Extension.h
//  黑马微博2期
//
//  Created by apple on 14-10-7.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage;
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage text:(NSString *)tex;

/**
 *  左边偏移
 *
 *  @param leftSpace 偏移距离（向左为负，向右为正）
 *
 *  @return return UIBarButtonItem
 */
+ (UIBarButtonItem *) leftSpace:(CGFloat)leftSpace;
/**
 *  右边偏移
 *
 *  @param leftSpace 偏移距离（向左为负，向右为正）
 *
 *  @return return UIBarButtonItem
 */
+ (UIBarButtonItem *) rightSpace:(CGFloat)rightSpace;
@end
