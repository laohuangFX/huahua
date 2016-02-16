//
//  HUAChooseMaster.h
//  Flower
//
//  Created by 程召华 on 16/1/17.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUAChooseMaster : NSObject
@property (nonatomic, strong) NSString *master_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *fee;



+ (id)getMasterWithDictionary:(NSDictionary *)dic;
@end
