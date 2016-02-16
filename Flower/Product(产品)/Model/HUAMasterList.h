//
//  HUAMasterList.h
//  Flower
//
//  Created by 程召华 on 16/1/18.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUAMasterList : NSObject
@property (nonatomic, strong) NSString *master_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *praise_count;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *level_name;


+ (id)getMasterListWithDictionary:(NSDictionary *)dic;
@end
