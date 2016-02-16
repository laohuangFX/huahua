//
//  HUAUserInfo.h
//  Flower
//
//  Created by 程召华 on 16/1/20.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUAUserInfo : NSObject<NSCoding>
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *user_id;

@property (nonatomic, strong) NSString *token;


+ (id)userInfoWithDictionary:(NSDictionary *)dic;
+ (id)tokenWithDictionary:(NSDictionary *)dic;
@end
