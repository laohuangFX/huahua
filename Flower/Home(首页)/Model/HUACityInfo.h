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
//@property (nonatomic,strong)NSString *lat;
//@property (nonatomic,strong)NSString *lng;
//@property (nonatomic,strong)NSString *mergerName;
//@property (nonatomic,strong)NSString *parentid;
@property (nonatomic,strong)NSArray *childrenArray;

+ (instancetype)modelWithDictionary:(NSDictionary *)dic;
+ (NSArray *)citysFromArray:(NSArray *)array;
+ (NSString *)parentidForcityName:(NSString *)cityName array:(NSArray *)array;
+ (NSString *)cityidForcityName:(NSString *)cityName array:(NSArray *)array;
@end
