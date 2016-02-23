//
//  HUACityInfo.m
//  Flower
//
//  Created by applewoainiqwe on 16/2/22.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUACityInfo.h"

@implementation HUACityInfo

+ (instancetype)modelWithDictionary:(NSDictionary *)dic{
    HUACityInfo *city = [[HUACityInfo alloc]init];
    city.cityName = dic[@"c_name"];
    city.cityid = dic[@"id"];
    city.lat = dic[@"lat"];
    city.lng = dic[@"lng"];
    city.mergerName = dic[@"mergername"];
    city.parentid = dic[@"parentid"];
    return city;
}

- (NSArray *)citysFromArray:(NSArray *)array{
    NSMutableArray *mun = [NSMutableArray array];
    return mun;
}
@end
