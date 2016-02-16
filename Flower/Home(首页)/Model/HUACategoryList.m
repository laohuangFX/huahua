//
//  HUACategoryList.m
//  Flower
//
//  Created by 程召华 on 16/2/1.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUACategoryList.h"

@implementation HUACategoryList
+ (id)categoryListWithDictionary:(NSDictionary *)dic {
    return [[self alloc] initWithCategoryDic:dic];
}

- (id)initWithCategoryDic:(NSDictionary *)dic {
    if (self = [super init]) {
        self.name = dic[@"name"];
        self.category_id = dic[@"category_id"];
    }
    return self;
}
@end
