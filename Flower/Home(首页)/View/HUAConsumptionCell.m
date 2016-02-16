//
//  HUAConsumptionCell.m
//  Flower
//
//  Created by 程召华 on 16/1/27.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAConsumptionCell.h"

@interface HUAConsumptionCell ()

@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *priceLabel;
@end



@implementation HUAConsumptionCell

- (void)setConsumption:(HUAConsumption *)consumption {
    _consumption = consumption;
    long date = [consumption.create_time longLongValue];
    self.dateLabel.text = [HUATranslateTime translateTimeIntoCurrurent:date];
    self.nameLabel.text = consumption.first_name;
    self.priceLabel.text = consumption.money;
    
    
    HUALog(@"%@,,%@,,,%@",consumption.create_time,consumption.first_name,consumption.money);
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setCell];
    }
    return self;
}

- (void)setCell {
    CGRect dateFrame = CGRectMake(hua_scale(15), hua_scale(17.5), hua_scale(60), hua_scale(10));
    self.dateLabel = [UILabel labelWithFrame:dateFrame text:@"2015-12-14" color:HUAColor(0x999999) font:hua_scale(10)];
    [self addSubview:self.dateLabel];
    
    CGRect nameFrame = CGRectMake(hua_scale(97), hua_scale(17), hua_scale(160), hua_scale(11));
    self.nameLabel = [UILabel labelWithFrame:nameFrame text:@"这是一个商店名称哈哈哈" color:HUAColor(0x666666) font:hua_scale(11)];
    [self addSubview:self.nameLabel];
    
    CGRect priceFrame = CGRectMake(hua_scale(260), hua_scale(17.5), hua_scale(60), hua_scale(10));
    self.priceLabel = [UILabel labelWithFrame:priceFrame text:@"¥ 56" color:HUAColor(0x4da800) font:hua_scale(10)];
    [self addSubview:self.priceLabel];
    
    UIView *separateLine = [[UIView alloc] initWithFrame:CGRectMake(hua_scale(10), hua_scale(44.5), SCREEN_WIDTH-hua_scale(20), hua_scale(0.5))];
    separateLine.backgroundColor = HUAColor(0xebebeb);
    [self addSubview:separateLine];
}











- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
