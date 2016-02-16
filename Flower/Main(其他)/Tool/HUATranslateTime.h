//
//  HUATranslateTime.h
//  Flower
//
//  Created by 程召华 on 16/1/8.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUATranslateTime : NSObject
+ (NSString *)translateTimeIntoCurrurent:(NSInteger)totalSeconds;

+ (NSString *)translateTimeIntoCurrurents:(NSInteger)totalSecond;

+ (NSString *)translateDateIntoTimestamp:(NSString *)date;
@end
