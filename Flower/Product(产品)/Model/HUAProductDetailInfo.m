//
//  HUAProductDetailInfo.m
//  Flower
//
//  Created by 程召华 on 16/1/15.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAProductDetailInfo.h"

@implementation HUAProductDetailInfo
+ (id)getProductDetailInfoWithDictionary:(NSDictionary *)dic {
    return [[self alloc] initWithProductDetailDictionary:dic];
}


- (id)initWithProductDetailDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        self.cover = dic[@"cover"];
        self.name = dic[@"name"];
        self.price = dic[@"price"];
        self.vip_discount = dic[@"vip_discount"];
        self.size = dic[@"size"];
        self.desc = dic[@"desc"];
        self.vip_price = dic[@"vip_price"];
    }
    return self;
}
@end
