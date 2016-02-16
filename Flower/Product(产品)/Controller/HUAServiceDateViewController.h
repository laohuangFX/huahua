//
//  HUAServiceDateViewController.h
//  Flower
//
//  Created by apple on 16/1/29.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUATechnicianModel.h"
@interface HUAServiceDateViewController : UIViewController
//项目类型
@property (nonatomic, strong)NSString *category;

//店铺id
@property (nonatomic, strong)NSString *shop_id;

//名字
@property (nonatomic, strong)NSString *technicianName;
@property (nonatomic, strong)HUATechnicianModel *model;
@end
