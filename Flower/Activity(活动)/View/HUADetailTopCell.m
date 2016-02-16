//
//  HUADetailTopCell.m
//  Flower
//
//  Created by 程召华 on 16/1/8.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUADetailTopCell.h"

@interface HUADetailTopCell ()

@property (nonatomic, strong) UILabel *shopInfoLabel;

@property (nonatomic, strong) UIButton *buyButton;

@end



@implementation HUADetailTopCell



- (void)setTop:(HUADetailInfo *)top {
    _top = top;
    [self.activityImageView sd_setImageWithURL:[NSURL URLWithString:top.active_cover] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.nameLabel.text = top.name;
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",top.price];
    [self.priceLabel sizeToFit];
    self.vipPriceLabel.text = [NSString stringWithFormat:@"(会员价¥%@)",top.vip_discount];
     [self.vipPriceLabel sizeToFit];
    self.vipPriceLabel.frame = CGRectMake(self.priceLabel.x+self.priceLabel.width, self.priceLabel.y+hua_scale(4), hua_scale(100) , hua_scale(10));
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setCell];
    }
    return self;
}

- (void)setCell {
    self.activityImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, hua_scale(190))];
    
    [self addSubview:self.activityImageView];
    

    CGRect nameLabelFrame = CGRectMake(hua_scale(10), hua_scale(205), screenWidth-hua_scale(20), hua_scale(70));
    self.nameLabel = [UILabel labelWithFrame:nameLabelFrame text:@"水彩润唇膏3g 粉红主义唇彩保湿修护锁水有色护唇膏口红保湿修护锁水有色护唇膏口红" color:HUAColor(0x000000) font:hua_scale(13)];
    self.nameLabel.numberOfLines = 0;
//    [self.nameLabel setRowSpace:7];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.nameLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:7];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.nameLabel.text length])];
    self.nameLabel.attributedText = attributedString;
    [self addSubview:self.nameLabel];
    [self.nameLabel sizeToFit];

    
    CGRect buyFrame = CGRectMake(hua_scale(20), hua_scale(286), hua_scale(280), hua_scale(53));
    self.buyButton = [UIButton buttonWithFrame:buyFrame title:@"预约" image:@"appointment_white" font:hua_scale(15) titleColor:HUAColor(0xffffff)];
        self.buyButton.backgroundColor = HUAColor(0x4da000);

    [self.buyButton addTarget:self action:@selector(clickToBuy:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.buyButton];
    
    
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(hua_scale(10), self.buyButton.frame.origin.y-hua_scale(35),self.priceLabel.width, 0)];
    self.priceLabel.text = @"34900";
    self.priceLabel.textColor = HUAColor(0x4da800);
    self.priceLabel.font = [UIFont systemFontOfSize:hua_scale(14)];
    [self addSubview:self.priceLabel];
    
    

    self.vipPriceLabel = [UILabel labelWithFrame:CGRectZero text:@"(会员价格 ¥300)" color:HUAColor(0x4da800) font:hua_scale(11)];
    [self addSubview:self.vipPriceLabel];
   
    

    
    

    CGRect shopInfoFrame = CGRectMake(hua_scale(10), hua_scale(359), hua_scale(200), hua_scale(13));
    self.shopInfoLabel = [UILabel labelWithFrame:shopInfoFrame text:@"商家信息" color:HUAColor(0x000000) font:hua_scale(13)];
    [self addSubview:self.shopInfoLabel];
    
    
    
}

- (void)clickToBuy:(UIButton *)sender {
    
    if (self.pusViewBlock !=nil) {
        //跳转到活动订单确认
        self.pusViewBlock();
    }
    HUALog(@"点击了购买");
}



@end
