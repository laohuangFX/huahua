//
//  HUAProductCard.m
//  Flower
//
//  Created by 程召华 on 16/1/26.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAProductCard.h"

@implementation HUAProductCard
+ (id)productCardWithDictionary:(NSDictionary *)dic {
    return [[self alloc] initWithProductCardDictionary:dic];
}

- (id)initWithProductCardDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        self.shopname = dic[@"shopname"];
        self.address = dic[@"shopname"];
        self.active_price = dic[@"shopname"];
        self.shop_id = dic[@"shopname"];
        self.card_name = dic[@"shopname"];
        self.phone = dic[@"shopname"];
        self.card_id = dic[@"shopname"];
        self.cover = dic[@"shopname"];
        self.remain_times = dic[@"shopname"];
    }
    return self;
}
+ (id)serviceScope:(NSDictionary *)dic {
    return [[self alloc] initWithServiceScopeDictionary:dic];
}

- (id)initWithServiceScopeDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        self.name = dic[@"name"];
        self.service_id = dic[@"service_id"];
    }
    return self;
}
@end
