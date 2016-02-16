//
//  HUAMasterDetailInfo.h
//  Flower
//
//  Created by 程召华 on 16/1/18.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUAMasterDetailInfo : NSObject
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *praise_count;

@property (nonatomic, strong) NSString *masterName;

@property (nonatomic, strong) NSString *masterType;

@property (nonatomic, strong) NSString *brief;

+ (id)getMasterDetailInfoWithDictionary:(NSDictionary *)dic;

@property (nonatomic, strong) NSArray *mien;
@property (nonatomic, strong) NSArray *achievementArray;
@property (nonatomic, strong) NSString *url;

+ (id)getMienArrayFromDictionary:(NSDictionary *)dic;

//预约的时间
@property (nonatomic, strong)NSDictionary *about_arrange;
//服务项目
@property (nonatomic, strong)NSArray *serviceArray;
@end
