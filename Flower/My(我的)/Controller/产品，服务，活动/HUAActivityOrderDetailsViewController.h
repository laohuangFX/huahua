//
//  HUAActivityOrderDetailsViewController.h
//  Flower
//
//  Created by apple on 16/1/27.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HUAActivityOrderDetailsViewController : UIViewController
//订单id
@property (nonatomic, strong)NSString *bill_id;
//活动id
@property (nonatomic, strong)NSString *active_id;
//次数
@property (nonatomic, strong)NSString *number;

@property (nonatomic, strong)NSString *shop_id;
@end
