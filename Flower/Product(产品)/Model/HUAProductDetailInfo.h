//
//  HUAProductDetailInfo.h
//  Flower
//
//  Created by 程召华 on 16/1/15.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUAProductDetailInfo : NSObject
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *vip_discount;
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *desc;


+ (id)getProductDetailInfoWithDictionary:(NSDictionary *)dic;
@end
