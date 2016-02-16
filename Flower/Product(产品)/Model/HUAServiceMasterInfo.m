//
//  HUAServiceMasterInfo.m
//  Flower
//
//  Created by 程召华 on 16/1/15.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAServiceMasterInfo.h"

@implementation HUAServiceMasterInfo
+ (id)getMasterInfo:(NSDictionary *)dic {
    return [[self alloc] initWithMasterDictionary:dic];
}


- (id)initWithMasterDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        self.master_id = dic[@"master_id"];
        self.masterName = dic[@"masterName"];
        self.masterType = dic[@"masterType"];
        self.cover = dic[@"cover"];
        self.praise_count = dic[@"praise_count"];
    }
    return self;
}
@end
