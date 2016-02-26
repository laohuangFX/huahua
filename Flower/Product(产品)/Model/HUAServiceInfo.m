//
//  HUAServiceInfo.m
//  Flower
//
//  Created by 程召华 on 16/1/15.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAServiceInfo.h"

@implementation HUAServiceInfo
+ (id)getServiceDetailInfoWithDictionary:(NSDictionary *)dic {
    return [[self alloc] initWithDataDictionary:dic];
}

- (id)initWithDataDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        NSDictionary *dic = dictionary[@"item"];
        self.name = dic[@"name"];
        self.price = dic[@"price"];
        self.vip_discount = dic[@"vip_discount"];
        self.vip_price = dic[@"vip_price"];
        self.desc = dic[@"desc"];
        self.detail = dic[@"detail"];
        self.cover = dic[@"cover"];
        self.praise_count = dic[@"praise_count"];
     
    }
    return self;
}

+ (id)getServiceArrayWithDictionary:(NSDictionary *)dic {
    return [[self alloc] initWithServiceDictionary:dic];
}

- (id)initWithServiceDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        NSDictionary *dic = dictionary[@"info"];
        self.media_lis = dic[@"media_lis"];
    }
    return self;
}




@end
