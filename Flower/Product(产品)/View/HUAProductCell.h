//
//  HUAProductCell.h
//  Flower
//
//  Created by 程召华 on 16/1/5.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUAProduct.h"

@interface HUAProductCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *productImageView;
@property (nonatomic, strong) UILabel *productNameLabel;
@property (nonatomic, strong) UILabel *praiseCountLabel;
@property (nonatomic, strong) UILabel *productPriceLabel;
@property (nonatomic, strong) UIImageView *praiseImageView;

@property (nonatomic, strong) HUAProduct *product;

@end
