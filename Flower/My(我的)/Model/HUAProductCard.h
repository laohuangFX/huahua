//
//  HUAProductCard.h
//  Flower
//
//  Created by 程召华 on 16/1/26.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUAProductCard : NSObject
@property (nonatomic, strong) NSString *shopname;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *card_name;
@property (nonatomic, strong) NSString *active_price;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *card_id;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *remain_times;
@property (nonatomic, strong) NSArray *service_scope;
@property (nonatomic, strong) NSString *shop_id;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *service_id;

+ (id)productCardWithDictionary:(NSDictionary *)dic;

+ (id)serviceScope:(NSDictionary *)dic;
@end
