//
//  HUAShopDiscount.h
//  Flower
//
//  Created by 程召华 on 16/2/23.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUAShopDiscount : NSObject
+ (void)getShopDiscountWithShop_id:(NSString *)shop_id priceLabel:(UILabel *)priceLabel price:(NSString *)price;

@end
