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

//技师信息
@property (nonatomic, strong)HUAMasterDetailInfo *model;
@end
