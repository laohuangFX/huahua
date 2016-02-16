//
//  HUADetailInfo.m
//  Flower
//
//  Created by 程召华 on 16/1/6.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUADetailInfo.h"

@implementation HUADetailInfo


+ (id)getDetailTextAndImageWithDictionary:(NSDictionary *)dic {
    return [[self alloc]initWithParseDictionary:dic];
}

- (id)initWithParseDictionary:(NSDictionary *)dic {
     if (self = [super init])  {
         self.text = dic[@"text"];
         self.pic = dic[@"pic"];
    }
    return self;
}
@end
