//
//  HUAMasterDetailInfo.m
//  Flower
//
//  Created by 程召华 on 16/1/18.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAMasterDetailInfo.h"

@implementation HUAMasterDetailInfo
+ (id)getMasterDetailInfoWithDictionary:(NSDictionary *)dic {
    return [[self alloc]initWithMasterDetailDictionary:dic];
}

- (id)initWithMasterDetailDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        NSDictionary *dic = dictionary[@"info"][@"item"];
        self.cover = dic[@"cover"];
        self.brief = dic[@"brief"];
        self.masterName = dic[@"masterName"];
        self.masterType = dic[@"masterType"];
        self.praise_count = dic[@"praise_count"];
        self.about_arrange = dictionary[@"info"][@"about_arrange"];
        self.serviceArray = dictionary[@"info"][@"service"];
        
    }
    return self;
}

+ (id)getMienArrayFromDictionary:(NSDictionary *)dic {
    return [[self alloc] initWithAchievementDcitionary:dic];
}

- (id)initWithAchievementDcitionary:(NSDictionary *)dic {
    if (self = [super init]) {
        self.url = dic[@"url"];
    }
    return self;
}

@end
