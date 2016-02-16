//
//  HUAConsumption.m
//  Flower
//
//  Created by 程召华 on 16/1/28.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAConsumption.h"

@implementation HUAConsumption
+ (id)consumptionInfoFromDictionary:(NSDictionary *)dic {
    return [[self alloc] initWithConsumptionDictionary:dic];
}

- (id)initWithConsumptionDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        self.create_time = dic[@"create_time"];
        self.bill_id = dic[@"bill_id"];
        self.money = dic[@"money"];
        self.first_name = dic[@"first_name"];
    }
    return self;
}
@end
