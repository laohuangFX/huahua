//
//  HUAActivityGoods.m
//  Flower
//
//  Created by 程召华 on 16/1/6.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAActivityGoods.h"

@implementation HUAActivityGoods

MJCodingImplementation

+ (id)parseActivity:(NSDictionary *)dic {
    return [[self alloc]initWithDic:dic];
}
- (id)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        
        self.cover = dic[@"cover"];
        self.shop_id = dic[@"shop_id"];
        self.active_id = dic[@"active_id"];
    }
    return self;
}
@end
