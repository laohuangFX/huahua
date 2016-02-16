//
//  HUAMakeAnAppointmentViewController.h
//  Flower
//
//  Created by apple on 16/1/18.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUAMasterDetailInfo.h"
@interface HUAMakeAnAppointmentViewController : UIViewController
//技师id
@property (nonatomic, strong)NSString *master_id;

//店铺id
@property (nonatomic, strong)NSString *shop_id;

//技师班次
@property (nonatomic, strong)NSString *range_type_id;

//技师信息
@property (nonatomic, strong)HUAMasterDetailInfo *model;
@end
