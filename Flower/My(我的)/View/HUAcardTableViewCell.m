//
//  HUAcardTableViewCell.m
//  Flower
//
//  Created by apple on 16/2/17.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAcardTableViewCell.h"

@interface HUAcardTableViewCell (){

    UIImageView *_iconImageView;
    
    UILabel *_typeTitle;

    UILabel *_numberLabel;
    
    UILabel *_serveLabel;
    
    UIButton *_selecteBuuton;
}

@end

@implementation HUAcardTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setCell];
    }
    return self;
}

- (void)setCell{

    //头像

    _iconImageView = [UIImageView new];
    //_iconImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hua_scale(10));
        make.left.mas_equalTo(hua_scale(10));
        make.bottom.mas_equalTo(hua_scale(-10));
        make.width.mas_equalTo(hua_scale(60));
    }];
    
    //类型title
    _typeTitle = [UILabel labelText:@"美甲卡" color:HUAColor(0x000000) font: hua_scale(13)];
    [_typeTitle sizeToFit];
    [self.contentView addSubview:_typeTitle];
    [_typeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_iconImageView.mas_right).mas_equalTo(hua_scale(15));
        make.top.mas_equalTo(hua_scale(15));
    }];
    [_typeTitle setSingleLineAutoResizeWithMaxWidth:200];

    
    //产品卡剩余次数
    _numberLabel = [UILabel labelText:@"剩余 : 3 次" color:HUAColor(0x666666) font:10];
    [_numberLabel sizeToFit];
    [self.contentView addSubview:_numberLabel];
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_typeTitle);
        make.top.mas_equalTo(_typeTitle.mas_bottom).mas_equalTo(hua_scale(8));
    }];
    [_numberLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    //服务类型
    _serveLabel = [UILabel labelText:@"服务范围 : 美甲修甲" color:HUAColor(0x666666) font:hua_scale(10)];
    [_serveLabel sizeToFit];
    [self.contentView addSubview:_serveLabel];
    [_serveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_typeTitle);
        make.top.mas_equalTo(_numberLabel.mas_bottom).mas_equalTo(hua_scale(8));
    }];
    [_serveLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    //选择button
    _selecteBuuton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selecteBuuton setBackgroundImage:[UIImage imageNamed:@"do_not_select"] forState:0];
    [_selecteBuuton setBackgroundImage:[UIImage imageNamed:@"chooseButton_yes"] forState:UIControlStateSelected];
    [_selecteBuuton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_selecteBuuton];
    [_selecteBuuton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(hua_scale(15), hua_scale(15)));
        make.right.mas_equalTo(hua_scale(-15));
    }];

}

- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"cover"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];

    [_typeTitle setText:dataDic[@"card_name"]];
    
    _numberLabel.text = [NSString stringWithFormat:@"剩余 : %@次 ",dataDic[@"remain_times"]];

    [HUAConstRowHeight adjustTheLabel:_numberLabel adjustColor:HUAColor(0x4da800) adjustColorRang:NSMakeRange(5, [dataDic[@"remain_times"] length]) adjustFont:15 adjustFontRang:NSMakeRange(5,[dataDic[@"remain_times"] length])];
    ;
 
    _serveLabel.text = [NSString stringWithFormat:@"服务范围 : %@",[dataDic[@"service_scope"] firstObject][@"name"]];
    [HUAConstRowHeight adjustTheLabel:_serveLabel adjustColor:HUAColor(0x4da800) adjustRang:NSMakeRange(7, [[dataDic[@"service_scope"] firstObject][@"name"] length])];
}

UIButton *buttonn = nil;
- (void)click:(UIButton *)sender{
    if (buttonn!=sender) {
        sender.selected = YES;
        buttonn.selected = NO;
    }else{
        sender.selected = YES;
    }
    
    buttonn = sender;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
