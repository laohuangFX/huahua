//
//  HUATechniciansOrdersViewController.h
//  Flower
//
//  Created by apple on 16/1/29.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUATechnicianModel.h"
@interface HUATechniciansOrdersViewController : UIViewController
@property (nonatomic, assign)BOOL showType;
//会员信息
@property (nonatomic, strong)NSString *membersName;
@property (nonatomic, strong)NSString *membersType;
@property (nonatomic, strong)NSString *membersMoney;

//项目
@property (nonatomic, strong)NSString *projectType;

//名字
@property (nonatomic, strong)NSString *technicianName;

//金额
@property (nonatomic, strong)NSString *moneyNumber;

@property (nonatomic, strong)HUATechnicianModel *model;
@end
