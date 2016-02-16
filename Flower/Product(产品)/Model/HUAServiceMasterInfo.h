//
//  HUAServiceMasterInfo.h
//  Flower
//
//  Created by 程召华 on 16/1/15.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUAServiceMasterInfo : NSObject
@property (nonatomic, strong) NSString *master_id;
@property (nonatomic, strong) NSString *masterName;
@property (nonatomic, strong) NSString *masterType;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *praise_count;

+ (id)getMasterInfo:(NSDictionary *)dic;
@end
