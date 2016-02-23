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
    
    self.goodsNameLabel = [[UILabel alloc] init];
    self.goodsNameLabel.numberOfLines = 2;
    self.goodsNameLabel.text = @"曼秀雷敦 男士洗面奶 冰冰爽火炭洁面曼秀雷敦 男士洗面奶 冰冰爽火炭洁面";
    self.goodsNameLabel.font = [UIFont systemFontOfSize:hua_scale(13)];
    self.goodsNameLabel.textColor = HUAColor(0x333333);
    [self addSubview:self.goodsNameLabel];
    [self.goodsNameLabel sizeToFit];
    
    self.praiseImageView = [[UIImageView alloc] init];
    self.praiseImageView.image = [UIImage imageNamed:@"productprise"];
    self.praiseImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:self.praiseImageView];
    
    
    
    self.praiseLabel = [UILabel labelWithFrame:CGRectZero text:@"1526赞过" color:HUAColor(0xc3c3c3) font:hua_scale(9)];
    [self addSubview:self.praiseLabel];
    
    
    CGRect priceFrame = CGRectMake(hua_scale(114), hua_scale(77), hua_scale(150), hua_scale(11));
    self.priceLabel = [UILabel labelWithFrame:priceFrame text:@"¥200.45" color:HUAColor(0x4da800) font:hua_scale(13)];
    [self addSubview:self.priceLabel];
    
    
    
}


-(void)setProduct:(HUAShopProduct *)product {
    _product = product;
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:product.cover] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.goodsNameLabel.text = product.name;
    self.goodsNameLabel.frame = CGRectMake(hua_scale(114), hua_scale(22), hua_scale(204), 0);
    [self.goodsNameLabel sizeToFit];
    HUALog(@"self.goodsNameLabel.height%f",self.goodsNameLabel.height);
    if (self.goodsNameLabel.height > 20) {
        self.praiseImageView.frame = CGRectMake(hua_scale(114), CGRectGetMaxY(self.goodsNameLabel.frame)+ hua_scale(6), hua_scale(hua_scale(9)), hua_scale(8));
        self.praiseLabel.text = [NSString stringWithFormat:@"%@赞过",product.praise_count];
        self.praiseLabel.frame =  CGRectMake(hua_scale(125), CGRectGetMaxY(self.goodsNameLabel.frame)+ hua_scale(6), hua_scale(100), hua_scale(8));
    }else {
        self.praiseImageView.frame = CGRectMake(hua_scale(114), CGRectGetMaxY(self.goodsNameLabel.frame)+ hua_scale(10), hua_scale(hua_scale(9)), hua_scale(8));
        self.praiseLabel.text = [NSString stringWithFormat:@"%@赞过",product.praise_count];
        self.praiseLabel.frame =  CGRectMake(hua_scale(125), CGRectGetMaxY(self.goodsNameLabel.frame)+ hua_scale(10), hua_scale(100), hua_scale(8));
    }

    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",product.price];
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
