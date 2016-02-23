//
//  HUAShopInfo.m
//  Flower
//
//  Created by 程召华 on 16/1/5.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAShopInfo.h"

@implementation HUAShopInfo

MJCodingImplementation;


+ (id)parseHomeDataWithDictionary:(NSDictionary *)dic {
    return [[self alloc]initWithDataDictionary:dic];
}

- (id)initWithDataDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        self.shop_id = dic[@"shop_id"];
        self.shopname = dic[@"shopname"];
        self.cover = dic[@"cover"];
        self.icon = dic[@"icon"];
        self.poid = dic[@"poid"];
        self.address = dic[@"address"];
        self.praise_count = dic[@"praise_count"];
        self.is_vip = dic[@"is_vip"];
        
    }
    return self;
}

+ (id)parseBannerWithDictionary:(NSDictionary *)dic {
    return [[self alloc] initWithBannerDictionary:dic];
}

- (id)initWithBannerDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        self.banner_pic = dic[@"banner_pic"];
        self.link = dic[@"link"];
    }
    return self;
}








@end
