//
//  HUAMyOrderModel.h
//  Flower
//
//  Created by apple on 16/1/26.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUAMyOrderModel : NSObject
//订单id
@property (nonatomic, strong)NSString *bill_id;
//金钱
@property (nonatomic, strong)NSString *money;
//商店名称
@property (nonatomic, strong)NSString *shopName;
//产品id
@property (nonatomic, strong)NSString *product_id;
//服务期限
@property (nonatomic, strong)NSString *service_id;
//单号
@property (nonatomic, strong)NSString *bill_num;
//时间
@property (nonatomic, strong)NSString *time;
//是否发货
@property (nonatomic, assign)NSString *shipPing;
//服务 是否使用
@property (nonatomic, assign)NSString *is_use;
//产品 针对产品
@property (nonatomic, assign)NSString *is_receipt;
//名称
@property (nonatomic, strong)NSString *titleNmae;
//图片
@property (nonatomic, strong)NSString *icon;
//活动剩余次数
@property (nonatomic, strong)NSString *remainNum;
//类型
@property (nonatomic, strong)NSString *type;
//活动id
@property (nonatomic, strong)NSString *active_id;
//商店id
@property (nonatomic, strong)NSString *shop_id;
@end
