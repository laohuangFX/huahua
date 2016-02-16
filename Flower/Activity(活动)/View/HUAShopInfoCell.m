//
//  HUAShopInfoCell.m
//  Flower
//
//  Created by 程召华 on 16/1/8.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAShopInfoCell.h"

@interface HUAShopInfoCell ()<UIActionSheetDelegate>
@property (nonatomic, strong) UIImageView *locationImageView;

@property (nonatomic, strong) UIButton *telephoneButton;

@property (nonatomic, strong) UIView *lineView;
@end



@implementation HUAShopInfoCell



- (void)setShopInfo:(HUADetailInfo *)shopInfo {
    _shopInfo = shopInfo;
    self.shopNameLabel.text = shopInfo.shopname;
    self.addressLabel.text = shopInfo.address;
    self.phoneNumber = shopInfo.phone;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setCell];
    }
    return self;
}

- (void)setCell {
    CGRect shopNameFrame = CGRectMake(hua_scale(10), hua_scale(10), hua_scale(200), hua_scale(16));
    self.shopNameLabel = [UILabel labelWithFrame:shopNameFrame text:@"漂亮女人美容店" color:HUAColor(0x4da800) font:hua_scale(13)];
    [self addSubview:self.shopNameLabel];
    
    self.locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(hua_scale(10), hua_scale(36), hua_scale(10), hua_scale(10))];
    self.locationImageView.contentMode = UIViewContentModeCenter;
    self.locationImageView.image = [UIImage imageNamed:@"location"];
    [self addSubview:self.locationImageView];
    
    CGRect addressFrame = CGRectMake(hua_scale(20), hua_scale(36), screenWidth - hua_scale(100)-1, hua_scale(10));
    self.addressLabel = [UILabel labelWithFrame:addressFrame text:@"广州市天河区中山大道西御富科贸园B1栋402室" color:HUAColor(0x6969696) font:hua_scale(10)];
    [self addSubview:self.addressLabel];
    
    self.telephoneButton = [UIButton buttonWithType:0];
    self.telephoneButton.frame = CGRectMake(hua_scale(280), hua_scale(21), hua_scale(20), hua_scale(20));
    [self.telephoneButton setImage:[UIImage imageNamed:@"telephone"] forState:UIControlStateNormal];
    [self.telephoneButton addTarget:self action:@selector(telephoneService:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.telephoneButton];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(hua_scale(260), hua_scale(12), 1, hua_scale(32))];
    self.lineView.backgroundColor = HUAColor(0xeeeeee);
    [self addSubview:self.lineView];
    
    
}

- (void)telephoneService:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(makePhoneCall)]) {
        [self.delegate makePhoneCall];
    }
}

@end
