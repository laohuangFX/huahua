//
//  HUAAddressModel.h
//  Flower
//
//  Created by apple on 16/2/3.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUAAddressModel : NSObject

//地址Id
@property (nonatomic, strong)NSString *addr_id;

//收货地址
@property (nonatomic, strong)NSString *name;

//收货人手机号码
@property (nonatomic, strong)NSString *phone;

//省
@property (nonatomic, strong)NSString *province;

//市
@property (nonatomic, strong)NSString *city;

//区
@property (nonatomic, strong)NSString *region;

//详细地址
@property (nonatomic, strong)NSString *address;
@end
