//
//  HUAShopProduct.m
//  Flower
//
//  Created by 程召华 on 16/1/14.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAShopProduct.h"

@implementation HUAShopProduct
+ (id)parseWithDictionary:(NSDictionary *)dic{
    return [[self alloc] initWithParseWithDictionary:dic];
}

- (id)initWithParseWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        self.cover = dic[@"cover"];
        self.name = dic[@"name"];
        self.praise_count = dic[@"praise_count"];
        self.price = dic[@"price"];
        self.product_id = dic[@"product_id"];
        self.service_id = dic[@"service_id"];
    }
    return self;
}
@end
