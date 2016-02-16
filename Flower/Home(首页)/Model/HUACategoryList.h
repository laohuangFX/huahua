//
//  HUACategoryList.h
//  Flower
//
//  Created by 程召华 on 16/2/1.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUACategoryList : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *category_id;

+ (id)categoryListWithDictionary:(NSDictionary *)dic;
@end
