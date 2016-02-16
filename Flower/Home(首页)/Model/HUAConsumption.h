//
//  HUAConsumption.h
//  Flower
//
//  Created by 程召华 on 16/1/28.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUAConsumption : NSObject
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *bill_id;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *first_name;

+ (id)consumptionInfoFromDictionary:(NSDictionary *)dic;
@end
