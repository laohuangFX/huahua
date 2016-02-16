//
//  HUAChooseMasterCell.m
//  Flower
//
//  Created by 程召华 on 16/1/17.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAChooseMasterCell.h"

@interface HUAChooseMasterCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *chooseButton;

@end



@implementation HUAChooseMasterCell

- (void)setMaster:(HUAChooseMaster *)master {
    _master = master;
    self.nameLabel.text = master.name;
    self.priceLabel.text = master.price;
}



- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setCell];
    }
    return self;
}

- (void)setCell {
    self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(hua_scale(10), hua_scale(5), hua_scale(70), hua_scale(70))];
    self.headImageView.image = [UIImage imageNamed:@"placeholder"];
    [self addSubview:self.headImageView];
    
    CGRect nameFrame = CGRectMake(hua_scale(95), hua_scale(23), hua_scale(30), 0);
    self.nameLabel = [UILabel labelWithFrame:nameFrame text:@"张三" color:HUAColor(0x333333) font:hua_scale(14)];
    [self addSubview:self.nameLabel];
    [self.nameLabel sizeToFit];
    
    CGRect typeFrame = CGRectMake(hua_scale(101)+self.nameLabel.width, hua_scale(23), hua_scale(50), 0);
    self.typeLabel = [UILabel labelWithFrame:typeFrame text:@"高级技师" color:HUAColor(0x999999) font:hua_scale(11)];
    [self addSubview:self.typeLabel];
    [self.typeLabel sizeToFit];
    
    CGRect priceFrame = CGRectMake(hua_scale(95), hua_scale(49), hua_scale(100), hua_scale(13));
    self.priceLabel = [UILabel labelWithFrame:priceFrame text:@"¥456" color:HUAColor(0x4da800) font:hua_scale(13)];
    [self addSubview:self.priceLabel];
    
    self.chooseButton = [UIButton buttonWithType:0];
    self.chooseButton.frame = CGRectMake(screenWidth-hua_scale(25), hua_scale(32.5), hua_scale(15), hua_scale(15));
    [self.chooseButton setImage:[UIImage imageNamed:@"chooseButton_no"] forState:UIControlStateNormal];
    [self.chooseButton setImage:[UIImage imageNamed:@"chooseButton_yes"] forState:UIControlStateSelected];
    self.chooseButton.layer.masksToBounds = YES;
    self.chooseButton.layer.cornerRadius = hua_scale(7.5);
    self.chooseButton.layer.borderWidth = hua_scale(1);
    self.chooseButton.layer.borderColor = HUAColor(0xd8d8d8).CGColor;
    [self.chooseButton addTarget:self action:@selector(chooseMaster:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.chooseButton];
    

}



- (void)chooseMaster:(UIButton *)sender {
    HUALog(@"选择了技师");
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
