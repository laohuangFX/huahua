//
//  HUAShopIntroduce.h
//  Flower
//
//  Created by 程召华 on 16/1/12.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUAShopIntroduce : NSObject
@property (nonatomic, strong) NSString *shopname;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *praise_count;
@property (nonatomic, strong) NSString *product_count;
@property (nonatomic, strong) NSString *service_count;
@property (nonatomic, strong) NSString *master_count;
@property (nonatomic, strong) NSString *active_count;
@property (nonatomic, strong) NSDictionary *refill_setting;

+ (id)parseFrontShopPageWithDictionary:(NSDictionary *)dic;


@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSNumber *have_collected;
@property (nonatomic, strong) NSNumber *have_praised;
+ (id)parseUserInfoDictionary:(NSDictionary *)dic;

@property (nonatomic, strong) NSString *active_id;
@property (nonatomic, strong) NSString *active_cover;
@property (nonatomic, strong) NSArray *coverArray;
@property (nonatomic, strong) NSArray *idArray;
+ (id)parseActiveWithDictionary:(NSDictionary *)dic;

@end
