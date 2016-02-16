//
//  HUAHeadCell.m
//  Flower
//
//  Created by 程召华 on 16/1/7.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAHeadCell.h"

@implementation HUAHeadCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setCell];
    }
    return self;
}


- (void)setCell {
    self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(hua_scale(15), hua_scale(15), hua_scale(45), hua_scale(45))];
    self.headImageView.image = [UIImage imageNamed:@"11"];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = hua_scale(5);
    [self addSubview:self.headImageView];
    
    self.sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(hua_scale(70), hua_scale(46), hua_scale(20), hua_scale(10))];
    self.sexLabel.text = @"男";
    self.sexLabel.textColor = HUAColor(0x999999);
    self.sexLabel.font = [UIFont systemFontOfSize:hua_scale(12)];
    [self addSubview:self.sexLabel];
    [self.sexLabel sizeToFit];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(hua_scale(70), hua_scale(20), hua_scale(100), hua_scale(15))];
    self.nameLabel.text = @"哎呀卧槽!屌爆了";
    self.nameLabel.textColor = HUAColor(0x000000);
    self.nameLabel.font = [UIFont systemFontOfSize:hua_scale(14)];
    [self addSubview:self.nameLabel];
    [self.nameLabel sizeToFit];
    
    
    self.editImageView = [[UIImageView alloc] initWithFrame:CGRectMake(hua_scale(272), hua_scale(31), hua_scale(18), hua_scale(14))];
    self.editImageView.image = [UIImage imageNamed:@"editor"];
    self.editImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:self.editImageView];
    
}





- (void)awakeFromNib {
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
