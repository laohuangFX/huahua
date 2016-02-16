//
//  HUAMasterListCell.m
//  Flower
//
//  Created by 程召华 on 16/1/18.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAMasterListCell.h"

@interface HUAMasterListCell ()
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *praiseLabel;
@property (nonatomic, strong) UIImageView *praiseImageView;
@end


@implementation HUAMasterListCell
- (void)setMasterList:(HUAMasterList *)masterList {
    _masterList = masterList;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:masterList.url] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.nameLabel.text = masterList.name;
    [self.nameLabel sizeToFit];
    self.praiseLabel.text = masterList.praise_count;
    self.typeLabel.text = masterList.level_name;
    self.typeLabel.frame = CGRectMake(hua_scale(101)+self.nameLabel.width, hua_scale(26), hua_scale(50), 0);
    [self.typeLabel sizeToFit];
}




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setCell];
    }
    return self;
}

- (void)setCell {
    self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(hua_scale(10), hua_scale(5), hua_scale(70), hua_scale(70))];
    [self addSubview:self.headImageView];
    
    CGRect nameFrame = CGRectMake(hua_scale(95), hua_scale(23), hua_scale(30), 0);
    self.nameLabel = [UILabel labelWithFrame:nameFrame text:@"张三" color:HUAColor(0x333333) font:hua_scale(14)];
    [self addSubview:self.nameLabel];
    [self.nameLabel sizeToFit];
    
    CGRect typeFrame = CGRectMake(hua_scale(101)+self.nameLabel.width, hua_scale(26), hua_scale(50), 0);
    self.typeLabel = [UILabel labelWithFrame:typeFrame text:@"高级技师" color:HUAColor(0x999999) font:hua_scale(11)];
    [self addSubview:self.typeLabel];
    [self.typeLabel sizeToFit];
    
    self.praiseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(hua_scale(95), hua_scale(48), hua_scale(9), hua_scale(9))];
    self.praiseImageView.image = [UIImage imageNamed:@"praise_select"];
    [self addSubview:self.praiseImageView];
    
    
    CGRect praiseFrame = CGRectMake(hua_scale(108), hua_scale(48), hua_scale(100), hua_scale(9));
    self.praiseLabel = [UILabel labelWithFrame:praiseFrame text:@"156777" color:HUAColor(0x4da800) font:hua_scale(9)];
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
