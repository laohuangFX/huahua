//
//  HUAUserDefaults.m
//  Flower
//
//  Created by 程召华 on 16/2/1.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAUserDefaults.h"

@implementation HUAUserDefaults
+ (NSString *)getToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
}
+ (HUAUserDetailInfo *)getUserDetailInfo {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"data"];
    HUAUserDetailInfo *detailInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return detailInfo;
}
@end
