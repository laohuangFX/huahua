//
//  HUATechnicianViewController.h
//  Flower
//
//  Created by apple on 16/1/16.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HUATechnicianViewController : UIViewController
//数据字典
@property (nonatomic, strong)NSArray *modelArray;

//服务id
@property (nonatomic, strong)NSString *service_id;

//服务项目类型
@property (nonatomic, strong)NSString *category; 
@end
