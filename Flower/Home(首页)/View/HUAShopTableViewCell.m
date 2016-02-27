//
//  HUAShopTableViewCell.m
//  Flower
//
//  Created by 程召华 on 16/1/5.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAShopTableViewCell.h"

@implementation HUAShopTableViewCell

-(void)setShopInfo:(HUAShopInfo *)shopInfo {
    _shopInfo = shopInfo;
    [self.shopImageView sd_setImageWithURL:[NSURL URLWithString:shopInfo.cover] placeholderImage:nil];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:shopInfo.icon] placeholderImage:nil];
    self.locationLabel.text = shopInfo.address;
    self.shopNameLabel.text = shopInfo.shopname;
    self.praiseCountLabel.text = [NSString stringWithFormat:@"%@赞过",shopInfo.praise_count];
    
}



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setCell];
    }
    return self;
}

- (void)setCell {
    self.shopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, hua_scale(125))];
    self.shopImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.shopImageView.layer.masksToBounds = YES;
    self.shopImageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loading_picture_middle"]];
    [self addSubview:self.shopImageView];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, hua_scale(125))];
    imageView.image = [UIImage imageNamed:@"gradual_change"];
    [self.shopImageView addSubview:imageView];
    
    
    UIImageView *shadow = [[UIImageView alloc]initWithFrame:CGRectMake(hua_scale(10), hua_scale(65), hua_scale(66), hua_scale(55))];
    shadow.contentMode = UIViewContentModeScaleAspectFill;
    shadow.image = [UIImage imageNamed:@"shadow"];
    //shadow.backgroundColor = [UIColor redColor];
    [self addSubview:shadow];
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, hua_scale(60), hua_scale(47))];
    self.iconImageView.layer.borderWidth = 1;
    self.iconImageView.layer.borderColor = HUAColor(0xffffff).CGColor;
    [shadow addSubview:self.iconImageView];
    
    self.praiseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(hua_scale(82), hua_scale(98), hua_scale(10), hua_scale(10))];
    self.praiseImageView.image = [UIImage imageNamed:@"praise_white"];
    
    [self addSubview:self.praiseImageView];
    
    CGRect praiseCountFrame = CGRectMake(hua_scale(95), hua_scale(98), hua_scale(200), hua_scale(10));
    self.praiseCountLabel = [UILabel labelWithFrame:praiseCountFrame text:@"1526赞过" color:HUAColor(0xFFFFFF) font:hua_scale(10)];
    [self addSubview:self.praiseCountLabel];
    
    CGRect shopNameFrame = CGRectMake(hua_scale(82), hua_scale(75), hua_scale(200), hua_scale(15));
    self.shopNameLabel = [UILabel labelWithFrame:shopNameFrame text:@"群芳美容体验中心" color:HUAColor(0xFFFFFF) font:hua_scale(15)];
    [self addSubview:self.shopNameLabel];
    
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, hua_scale(125), screenWidth, hua_scale(30))];
    view.backgroundColor = HUAColor(0xFFFFFF);
    [self addSubview:view];
    
    self.locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(hua_scale(10), hua_scale(135), hua_scale(10), hua_scale(10))];
    self.locationImageView.image = [UIImage imageNamed:@"location"];
    self.locationImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:self.locationImageView];
    
    self.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(hua_scale(25), hua_scale(135), screenWidth - hua_scale(75), hua_scale(10))];
    self.locationLabel.text = @"广州市天河区中山大道西御富科贸园B1栋410室";
    self.locationLabel.font = [UIFont systemFontOfSize:hua_scale(10)];
    self.locationLabel.textColor = HUAColor(0x888888);
    [self addSubview:self.locationLabel];
    
    self.distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth-hua_scale(50), hua_scale(136), hua_scale(40), hua_scale(9))];
    self.distanceLabel.text = @"500 m";
    self.distanceLabel.font = [UIFont systemFontOfSize:hua_scale(9)];
    self.distanceLabel.textAlignment = NSTextAlignmentRight;
    self.distanceLabel.textColor = HUAColor(0x888888);
    [self addSubview:self.distanceLabel];
    
    
}






- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
