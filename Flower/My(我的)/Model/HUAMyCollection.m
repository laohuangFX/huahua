//
//  HUAMyCollection.m
//  Flower
//
//  Created by 程召华 on 16/1/23.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAMyCollection.h"

@implementation HUAMyCollection
+ (id)collectionInfoWithDictionary:(NSDictionary *)dic {
    return [[self alloc] initWithColletionDictionary:dic];
}

- (id)initWithColletionDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        self.shopname = dic[@"shopname"];
        self.icon = dic[@"icon"];
        self.cover = dic[@"cover"];
        self.address = dic[@"address"];
        self.shop_id = dic[@"shop_id"];
        self.praise_sum = dic[@"praise_sum"];
        self.is_praise = dic[@"is_praise"];
        self.is_vip = dic[@"is_vip"];
    }
    return self;
}
@end
