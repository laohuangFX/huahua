//
//  HUAServiceOrderDetailsViewController.h
//  Flower
//
//  Created by apple on 16/1/27.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HUAServiceOrderDetailsViewController : UIViewController
//订单id
@property (nonatomic, strong)NSString *bill_id;

//服务id
@property (nonatomic, strong)NSString *service_id;

//状态id
@property (nonatomic, strong)NSString *is_use;
@end
