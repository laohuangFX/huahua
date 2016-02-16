//
//  HUAServiceMasterCell.m
//  Flower
//
//  Created by 程召华 on 16/1/15.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAServiceMasterCell.h"

@interface HUAServiceMasterCell ()

@end

@implementation HUAServiceMasterCell

- (void)setMasterInfo:(HUAServiceMasterInfo *)masterInfo {
    _masterInfo = masterInfo;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:masterInfo.cover] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.nameLabel.text = masterInfo.masterName;
    [self.nameLabel sizeToFit];
    //self.nameLabel.frame = ;
    self.typeLabel.text = masterInfo.masterType;
     [self.typeLabel sizeToFit];
    self.typeLabel.frame = CGRectMake(hua_scale(85)+self.nameLabel.width, hua_scale(10), hua_scale(50), hua_scale(10));
    self.praiseLabel.text = [NSString stringWithFormat:@"%@赞过",masterInfo.praise_count];
    
}




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setCell];
    }
    return self;
}

- (void)setCell {
    self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(hua_scale(10), hua_scale(5), hua_scale(40), hua_scale(40))];
    [self addSubview:self.headImageView];
    
    CGRect nameFrame = CGRectMake(hua_scale(80), hua_scale(8.5), hua_scale(50),     hua_scale(12));
    self.nameLabel = [UILabel labelWithFrame:nameFrame text:@"张三三" color:HUAColor(0x333333) font:hua_scale(12)];
    [self addSubview:self.nameLabel];
    
    
    //CGRect typeFrame = ;
    self.typeLabel = [UILabel labelWithFrame:CGRectZero text:@"高级技师" color:HUAColor(0x999999) font:hua_scale(10)];
    [self addSubview:self.typeLabel];
   
    
    self.praiseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(hua_scale(80), hua_scale(30.5), hua_scale(9), hua_scale(9))];
    self.praiseImageView.image = [UIImage imageNamed:@"productprise"];
    [self addSubview:self.praiseImageView];
    
    
    CGRect praiseFrame = CGRectMake(hua_scale(84)+self.praiseImageView.width, hua_scale(30.5), hua_scale(100), hua_scale(9));
    self.praiseLabel = [UILabel labelWithFrame:praiseFrame text:@"1526赞过" color:HUAColor(0xcdcdcd) font:hua_scale(9)];
    [self addSubview:self.praiseLabel];
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
