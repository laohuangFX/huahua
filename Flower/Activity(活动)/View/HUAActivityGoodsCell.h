//
//  HUAActivityGoodsCell.h
//  Flower
//
//  Created by 程召华 on 16/1/6.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUAActivityGoods.h"
@interface HUAActivityGoodsCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;

@property (nonatomic, strong) HUAActivityGoods *goods;
@end
