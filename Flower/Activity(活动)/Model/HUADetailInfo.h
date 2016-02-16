//
//  HUADetailInfo.h
//  Flower
//
//  Created by 程召华 on 16/1/6.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUADetailInfo : NSObject
//活动图片
@property (nonatomic, strong) NSString *active_cover;
//商品名称
@property (nonatomic, strong) NSString *name;
//
@property (nonatomic, strong) NSString *detail;
//价格
@property (nonatomic, strong) NSString *price;
//vip价格
@property (nonatomic, strong) NSString *vip_discount;
//商铺名称
@property (nonatomic, strong) NSString *shopname;
//地址
@property (nonatomic, strong) NSString *address;
//电话
@property (nonatomic, strong) NSString *phone;
//活动开始时间
@property (nonatomic, strong) NSString *start_time;
//活动结束时间
@property (nonatomic, strong) NSString *end_time;
//点赞数
@property (nonatomic, strong) NSString *praise_count;
//活动标题
//@property (nonatomic, strong) NSString *article;


//活动图片地址
@property (nonatomic, strong) NSString *pic;

//活动图文
@property (nonatomic, strong) NSString *text;

+ (id)parseDetailinfo:(NSDictionary *)dic;

+ (id)getDetailTextAndImageWithDictionary:(NSDictionary *)dic;


@end
