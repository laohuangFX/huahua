//
//  HUAUserDetailInfo.m
//  Flower
//
//  Created by 程召华 on 16/1/21.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAUserDetailInfo.h"

@implementation HUAUserDetailInfo
+ (id)userDetailInfoWithDictionary:(NSDictionary *)dic {
    HUAUserDetailInfo *detailInfo = [HUAUserDetailInfo new];
    detailInfo.phone = dic[@"phone"];
    detailInfo.password = dic[@"password"];
    detailInfo.last_log_time = dic[@"last_log_time"];
    detailInfo.nickname = dic[@"nickname"];
    detailInfo.headicon = dic[@"headicon"];
    detailInfo.birth = dic[@"birth"];
    detailInfo.status = dic[@"status"];
    detailInfo.addr_id = dic[@"addr_id"];
    detailInfo.user_id = dic[@"user_id"];
    detailInfo.create_time = dic[@"create_time"];
    detailInfo.sex = dic[@"sex"];
    return detailInfo;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.last_log_time forKey:@"last_log_time"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.headicon forKey:@"headicon"];
    [aCoder encodeObject:self.birth forKey:@"birth"];
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeObject:self.addr_id forKey:@"addr_id"];
    [aCoder encodeObject:self.user_id forKey:@"user_id"];
    [aCoder encodeObject:self.create_time forKey:@"create_time"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.last_log_time = [aDecoder decodeObjectForKey:@"last_log_time"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.headicon = [aDecoder decodeObjectForKey:@"headicon"];
        self.birth = [aDecoder decodeObjectForKey:@"birth"];
        self.status = [aDecoder decodeObjectForKey:@"status"];
        self.addr_id = [aDecoder decodeObjectForKey:@"addr_id"];
        self.user_id = [aDecoder decodeObjectForKey:@"user_id"];
        self.create_time = [aDecoder decodeObjectForKey:@"create_time"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
    }
    return self;
}


@end
