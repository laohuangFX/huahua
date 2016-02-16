//
//  HUAUserDetailInfo.h
//  Flower
//
//  Created by 程召华 on 16/1/21.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUAUserDetailInfo : NSObject <NSCoding>
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *last_log_time;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *headicon;
@property (nonatomic, strong) NSString *birth;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *addr_id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *sex;


+ (id)userDetailInfoWithDictionary:(NSDictionary *)dic;
@end
