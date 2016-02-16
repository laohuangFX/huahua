//
//  HUAMyMemberCard.m
//  Flower
//
//  Created by 程召华 on 16/1/25.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAMyMemberCard.h"

@implementation HUAMyMemberCard
+ (id)myMemberCardWithDictionary:(NSDictionary *)dic {
    return [[self alloc] initWithMemberCardDictionary:dic];
}

- (id)initWithMemberCardDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        self.shop_id = dic[@"shop_id"];
        self.shopname = dic[@"shopname"];
        self.icon = dic[@"icon"];
        self.address = dic[@"address"];
        self.money = dic[@"money"];
    }
    return self;
}
@end
