//
//  HUAMyMemberCard.h
//  Flower
//
//  Created by 程召华 on 16/1/25.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUAMyMemberCard : NSObject
@property (nonatomic, strong) NSString *shop_id;
@property (nonatomic, strong) NSString *shopname;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *money;

+ (id)myMemberCardWithDictionary:(NSDictionary *)dic;
@end
