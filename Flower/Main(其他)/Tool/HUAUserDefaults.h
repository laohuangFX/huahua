//
//  HUAUserDefaults.h
//  Flower
//
//  Created by 程召华 on 16/2/1.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUAUserDefaults : NSObject
+ (NSString *)getToken;


+ (HUAUserDetailInfo *)getUserDetailInfo;
@end
