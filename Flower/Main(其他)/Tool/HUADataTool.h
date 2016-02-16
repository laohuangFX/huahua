//
//  HUADataTool.h
//  Flower
//
//  Created by 程召华 on 16/1/8.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HUAmodel.h"
#import "HUAShopProduct.h"

@interface HUADataTool : NSObject
+ (NSArray *)activity:(NSDictionary *)dic;

+ (NSArray *)activityDetail:(NSDictionary *)dic;

//动态
+ (NSArray *)status:(NSDictionary *)dic;
//动态详情
+ (NSArray *)DynamicDetails:(NSDictionary *)dic;
//我的订单
+ (NSArray *)MyOrder:(NSDictionary *)dic;
//技师列表
+ (NSArray *)TechnicianJson:(NSDictionary *)dic;
//收货地址
+ (NSArray *)addressJson:(NSDictionary *)dic;

+ (NSArray *)homeShop:(NSDictionary *)dic;

+ (NSArray *)homeBanner:(NSDictionary *)dic;

+ (NSArray *)activeCover:(NSDictionary *)dic;

+ (NSArray *)activeID:(NSDictionary *)dic;

+ (NSArray *)shopProduct:(NSDictionary *)dic;

+ (NSArray *)getMasterArray:(NSDictionary *)dic;

+ (NSArray *)getProductArray:(NSDictionary *)dic;

+ (NSArray *)getChooseMaster:(NSDictionary *)dic;

+ (NSArray *)getMasterList:(NSDictionary *)dic;

+ (NSArray *)achievementArray:(NSDictionary *)dic;

+ (NSArray *)mienArray:(NSDictionary *)dic;

+ (NSArray *)collectionArray:(NSDictionary *)dic;

+ (NSArray *)myMemberCardArray:(NSDictionary *)dic;

+ (NSArray *)getProductCard:(NSDictionary *)dic;

+ (NSArray *)getConsumption:(NSDictionary *)dic;

+ (NSArray *)getCategoryList:(NSDictionary *)dic;

@end
