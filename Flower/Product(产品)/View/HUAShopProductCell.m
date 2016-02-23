//
//  HUAShopProductCell.m
//  Flower
//
//  Created by 程召华 on 16/1/13.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAShopProductCell.h"

@interface HUAShopProductCell ()

@end


@implementation HUAShopProductCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setCell];
    }
    return self;
}

- (void)setCell {
    self.goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(hua_scale(8), hua_scale(8), hua_scale(90), hua_scale(90))];
    [self addSubview:self.goodsImageView];
    
    self.goodsNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(hua_scale(114), hua_scale(22), hua_scale(204), 0)];
    self.goodsNameLabel.numberOfLines = 0;
    self.goodsNameLabel.text = @"曼秀雷敦";
    self.goodsNameLabel.font = [UIFont systemFontOfSize:hua_scale(13)];
    self.goodsNameLabel.textColor = HUAColor(0x333333);
    [self addSubview:self.goodsNameLabel];
    self.goodsNameLabel.numberOfLines = 2;
    [self.goodsNameLabel sizeToFit];
    
    self.praiseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(hua_scale(114),CGRectGetMaxY(self.goodsNameLabel.frame) + hua_scale(6), hua_scale(hua_scale(9)), hua_scale(8))];
    self.praiseImageView.image = [UIImage imageNamed:@"productprise"];
    [self addSubview:self.praiseImageView];
    
    CGRect praiseFrame = CGRectMake(hua_scale(125),CGRectGetMaxY(self.goodsNameLabel.frame) + hua_scale(6), hua_scale(100), hua_scale(8));
    
    self.praiseLabel = [UILabel labelWithFrame:praiseFrame text:@"1526赞过" color:HUAColor(0xc3c3c3) font:hua_scale(9)];
    [self addSubview:self.praiseLabel];
    
    CGRect priceFrame = CGRectMake(hua_scale(114),CGRectGetMaxY(self.praiseLabel.frame)+ hua_scale(5), hua_scale(150), hua_scale(10));
    self.priceLabel = [UILabel labelWithFrame:priceFrame text:@"¥200.45" color:HUAColor(0x4da800) font:hua_scale(13)];
    [self addSubview:self.priceLabel];
    
    
    
}


-(void)setProduct:(HUAShopProduct *)product {
    _product = product;
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:product.cover] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.goodsNameLabel.text = product.name;
//    self.goodsNameLabel.text = @"11234567890-qwertyuiopppasdfghjkl;'zxcvbnm,,";
    
    CGRect frame = self.goodsNameLabel.frame;
    frame.size.width = hua_scale(204);
    self.goodsNameLabel.frame = frame;
    [self.goodsNameLabel sizeToFit];
    
    self.praiseLabel.text = [NSString stringWithFormat:@"%@赞过",product.praise_count];
    self.praiseImageView.frame = CGRectMake(hua_scale(114), self.goodsNameLabel.y + self.goodsNameLabel.height + hua_scale(6), hua_scale(hua_scale(9)), hua_scale(8));
    CGRect praiseFrame = CGRectMake(hua_scale(125), self.goodsNameLabel.y + self.goodsNameLabel.height + hua_scale(6), hua_scale(100), hua_scale(8));
    self.praiseLabel.frame = praiseFrame;
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",product.price];
    CGRect priceFrame = CGRectMake(hua_scale(114),CGRectGetMaxY(self.praiseLabel.frame)+ hua_scale(5), hua_scale(150), hua_scale(10));
    self.priceLabel.frame = priceFrame;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
