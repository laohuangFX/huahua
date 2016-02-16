//
//  HUAShopIntroduce.m
//  Flower
//
//  Created by 程召华 on 16/1/12.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAShopIntroduce.h"

@implementation HUAShopIntroduce
+(id)parseFrontShopPageWithDictionary:(NSDictionary *)dic {
    return [[self alloc] initWithDataDictionary:dic];
}

- (id)initWithDataDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        self.shopname = dic[@"shopname"];
        self.cover = dic[@"cover"];
        self.icon = dic[@"icon"];
        self.desc = dic[@"desc"];
        self.address = dic[@"address"];
        self.distance = dic[@"distance"];
        self.phone = dic[@"phone"];
        self.praise_count = dic[@"praise_count"];
        self.product_count = dic[@"product_count"];
        self.service_count = dic[@"service_count"];
        self.master_count = dic[@"master_count"];
        self.active_count = dic[@"active_count"];
        self.refill_setting = dic[@"refill_setting"];

    }
    return self;
}

+ (id)parseUserInfoDictionary:(NSDictionary *)dic {
    return [[self alloc] initWithUserInfoDictionary:dic];
}
- (id)initWithUserInfoDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        self.money = dic[@"money"];
        self.have_collected = dic[@"have_collected"];
        self.have_praised = dic[@"have_praised"];
    }
    return self;
}

+ (id)parseActiveWithDictionary:(NSDictionary *)dic {
    return [[self alloc] initWithParseDictionary:dic];
}
- (id)initWithParseDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        self.active_id = dic[@"active_id"];
        self.active_cover = dic[@"cover"];
    }
    return self;
}

@end
