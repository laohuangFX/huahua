
//
//  HUAMyOrderTableViewCell.m
//  Flower
//
//  Created by apple on 16/1/12.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAMyOrderTableViewCell.h"
#import "HUATranslateTime.h"
@interface HUAMyOrderTableViewCell ()

//图片
@property(nonatomic,strong)UIImageView *iconImageView;
//服务名称
@property (nonatomic, strong)UILabel *serveName;
//商铺名称
@property (nonatomic, strong)UILabel *shopName;
//线
@property (nonatomic, strong)UIView *thView;
//单号
@property (nonatomic, strong)UILabel *numbersLabel;
//时间
@property (nonatomic, strong)UILabel *time;
//金额
@property (nonatomic, strong)UILabel *moneyLabel;
//状态lable
@property (nonatomic, strong)UILabel *stateLabel;
@property (nonatomic, strong)UILabel *state;

//收货button
@property (nonatomic, strong)UIButton *confirmbutton;

@end

@implementation HUAMyOrderTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setCell];
        
    }
    return self;
}

- (void)setCell{

    _iconImageView = [UIImageView new];
    _iconImageView.backgroundColor = [UIColor yellowColor];
   
    _shopName = [UILabel new];
    //_shopName.backgroundColor = [UIColor redColor];
    _shopName.numberOfLines = 1;
    _shopName.lineBreakMode = NSLineBreakByTruncatingTail;
    _shopName.text = @"苑苑美容美发体验中心";
    _shopName.font = [UIFont systemFontOfSize:hua_scale(12)];
    _shopName.textColor = HUAColor(0x4da800);
    
    _thView = [UIView new];
    _thView.backgroundColor = HUAColor(0xf3f3f3);
    
    _serveName = [UILabel new];
    //_serveName.backgroundColor = [UIColor redColor];

    _serveName.textColor = [UIColor blackColor];
    //_serveName.text = @"这个是服务名称这个服务名称";

    _serveName.font = [UIFont systemFontOfSize:hua_scale(12)];
    
    _numbersLabel = [UILabel new];
    //_numbersLabel.backgroundColor = [UIColor redColor];
    _numbersLabel.text = @"单号 : 123267678216431451";
    _numbersLabel.font = [UIFont systemFontOfSize:hua_scale(11)];
    _numbersLabel.numberOfLines = 1;
    
    _time = [UILabel new];
    //_time.backgroundColor = [UIColor redColor];
    _time.text = @"时间 : 2015-12-15 10:30";
    _time.font = [UIFont systemFontOfSize:hua_scale(11)];
    
    
    _stateLabel = [UILabel new];
    //_stateLabel.backgroundColor = [UIColor redColor];
    _stateLabel.text = @"状态 :";
    _stateLabel.font = [UIFont systemFontOfSize:hua_scale(11)];
    //_stateLabel.hidden = YES;
    
    _state = [UILabel new];
    _state.text = @"等待发货";
    _state.textColor = HUAColor(0x4da800);
    _state.font = [UIFont systemFontOfSize:hua_scale(11)];
    //_state.backgroundColor = [UIColor redColor];
    [_state sizeToFit];
     //_state.hidden = YES;
    
    _moneyLabel = [UILabel new];
    //_moneyLabel.backgroundColor = [UIColor redColor];
    _moneyLabel.textColor = HUAColor(0x4da800);
    _moneyLabel.text = @"¥200元";
    _moneyLabel.font = [UIFont systemFontOfSize:hua_scale(11)];
    //[_moneyLabel sizeToFit];
    
    _confirmbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    _confirmbutton.backgroundColor = HUAColor(0x4da800);
    [_confirmbutton setTitle:@"确认收货" forState:0];
    [_confirmbutton setTitleColor:[UIColor whiteColor] forState:0];
    [_confirmbutton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    //先隐藏。
    _confirmbutton.hidden = YES;
    
    //加入父视图
    NSArray *views = @[_iconImageView,_serveName,_thView, _shopName,_numbersLabel,_time,_moneyLabel,_stateLabel,_state,_confirmbutton];
    
    
    
    [views enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contentView addSubview:obj];
    }];
    
    UIView *contentView = self.contentView;
    
    _iconImageView.sd_layout
    .topSpaceToView(contentView,hua_scale(15))
    .leftSpaceToView(contentView,hua_scale(10))
    .heightIs(hua_scale(70))
    .widthIs(hua_scale(70));
    
    _serveName.sd_layout
    .leftSpaceToView(_iconImageView,hua_scale(10))
    .topEqualToView(_iconImageView)
    .autoHeightRatio(0)
    .rightSpaceToView(contentView,hua_scale(20));
    
    _shopName.sd_layout
    .topSpaceToView(_serveName,hua_scale(10))
    .leftEqualToView(_serveName)
    .autoHeightRatio(0);
    [_shopName setSingleLineAutoResizeWithMaxWidth:200];
    
    _thView.sd_layout
    .leftSpaceToView(_iconImageView,hua_scale(10))
    .topSpaceToView(_shopName,hua_scale(8))
    .rightSpaceToView(contentView,hua_scale(10))
    .heightIs(0.5);
    
    _numbersLabel.sd_layout
    .topSpaceToView(_thView,hua_scale(8))
    .leftEqualToView(_serveName)
    .autoHeightRatio(0);
    [_numbersLabel setSingleLineAutoResizeWithMaxWidth:hua_scale(300)];
    
    _time.sd_layout
    .topSpaceToView(_numbersLabel,hua_scale(9))
    .leftEqualToView(_serveName)
    .autoHeightRatio(0);
    [_time setSingleLineAutoResizeWithMaxWidth:200];
    
    _moneyLabel.sd_layout
    .topSpaceToView(_thView,hua_scale(8))
    .autoHeightRatio(0)
    .rightSpaceToView(self.contentView,hua_scale(20));
    [_thView updateLayout];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).mas_equalTo(hua_scale(-20));
    }];
    [_moneyLabel updateLayout];

    
    _stateLabel.sd_layout
    .leftEqualToView(_time)
    .topSpaceToView(_time,hua_scale(9))
    .autoHeightRatio(0);
    [_stateLabel setSingleLineAutoResizeWithMaxWidth:300];
    
    _state.sd_layout
    .leftSpaceToView(_stateLabel,hua_scale(2))
    .topEqualToView(_stateLabel)
    .widthIs(hua_scale(200))
    .autoHeightRatio(0);

    
    _confirmbutton.sd_layout
    .leftEqualToView(_time)
    .topSpaceToView(_time,hua_scale(8))
    .heightIs(hua_scale(28))
    .widthIs(hua_scale(64));
    
    
    [self setupAutoHeightWithBottomViewsArray:@[_state,_confirmbutton] bottomMargin:hua_scale(15)];
}

- (void)setModel:(HUAMyOrderModel *)model{
    _model = model;
    
    _serveName.text = model.titleNmae;
  
    _shopName.text = model.shopName;
    
    _numbersLabel.text = [NSString stringWithFormat:@"单号 :%@",model.bill_num];
    
    _moneyLabel.text = [NSString stringWithFormat:@"¥ %ld元",model.money.integerValue];
    
   
    _time.text = [HUATranslateTime translateTimeIntoCurrurents:model.time.integerValue];
    
 
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    if ([model.type isEqualToString:@"1"]) {
        //产品
        if ([model.is_receipt isEqualToString:@"0"]) {
            _state.text = @"未发货";
        }else if ([model.is_receipt isEqualToString:@"2"]){
             _state.text = @"已完成交易";
             _state.textColor = HUAColor(0x999999);
        }else{
            _confirmbutton.hidden = NO;
            _stateLabel.hidden = YES;
            _state.hidden = YES;
             //_state.text = @"已发货";
        }
    }else if ([model.type isEqualToString:@"2"]){
          _confirmbutton.hidden = YES;
          _stateLabel.hidden = NO;
          _state.hidden = NO;
  
        //服务
        if ([model.is_use isEqualToString:@"0"]){
            _state.text = @"未使用";
            _state.textColor = HUAColor(0x4da800);
        }else if ([model.is_use isEqualToString:@"1"]){
            _state.text = @"已使用";
        }
    }else{
        //活动
        _confirmbutton.hidden = YES;
        _stateLabel.hidden = NO;
        _state.hidden = NO;
        if (model.remainNum.integerValue>0) {
            _state.text = [NSString stringWithFormat:@"剩余 %ld 次",model.remainNum.integerValue];
            _state.textColor = [UIColor grayColor];
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:_state.text];
            
            NSRange range1 = [_state.text rangeOfString:model.remainNum];
            
            [att addAttributes:@{NSForegroundColorAttributeName:HUAColor(0x4ad800)} range:NSMakeRange(range1.location, range1.length)];
            _state.attributedText = att;
        }else{
          _state.text = @"交易已完成";
        }
    }
    
    
    if ([model.type isEqualToString:@"1"]) {
        if ([model.is_receipt isEqualToString:@"1"]) {
            
        [self setupAutoHeightWithBottomView:_confirmbutton bottomMargin:hua_scale(11)];
        }
    }else{
    
        [self setupAutoHeightWithBottomView:_state bottomMargin:hua_scale(15)];

    }
    
    
}
- (void)click:(UIButton *)button{

    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"收货" message:@"确认收货" preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        
        _confirmbutton.hidden = YES;
        _stateLabel.hidden = NO;
        _state.hidden = NO;
        
        _state.text = @"收货成功";
        _state.textColor = HUAColor(0x4da800);
        self.goodsBlock(self.indexPath);

    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [alert removeFromParentViewController];
    }]];
    self.showBlock(alert);
    //[self.contentView presentViewController:alert animated:YES completion:nil];

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
