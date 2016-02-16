//
//  HUAMyInformationTableViewCell.m
//  Flower
//
//  Created by apple on 16/1/12.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAMyInformationTableViewCell.h"
#import "HUAMyInformationViewController.h"
@interface HUAMyInformationTableViewCell ()

@property(nonatomic,strong)UIView *thView;

//键盘
@property (nonatomic,strong)UITextField *textField;
@property (nonatomic, strong)UIView *keyboard;
@end
@implementation HUAMyInformationTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self setCell];
    }
    return self;
}
- (void)setCell{

    _thView = [UIView new];
    _thView.backgroundColor = HUAColor(0xf8f8f8);
    [self.contentView addSubview:_thView];
    
    [_thView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(hua_scale(1));
        make.left.mas_equalTo(hua_scale(15));
        make.right.mas_equalTo(hua_scale(-15));
    }];
    

    _headImage = [UIImageView new];
    _headImage.hidden = YES;
    _headImage.userInteractionEnabled = YES;
    _headImage.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_headImage];
    [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(hua_scale(-7.5));
        make.top.mas_equalTo(hua_scale(7.5));
        make.right.mas_equalTo(hua_scale(-15));
        make.width.mas_equalTo(hua_scale(45));
    }];
    
    _InformationLabel = [UILabel new];
    //_InformationLabel.backgroundColor = [UIColor redColor];
    _InformationLabel.numberOfLines = 1;
    _InformationLabel.font = [UIFont systemFontOfSize:hua_scale(12)];
    [_InformationLabel sizeToFit];
    [self.contentView addSubview:_InformationLabel];
    [_InformationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(hua_scale(-15));
        make.centerY.mas_equalTo(0);
    }];
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
