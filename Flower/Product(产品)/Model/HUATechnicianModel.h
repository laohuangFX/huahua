//
//  HUATechnicianModel.h
//  Flower
//
//  Created by apple on 16/2/1.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUATechnicianModel : NSObject
//名字
@property (nonatomic, strong)NSString *name;
//图片
@property (nonatomic, strong)NSString *icon;
//类型
@property (nonatomic, strong)NSString *level_name;
//价格
@property (nonatomic, strong)NSString *price;
//技师id
@property (nonatomic, strong)NSString *master_id;
@end
