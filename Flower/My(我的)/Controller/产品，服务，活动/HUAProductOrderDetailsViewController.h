//
//  HUAProductOrderDetailsViewController.h
//  Flower
//
//  Created by apple on 16/1/27.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HUAProductOrderDetailsViewController : UIViewController
//订单
@property (nonatomic, strong)NSString *bill_num;
//产品id
@property (nonatomic, strong)NSString *product_id;
//类型
@property (nonatomic, strong)NSString *type;
//状态
@property (nonatomic, strong)NSString *is_receipt;

@property (nonatomic, strong)NSString *shop_id;
@end
