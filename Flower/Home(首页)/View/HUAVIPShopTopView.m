//
//  HUAVIPShopTopView.m
//  Flower
//
//  Created by 程召华 on 16/1/14.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAVIPShopTopView.h"

@interface HUAVIPShopTopView ()
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UIImageView *phoneImageView;
@property (nonatomic, strong) UIImageView *addressImageView;
@property (nonatomic, strong) UILabel *pLabel;
@property (nonatomic, strong) UILabel *aLabel;
@end


@implementation HUAVIPShopTopView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, hua_scale(190))];
        [self addSubview:self.topImageView];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(hua_scale(10), hua_scale(107), hua_scale(75), hua_scale(60))];
        self.iconImageView.layer.borderWidth = hua_scale(1);
        self.iconImageView.layer.borderColor = HUAColor(0xFFFFFF).CGColor;
        [self addSubview:self.iconImageView];
        
        CGRect shopNameFrame = CGRectMake(hua_scale(100), hua_scale(150), hua_scale(200), hua_scale(15));
        self.shopNameLabel = [UILabel labelWithFrame:shopNameFrame text:@"华乐国际美丽造型" color:HUAColor(0xFFFFFF) font:hua_scale(16)];
        [self addSubview:self.shopNameLabel];
        
        
        self.phoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(hua_scale(9), hua_scale(348), hua_scale(30), hua_scale(30))];
        self.phoneImageView.image = [UIImage imageNamed:@"shoptelephone"];
        [self addSubview:self.phoneImageView];
        
        CGRect pLabelFrame = CGRectMake(hua_scale(50), hua_scale(350), hua_scale(50), hua_scale(10));
        self.pLabel = [UILabel labelWithFrame:pLabelFrame text:@"电话 :" color:HUAColor(0x0b0b0b) font:hua_scale(12)];
        [self addSubview:self.pLabel];
        
        CGRect phoneLabelFrame = CGRectMake(hua_scale(50), hua_scale(365), hua_scale(200), hua_scale(10));
        self.phoneLabel = [UILabel labelWithFrame:phoneLabelFrame text:@"020-88886958" color:HUAColor(0x4da800) font:hua_scale(12)];
        [self addSubview:self.phoneLabel];
        
        self.addressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(hua_scale(9), hua_scale(388), hua_scale(30), hua_scale(30))];
        self.addressImageView.image = [UIImage imageNamed:@"address"];
        [self addSubview:self.addressImageView];
        
        CGRect aLabelFrame = CGRectMake(hua_scale(50), hua_scale(389), hua_scale(50), hua_scale(10));
        self.aLabel = [UILabel labelWithFrame:aLabelFrame text:@"地址 :" color:HUAColor(0x0b0b0b) font:hua_scale(12)];
        [self addSubview:self.aLabel];
    }
    return self;
}

- (void)setShopIntroduce:(HUAShopIntroduce *)shopIntroduce {
    _shopIntroduce = shopIntroduce;
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:shopIntroduce.cover] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:shopIntroduce.icon] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.shopNameLabel.text = shopIntroduce.shopname;
    self.phoneLabel.text = shopIntroduce.phone;
    
}

@end
