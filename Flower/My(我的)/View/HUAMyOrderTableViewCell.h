//
//  HUAMyOrderTableViewCell.h
//  Flower
//
//  Created by apple on 16/1/12.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUAMyOrderModel.h"
@interface HUAMyOrderTableViewCell : UITableViewCell
@property (nonatomic, strong)HUAMyOrderModel *model;

@property (nonatomic, copy)void (^showBlock)(UIAlertController *alert);

@property (nonatomic, copy)void (^goodsBlock)(NSIndexPath *indexPath);

@property (nonatomic, strong)NSIndexPath *indexPath;
@end
