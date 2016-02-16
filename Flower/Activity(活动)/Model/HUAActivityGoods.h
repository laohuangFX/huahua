//
//  HUAActivityGoods.h
//  Flower
//
//  Created by 程召华 on 16/1/6.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUAActivityGoods : NSObject
@property (nonatomic, strong) NSString *active_id;
@property (nonatomic, strong) NSString *shop_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *vip_discount;

+ (id)parseActivity:(NSDictionary *)dic;


@end
