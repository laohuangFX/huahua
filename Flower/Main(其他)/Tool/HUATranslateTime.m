//
//  HUATranslateTime.m
//  Flower
//
//  Created by 程召华 on 16/1/8.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUATranslateTime.h"

@implementation HUATranslateTime
+ (NSString *)translateTimeIntoCurrurent:(long)time {
    
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *timeStr = [formatter stringFromDate:date];
    //HUALog(@"%@",timeStr);
    return timeStr;
    
}
//
+ (NSString *)translateTimeIntoCurrurents:(NSInteger)totalSecond{

    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:totalSecond];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *timeStr = [formatter stringFromDate:date];
    //HUALog(@"%@",timeStr);
    return timeStr;


}

+ (NSString *)translateDateIntoTimestamp:(NSString *)date {
    date = [date stringByReplacingOccurrencesOfString:@"年" withString:@""];
    date = [date stringByReplacingOccurrencesOfString:@"月" withString:@""];
    date = [date stringByReplacingOccurrencesOfString:@"日" withString:@""];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    // 设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSDate* date1 = [formatter dateFromString:date];
    //将字符串按formatter转成nsdate
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date1 timeIntervalSince1970]];
    return timeSp;
}


@end
