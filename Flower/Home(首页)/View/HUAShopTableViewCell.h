//
//  HUAShopTableViewCell.h
//  Flower
//
//  Created by 程召华 on 16/1/5.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUAShopInfo.h"
@interface HUAShopTableViewCell : UITableViewCell


@property (strong, nonatomic) UIImageView *shopImageView;
@property (strong, nonatomic) UIImageView *locationImageView;
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *locationLabel;
@property (strong, nonatomic) UILabel *distanceLabel;
@property (strong, nonatomic) UILabel *shopNameLabel;
@property (strong, nonatomic) UIImageView *praiseImageView;
@property (strong, nonatomic) UILabel *praiseCountLabel;

@property (nonatomic, strong) HUAShopInfo *shopInfo;



@end
