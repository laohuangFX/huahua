//
//  HUAShopProductCell.h
//  Flower
//
//  Created by 程召华 on 16/1/13.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUAShopProduct.h"
@interface HUAShopProductCell : UITableViewCell
@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UILabel *goodsNameLabel;
@property (nonatomic, strong) UIImageView *praiseImageView;
@property (nonatomic, strong) UILabel *praiseLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) HUAShopProduct *product;
@end
