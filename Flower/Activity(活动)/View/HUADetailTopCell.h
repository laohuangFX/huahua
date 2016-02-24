//
//  HUADetailTopCell.h
//  Flower
//
//  Created by 程召华 on 16/1/8.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUADetailInfo.h"
@interface HUADetailTopCell : UITableViewCell
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *vipPriceLabel;

@property (nonatomic, strong) UIImageView *activityImageView;

@property (nonatomic, strong) HUADetailInfo *top;
@property (nonatomic, assign) CGFloat HUADetailTopCellH;
//block回调跳转活动订单确认页面
@property (nonatomic, copy)void (^pusViewBlock) (void);
@end
