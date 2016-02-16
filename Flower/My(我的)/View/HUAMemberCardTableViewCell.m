//
//  HUAMemberCardTableViewCell.m
//  Flower
//
//  Created by apple on 16/1/12.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAMemberCardTableViewCell.h"

@interface HUAMemberCardTableViewCell ()
//icon图片
@property (nonatomic,strong)UIImageView *iconImageView;

//余额
@property (nonatomic, strong)UILabel *pageLable;
@property (nonatomic, strong)UILabel *balanceLable;
//商店名
@property (nonatomic, strong)UILabel *shopName;
//地址
@property (nonatomic,strong)UIImageView *locationImageView;

@property (nonatomic, strong)UILabel *addressLabel;

@property (nonatomic, strong)UIButton *addressButton;
//线
@property (nonatomic, strong)UIView *threadView;

@end

@implementation HUAMemberCardTableViewCell

- (void)setMemberCard:(HUAMyMemberCard *)memberCard {
    _memberCard = memberCard;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:memberCard.icon] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.shopName.text = memberCard.shopname;
    self.addressLabel.text = memberCard.address;
    self.balanceLable.text = [NSString stringWithFormat:@"¥%@",memberCard.money];
}




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setCell];
    }

    return self;
}
- (void)setCell{

    _iconImageView = [UIImageView new];
    //_iconImageView.backgroundColor = [UIColor yellowColor];
    
    _shopName = [UILabel new];
    //_shopName.backgroundColor = [UIColor blueColor];
    _shopName.text = @"华乐国际美丽造型华乐";
    _shopName.font = [UIFont systemFontOfSize:13];
    
    _locationImageView = [UIImageView new];
    _locationImageView.image = [UIImage imageNamed:@"location"];
    _locationImageView.contentMode = UIViewContentModeCenter;
    
    _addressLabel = [UILabel labelWithFrame:CGRectZero text:@"广州市天河区中山大道西御富科贸园B1栋410室" color:HUAColor(0x969696) font:hua_scale(10)];
    
    
    
    _addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //_addressButton.backgroundColor = [UIColor grayColor];
    _addressButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail,
    [_addressButton setTitle:@"广州市天河区中山大道西御富科贸园B1栋410室" forState:0];
    [_addressButton setImage:[UIImage imageNamed:@"location"] forState:0];
    _addressButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [_addressButton setTitleColor:HUAColor(0x969696) forState:0];
    [_addressButton setImageEdgeInsets:UIEdgeInsetsMake(0, hua_scale(0), 0, 0)];
    [_addressButton setTitleEdgeInsets:UIEdgeInsetsMake(0, hua_scale(2),0,0)];
    
    
    _threadView = [UIView new];
    _threadView.backgroundColor = HUAColor(0xf3f3f3);
    
    _pageLable = [UILabel labelWithFrame:CGRectZero text:@"余额" color:HUAColor(0x969696) font:hua_scale(10)];
 
    _balanceLable = [UILabel labelWithFrame:CGRectZero text:@"¥131400" color:HUAColor(0x4da800) font:hua_scale(15)];

    UIView *separateLine = [UIView new];
    separateLine.backgroundColor = HUAColor(0xcdcdcd);
    //加入父视图
    NSArray *views = @[_iconImageView,_shopName, _locationImageView,_addressLabel,_balanceLable,_pageLable,_threadView,separateLine];
    

    [views enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contentView addSubview:obj];
    }];
    
    UIView *contentView = self.contentView;

    _iconImageView.sd_layout
    .topSpaceToView(contentView,hua_scale(15))
    .leftSpaceToView(contentView,hua_scale(10))
    .heightIs(hua_scale(47))
    .widthIs(60);
    
    _threadView.sd_layout
    .rightSpaceToView(contentView,hua_scale(76))
    .widthIs(hua_scale(1))
    .topEqualToView(_iconImageView)
    .bottomEqualToView(_iconImageView);
    
    _shopName.sd_layout
    .topSpaceToView(contentView,hua_scale(17))
    .leftSpaceToView(_iconImageView,hua_scale(10))
    .rightSpaceToView(_threadView,hua_scale(5))
    .heightIs(hua_scale(13));
    
    _locationImageView.sd_layout
    .topSpaceToView(_shopName,hua_scale(10))
    .leftSpaceToView(_iconImageView,hua_scale(10))
    .widthIs(hua_scale(7))
    .heightIs(hua_scale(10));
    
    _addressLabel.sd_layout
    .topSpaceToView(_shopName,hua_scale(10))
    .leftSpaceToView(_locationImageView,hua_scale(4))
    .rightSpaceToView(_threadView,hua_scale(13))
    .heightIs(hua_scale(10));
    
//    _addressButton.sd_layout
//    .topSpaceToView(_shopName,hua_scale(10))
//    .leftEqualToView(_shopName)
//    .widthRatioToView(_shopName,1)
//    .heightIs(20);
    
     _balanceLable.sd_layout
    .topSpaceToView(contentView,hua_scale(25))
    .leftSpaceToView(_threadView,hua_scale(8))
    .rightSpaceToView(contentView,hua_scale(0))
    .heightIs(hua_scale(14));


    _pageLable.sd_layout
    .topSpaceToView(_balanceLable,hua_scale(6))
    .leftSpaceToView(_threadView,hua_scale(8))
    .heightIs(hua_scale(10))
    .widthIs(hua_scale(50));
    
    separateLine.sd_layout
    .topSpaceToView(_iconImageView, hua_scale(15))
    .leftSpaceToView(contentView, hua_scale(10))
    .rightSpaceToView(contentView, hua_scale(10))
    .heightIs(0.5);
    
    [self setupAutoHeightWithBottomView:separateLine bottomMargin:0];
    

}
- (void)setArray:(NSArray *)array{

    _array = array;
    
    _iconImageView.image = [UIImage imageNamed:@"jjj"];

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
