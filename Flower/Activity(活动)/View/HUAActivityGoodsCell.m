//
//  HUAActivityGoodsCell.m
//  Flower
//
//  Created by 程召华 on 16/1/6.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAActivityGoodsCell.h"

@implementation HUAActivityGoodsCell

- (void)setGoods:(HUAActivityGoods *)goods {
    _goods = goods;
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:goods.cover] placeholderImage:[UIImage imageNamed:@"placeholder"]];
}

@end
