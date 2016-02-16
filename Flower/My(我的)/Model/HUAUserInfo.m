//
//  HUAUserInfo.m
//  Flower
//
//  Created by 程召华 on 16/1/20.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAUserInfo.h"

@implementation HUAUserInfo
+ (id)userInfoWithDictionary:(NSDictionary *)dic {
    HUAUserInfo *userInfo = [[HUAUserInfo alloc] init];
    userInfo.phone = dic[@"phone"];
    userInfo.password = dic[@"password"];
    userInfo.sex = dic[@"sex"];
    userInfo.create_time = dic[@"create_time"];
    userInfo.user_id = dic[@"user_id"];
    return userInfo;
}
+ (id)tokenWithDictionary:(NSDictionary *)dic {
    HUAUserInfo *tokenInfo = [[HUAUserInfo alloc] init];
    tokenInfo.token = dic[@"token"];
    return tokenInfo;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.create_time forKey:@"create_time"];
    [aCoder encodeObject:self.user_id forKey:@"user_id"];
    [aCoder encodeObject:self.token forKey:@"token"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
       self.phone = [aDecoder decodeObjectForKey:@"phone"];
       self.password = [aDecoder decodeObjectForKey:@"password"];
       self.sex =  [aDecoder decodeObjectForKey:@"sex"];
       self.create_time = [aDecoder decodeObjectForKey:@"create_time"];
       self.user_id =  [aDecoder decodeObjectForKey:@"user_id"];
       self.token =  [aDecoder decodeObjectForKey:@"token"];
    }
    return self;
}

@end
