//
//  HUAShopProduct.h
//  Flower
//
//  Created by 程召华 on 16/1/14.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUAShopProduct : NSObject
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *praise_count;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *product_id;
@property (nonatomic, strong) NSString *service_id;
@property (nonatomic, strong) NSString *shop_id;
+ (id)parseWithDictionary:(NSDictionary *)dic;
@end
