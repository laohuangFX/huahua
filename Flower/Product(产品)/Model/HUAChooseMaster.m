//
//  HUAChooseMaster.m
//  Flower
//
//  Created by 程召华 on 16/1/17.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAChooseMaster.h"

@implementation HUAChooseMaster
+ (id)getMasterWithDictionary:(NSDictionary *)dic {
    return [[self alloc] initWithMasetrDictionary:dic];
}

- (id)initWithMasetrDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        self.master_id = dic[@"master_id"];
        self.name = dic[@"name"];
        self.price = dic[@"price"];
        self.fee = dic[@"fee"];
    }
    return self;
}
@end
