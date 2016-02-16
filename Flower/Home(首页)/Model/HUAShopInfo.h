//
//  HUAShopInfo.h
//  Flower
//
//  Created by 程召华 on 16/1/5.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUAShopInfo : NSObject

@property (nonatomic, strong) NSString *shop_id;
@property (nonatomic, strong) NSString *shopname;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *poid;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *praise_count;
@property (nonatomic, strong) id is_vip;


@property (nonatomic, strong) NSString *banner_pic;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSArray *bannerArr;


+ (id)parseHomeDataWithDictionary:(NSDictionary *)dic;

+ (id)parseBannerWithDictionary:(NSDictionary *)dic;
@end
