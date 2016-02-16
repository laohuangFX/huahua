//
//  HUATechnicianTableViewCell.m
//  Flower
//
//  Created by apple on 16/1/16.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUATechnicianTableViewCell.h"

@interface HUATechnicianTableViewCell ()
@property(nonatomic,strong)UIImageView *headImageView;

@property (nonatomic, strong)UILabel *typelable;
@property (nonatomic, strong)UILabel *moneyLable;

@end
@implementation HUATechnicianTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setCell];
    }
    return self;

}
- (void)setCell{

    //头像
    _headImageView = [UIImageView new];
    _headImageView.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:_headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hua_scale(5));
        make.bottom.mas_equalTo(hua_scale(-5));
        make.left.mas_equalTo(hua_scale(10));
        make.width.mas_equalTo(hua_scale(70));
    }];
    
    //名字
    _nameLbale = [UILabel new];
    _nameLbale.text = @"张三";
    _nameLbale.font = [UIFont systemFontOfSize:hua_scale(14)];
    [self.contentView addSubview:_nameLbale];
    [_nameLbale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headImageView.mas_top).mas_equalTo(hua_scale(15));
        make.left.mas_equalTo(_headImageView.mas_right).mas_equalTo(hua_scale(15));
    }];
    [_nameLbale setSingleLineAutoResizeWithMaxWidth:200];
    
    //种类
    _typelable = [UILabel new];
    _typelable.text = @"高级技师";
    _typelable.textColor = HUAColor(0x999999);
    _typelable.font = [UIFont systemFontOfSize:hua_scale(11)];
    [self.contentView addSubview:_typelable];
    [_typelable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_nameLbale);
        make.left.mas_equalTo(_nameLbale.mas_right).mas_equalTo(hua_scale(5));
    }];
    [_typelable setSingleLineAutoResizeWithMaxWidth:200];
    
    
    //金钱
    _moneyLable = [UILabel new];
    _moneyLable.text = @"¥456";
    _moneyLable.textColor = HUAColor(0x4da800);
    _moneyLable.font = [UIFont systemFontOfSize:hua_scale(13)];
    [self.contentView addSubview:_moneyLable];
    [_moneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLbale.mas_bottom).mas_equalTo(hua_scale(12));
        make.left.mas_equalTo(_nameLbale);
    }];
    [_moneyLable setSingleLineAutoResizeWithMaxWidth:200];
    
    //选择按钮
    _seletebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_seletebutton setBackgroundImage:[UIImage imageNamed:@"do_not_select"] forState:0];
    [_seletebutton setBackgroundImage:[UIImage imageNamed:@"chooseButton_yes"] forState:UIControlStateSelected];
    [_seletebutton addTarget:self action:@selector(pageAdd:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_seletebutton];
    [_seletebutton mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.right.mas_equalTo(hua_scale(-10));
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(hua_scale(20));
        make.width.mas_equalTo(hua_scale(20));
    }];

}
- (void)setModel:(HUATechnicianModel *)model{
    _model = model;
    
    _nameLbale.text = model.name;
    _moneyLable.text = [NSString stringWithFormat:@"¥ %@",model.price];
    _typelable.text = model.level_name;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"placeholder"]];
}

//选择技师
UIButton *_button = nil;
- (void)pageAdd:(UIButton *)sender{

    if (sender!=_button) {
        sender.selected = YES;
      _button.selected = NO;
    }else{
        sender.selected = YES;
    }
    

    if (self.buttonBlock!=nil) {

        self.buttonBlock(sender);
    }
    
    _button = sender;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    // Configure the view for the selected state
}

@end
