//
//  HUAMyCollection.h
//  Flower
//
//  Created by 程召华 on 16/1/23.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUAMyCollection : NSObject
@property (nonatomic, strong) NSString *shopname;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *praise_sum;
@property (nonatomic, strong) NSString *shop_id;
@property (nonatomic) id is_vip;
@property (nonatomic) id is_praise;

+ (id)collectionInfoWithDictionary:(NSDictionary *)dic;
@end
