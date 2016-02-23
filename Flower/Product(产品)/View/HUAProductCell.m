//
//  HUAProductCell.m
//  Flower
//
//  Created by 程召华 on 16/1/5.
//  Copyright © 2016年 readchen.com. All rights reserved.
//
#define shop_vip     @"general/shop_vip"
#import "HUAProductCell.h"

#define productWidth (([UIScreen mainScreen].bounds.size.width)/2)
#define productHeight hua_scale(220)

@interface HUAProductCell()
@property (nonatomic, strong) id is_Vip;
@end

@implementation HUAProductCell


-(void)setProduct:(HUAProduct *)product {
    _product = product;
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:product.cover] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.productNameLabel.text = product.name;
    self.praiseCountLabel.text = [NSString stringWithFormat:@"%@赞过",product.praise_count];
    //[HUAShopDiscount getShopDiscountWithShop_id:product.shop_id priceLabel:self.productPriceLabel price:product.price];
    self.productPriceLabel.text = [NSString stringWithFormat:@"¥%@",product.price];
}



- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setCell];
    }
    return self;
}
- (void)setCell {
    self.productImageView = [[UIImageView alloc] initWithFrame:CGRectMake(hua_scale(14), hua_scale(14), hua_scale(132), hua_scale(132))];
    [self addSubview:self.productImageView];
    
    self.productNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(hua_scale(14), hua_scale(156), hua_scale(132), hua_scale(10))];
    self.productNameLabel.text = @"保肌研极保湿";
    self.productNameLabel.textColor = HUAColor(0x333333);
    self.productNameLabel.font = [UIFont systemFontOfSize:hua_scale(12)];
    [self addSubview:self.productNameLabel];
    
    self.praiseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(hua_scale(14), hua_scale(175), hua_scale(9), hua_scale(9))];
    self.praiseImageView.contentMode = UIViewContentModeCenter;
    self.praiseImageView.image = [UIImage imageNamed:@"productprise"];
    [self addSubview:self.praiseImageView];
    
    self.praiseCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(hua_scale(27), hua_scale(175), hua_scale(100), hua_scale(9))];
    self.praiseCountLabel.text = @"1526赞过";
    self.praiseCountLabel.textColor = HUAColor(0xc3c3c3);
    self.praiseCountLabel.font = [UIFont systemFontOfSize:hua_scale(9)];
    [self addSubview:self.praiseCountLabel];
    
    
    self.productPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(hua_scale(14), hua_scale(193), hua_scale(200), hua_scale(16))];
    self.productPriceLabel.text = @"¥ 200.45";
//    self.productPriceLabel.font = [UIFont systemFontOfSize:hua_scale(13)];
    self.productPriceLabel.textColor = HUAColor(0x4da800);
    [self addSubview:self.productPriceLabel];
    
   
    
}






@end
