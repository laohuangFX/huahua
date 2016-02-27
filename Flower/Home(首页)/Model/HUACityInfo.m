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
//    city.lat = dic[@"lat"];
//    city.lng = dic[@"lng"];
//    city.mergerName = [dic[@"mergername"] componentsSeparatedByString:@","][1];
//    city.parentid = dic[@"parentid"];
    return city;
}

+ (NSArray *)citysFromArray:(NSArray *)array{
    NSMutableArray *mun = [NSMutableArray array];
    HUACityInfo *info = [[HUACityInfo alloc]init];
    info.cityName = @"全城";
    info.cityid = @"99";
    [mun addObject:info];
    for (NSDictionary *dic in array) {
        HUACityInfo *info = [HUACityInfo modelWithDictionary:dic];
        [mun addObject:info];
    }
    return mun;
}


+ (NSString *)parentidForcityName:(NSString *)cityName array:(NSArray *)array{
    for (HUACityInfo*info in array) {
        for (HUACityInfo *infos in info.childrenArray) {
            if ([infos.cityName isEqualToString:cityName]) {
                return infos.cityid;
            }
        }
        
    }
    return @"99";
}
+ (NSString *)cityidForcityName:(NSString *)cityName array:(NSArray *)array{
    for (HUACityInfo*info in array) {
            if ([info.cityName isEqualToString:cityName]) {
                return info.cityid;
            }
    }
    for (HUACityInfo*info in array) {
        for (HUACityInfo *infos in info.childrenArray) {
            if ([infos.cityName isEqualToString:cityName]) {
                return info.cityid;
            }
        }
        
    }
    return @"";
}
@end
