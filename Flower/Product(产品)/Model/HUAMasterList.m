//
//  HUAMasterList.m
//  Flower
//
//  Created by 程召华 on 16/1/18.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAMasterList.h"

@implementation HUAMasterList
+ (id)getMasterListWithDictionary:(NSDictionary *)dic{
    return [[self alloc] initWithMasterListDictionary:dic];
}

- (id)initWithMasterListDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        self.master_id = dic[@"master_id"];
        self.name = dic[@"name"];
        self.praise_count = dic[@"praise_count"];
        self.url = dic[@"url"];
        self.level_name = dic[@"level_name"];
    }
    return self;
}
@end
