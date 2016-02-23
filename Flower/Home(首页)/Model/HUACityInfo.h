//
//  HUACityInfo.h
//  Flower
//
//  Created by applewoainiqwe on 16/2/22.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUACityInfo : NSObject
@property (nonatomic,strong)NSString *cityName;
@property (nonatomic,strong)NSString *cityid;
@property (nonatomic,strong)NSString *lat;
@property (nonatomic,strong)NSString *lng;
@property (nonatomic,strong)NSString *mergerName;
@property (nonatomic,strong)NSString *parentid;

+ (NSArray *)citysFromArray:(NSArray *)array;
+ (NSString *)parentidForcityName:(NSString *)cityName array:(NSArray *)array;
@end
