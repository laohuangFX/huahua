//
//  HUAMyProductTableViewCell.h
//  Flower
//
//  Created by apple on 16/1/12.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUAProductCard.h"
@interface HUAMyProductTableViewCell : UITableViewCell
@property (nonatomic, strong)NSArray *array;

@property (nonatomic, strong) HUAProductCard *productCard;
@end
