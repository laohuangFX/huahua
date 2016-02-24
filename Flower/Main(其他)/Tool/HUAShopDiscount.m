//
//  HUAShopDiscount.m
//  Flower
//
//  Created by 程召华 on 16/2/23.
//  Copyright © 2016年 readchen.com. All rights reserved.
//
#define shop_vip     @"general/shop_vip"
#define Is_vip       @"user/is_vip"
#import "HUAShopDiscount.h"
#import "HUAUserDetailInfo.h"
#import "HUAUserDefaults.h"
@interface HUAShopDiscount()

@end



@implementation HUAShopDiscount
+ (void)getShopDiscountWithShop_id:(NSString *)shop_id priceLabel:(UILabel *)priceLabel price:(NSString *)price{
    if ([HUAUserDefaults getUserDetailInfo].user_id) {
        NSString *url = [HUA_URL stringByAppendingPathComponent:Is_vip];
        NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
        parameter[@"shop_id"] = shop_id;
        [HUAHttpTool GETWithTokenAndUrl:url params:parameter success:^(id responseObject) {
            HUALog(@"是不是会员%@",responseObject);
            if ([responseObject[@"info"] isKindOfClass:[NSDictionary class]]) {
                NSString *discount = responseObject[@"info"][@"discount"];
                NSString *priceString = price;
                NSString *discountString = [NSString stringWithFormat:@"%.2f",[price  integerValue]*[discount doubleValue]/10];
                priceLabel.text = [NSString stringWithFormat:@"¥%@(会员价¥%@)",priceString,discountString];
                NSMutableAttributedString *balanceAttributedString = [[NSMutableAttributedString alloc] initWithString:priceLabel.text];
                [balanceAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:hua_scale(10)] range:NSMakeRange([priceString length]+1,[priceLabel.text length]-([priceString length]+1))];
                [balanceAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:hua_scale(13)] range:NSMakeRange(0, [priceString length]+1)];
                priceLabel.attributedText = balanceAttributedString;
            }else{
                NSString *url = [HUA_URL stringByAppendingPathComponent:shop_vip];
                NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
                parameter[@"shop_id"] = shop_id;
                [HUAHttpTool GETWithTokenAndUrl:url params:parameter success:^(id responseObject) {
                    NSString *discount = responseObject[@"info"][@"discount"];
                    NSString *priceString = price;
                    NSString *discountString = [NSString stringWithFormat:@"%.2f",[price  integerValue]*[discount doubleValue]/10];
                    priceLabel.text = [NSString stringWithFormat:@"¥%@(会员价¥%@)",priceString,discountString];
                    NSMutableAttributedString *balanceAttributedString = [[NSMutableAttributedString alloc] initWithString:priceLabel.text];
                    [balanceAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:hua_scale(10)] range:NSMakeRange([priceString length]+1,[priceLabel.text length]-([priceString length]+1))];
                    [balanceAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:hua_scale(13)] range:NSMakeRange(0, [priceString length]+1)];
                    priceLabel.attributedText = balanceAttributedString;
                    
                } failure:^(NSError *error) {
                    HUALog(@"%@",error);
                }];
            }
            
            
        } failure:^(NSError *error) {
            HUALog(@"%@",error);
        }];

    }else {
            NSString *url = [HUA_URL stringByAppendingPathComponent:shop_vip];
            NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
            parameter[@"shop_id"] = shop_id;
            [HUAHttpTool GETWithTokenAndUrl:url params:parameter success:^(id responseObject) {
                NSString *discount = responseObject[@"info"][@"discount"];
                NSString *priceString = price;
                NSString *discountString = [NSString stringWithFormat:@"%.2f",[price  integerValue]*[discount doubleValue]/10];
                priceLabel.text = [NSString stringWithFormat:@"¥%@(会员价¥%@)",priceString,discountString];
                NSMutableAttributedString *balanceAttributedString = [[NSMutableAttributedString alloc] initWithString:priceLabel.text];
                [balanceAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:hua_scale(10)] range:NSMakeRange([priceString length]+1,[priceLabel.text length]-([priceString length]+1))];
                [balanceAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:hua_scale(13)] range:NSMakeRange(0, [priceString length]+1)];
                priceLabel.attributedText = balanceAttributedString;
        
            } failure:^(NSError *error) {
                HUALog(@"%@",error);
            }];

    }
}


@end
