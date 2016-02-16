//
//  HUAMakeAnAppointmentTableViewCell.m
//  Flower
//
//  Created by apple on 16/1/18.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAMakeAnAppointmentTableViewCell.h"

@interface HUAMakeAnAppointmentTableViewCell (){

    //早班
    UIButton *_earlyButton;
    //中班
    UIButton *_studentButton;
    //晚班
    UIButton *_nightButton;
}
@end

@implementation HUAMakeAnAppointmentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setCell];
        

    }
    return self;
}
- (void)setCell{

    UIView *contentView = self.contentView;
    
//    UIView *TopThView = [UIView new];
//    TopThView.backgroundColor = [UIColor redColor];
//    [self.contentView addSubview:TopThView];
//    [TopThView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.mas_equalTo(0);
//        make.height.mas_equalTo(hua_scale(1));
//    }];
//
//    
//
//    UIView *thView = [UIView new];
//    thView.backgroundColor = [UIColor redColor];
//    [self.contentView addSubview:thView];
//    [thView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.left.bottom.mas_equalTo(0);
//        make.height.mas_equalTo(hua_scale(1));
//    }];
    
    //线1
    _thView1 = [UIView new];
    _thView1.hidden = YES;
    _thView1.backgroundColor = HUAColor(0xe1e1e1);
    [self.contentView addSubview:_thView1];
    [_thView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(hua_scale(1));
        make.left.top.mas_equalTo(0);
        make.height.mas_equalTo(hua_scale(contentView.height));
    }];
    
    //日期
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.font = [UIFont systemFontOfSize:hua_scale(14)];
    [self.contentView addSubview:_dateLabel];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(hua_scale(5));
    }];
    [_dateLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    
    //线2
    _thView2 = [UIView new];
        _thView2.hidden = YES;
    _thView2.backgroundColor = HUAColor(0xe1e1e1);
    [self.contentView addSubview:_thView2];
    [_thView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(hua_scale(1));
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(hua_scale(67));
        make.height.mas_equalTo(hua_scale(contentView.height));
    }];

    //周几
    _weekLabel = [[UILabel alloc] init];
    _weekLabel.textColor = HUAColor(0x4da800);
    _weekLabel.font = [UIFont systemFontOfSize:hua_scale(14)];
    [self.contentView addSubview:_weekLabel];
    [_weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(_thView2.mas_right).mas_equalTo(hua_scale(hua_scale(-5)));
    }];
    [_weekLabel setSingleLineAutoResizeWithMaxWidth:200];
    

    
    //线3
    _thView3 = [UIView new];
        _thView3.hidden = YES;
    _thView3.backgroundColor = HUAColor(0xe1e1e1);
    [self.contentView addSubview:_thView3];
    [_thView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(hua_scale(1));
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(_thView2.mas_right).mas_equalTo(hua_scale(78));
        make.height.mas_equalTo(hua_scale(contentView.height));
    }];

    //线4
    _thView4= [UIView new];
        _thView4.hidden = YES;
    _thView4.backgroundColor = HUAColor(0xe1e1e1);
    [self.contentView addSubview:_thView4];
    [_thView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(hua_scale(1));
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(_thView3.mas_right).mas_equalTo(hua_scale(78));
        make.height.mas_equalTo(hua_scale(contentView.height));
    }];

    //线5
    _thView5 = [UIView new];
        _thView5.hidden = YES;
    _thView5.backgroundColor = HUAColor(0xe1e1e1);
    [self.contentView addSubview:_thView5];
    [_thView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(hua_scale(1));
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(hua_scale(contentView.height));
    }];
    
    //早班
    _earlyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _earlyButton.hidden = YES;
    _earlyButton.backgroundColor = HUAColor(0x4da800);
    _earlyButton.clipsToBounds = YES;
    _earlyButton.layer.borderWidth =1;
    _earlyButton.tag = 188;
    _earlyButton.layer.borderColor = HUAColor(0x4da800).CGColor;//设置边框颜色
    _earlyButton.layer.cornerRadius =3.f;
    [_earlyButton setTitleColor:HUAColor(0xffffff) forState:0];
    _earlyButton.titleLabel.font = [UIFont systemFontOfSize:hua_scale(12)];
    [_earlyButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_earlyButton];
    [_earlyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(hua_scale(25));
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(_thView2.mas_right).mas_equalTo(hua_scale(7));
        make.right.mas_equalTo(_thView3.mas_left).mas_equalTo(hua_scale(-7));
       
     
    }];
    
    //中班
    _studentButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _studentButton.hidden = YES;
    _studentButton.backgroundColor = HUAColor(0x4da800);
    _studentButton.clipsToBounds = YES;
    _studentButton.layer.borderWidth =1;
    _studentButton.tag = 189;
    _studentButton.layer.borderColor = HUAColor(0x4da800).CGColor;//设置边框颜色
    _studentButton.layer.cornerRadius =3.f;
    [_studentButton setTitleColor:HUAColor(0xffffff) forState:0];
    _studentButton.titleLabel.font = [UIFont systemFontOfSize:hua_scale(12)];
    [_studentButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_studentButton];
    [_studentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(hua_scale(25));
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(_thView3.mas_right).mas_equalTo(hua_scale(7));
        make.right.mas_equalTo(_thView4.mas_left).mas_equalTo(hua_scale(-7));
    }];

    //晚班
    _nightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _nightButton.hidden = YES;
    _nightButton.tag = 190;
    _nightButton.backgroundColor = HUAColor(0x4da800);
    _nightButton.clipsToBounds = YES;
    _nightButton.layer.borderWidth =1;
    _nightButton.layer.borderColor = HUAColor(0x4da800).CGColor;//设置边框颜色
    _nightButton.layer.cornerRadius =3.f;
    [_nightButton setTitleColor:HUAColor(0xffffff) forState:0];
    _nightButton.titleLabel.font = [UIFont systemFontOfSize:hua_scale(12)];
    [_nightButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_nightButton];
    [_nightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(hua_scale(25));
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(_thView4.mas_right).mas_equalTo(hua_scale(7));
        make.right.mas_equalTo(_thView5.mas_left).mas_equalTo(hua_scale(-7));
    }];

    
   
}
- (void)setDateDic:(NSDictionary *)dateDic{

    _dateDic = dateDic ;
    
    _dateLabel.text = dateDic[@"date"];
    _weekLabel.text = dateDic[@"week"];
   // NSLog(@"%@",dateDic[@"dic"]);

}

//- (void)setTypeDic:(NSDictionary *)typeDic{
//    _typeDic = typeDic;
//
//    UIButton *button1 = [self.contentView viewWithTag:188];
//    UIButton *button2 = [self.contentView viewWithTag:189];
//    UIButton *button3 = [self.contentView viewWithTag:190];
//    NSArray *array = typeDic[@"array"];
//    if (typeDic!=nil) {
//        if ([typeDic[@"type"] isEqualToString:@"早班"]) {
//            button1.hidden = NO;
//            button2.hidden = NO;
//            
//            [button1 setTitle:[NSString stringWithFormat:@"剩 %ld",array.count] forState:0];
//            button2.backgroundColor = HUAColor(0xdddddd);
//            [button2 setTitle:@"约满" forState:0];
//        }
//    }
//}

- (void)setRange_list:(NSArray *)range_list{
    _range_list = range_list;
    
    
    for (NSDictionary *dic in range_list) {
        if ([dic[@"type_name"] isEqualToString:@"早班"]) {
            _earlyButton.hidden = NO;
            if (dic[@"order_num"]==0) {
                [_earlyButton setTitle:@"约满" forState:0];
                _earlyButton.backgroundColor = HUAColor(0xdddddd);
                 _earlyButton.layer.borderColor = HUAColor(0xdddddd).CGColor;
            }else{
             [_earlyButton setTitle:[NSString stringWithFormat:@"剩%@",dic[@"order_num"]] forState:0];
            }
        }else if ([dic[@"type_name"] isEqualToString:@"中班"]) {
            _studentButton.hidden = NO;
            if (dic[@"order_num"]==0) {
                [_studentButton setTitle:@"约满" forState:0];
                _studentButton.backgroundColor = HUAColor(0xdddddd);
                 _studentButton.layer.borderColor = HUAColor(0xdddddd).CGColor;
            }else{
                [_studentButton setTitle:[NSString stringWithFormat:@"剩%@",dic[@"order_num"]] forState:0];
            }
        }else{
            _nightButton.hidden = NO;
            if (dic[@"order_num"]==0) {
                [_nightButton setTitle:@"约满" forState:0];
                _nightButton.backgroundColor = HUAColor(0xdddddd);
                _nightButton.layer.borderColor = HUAColor(0xdddddd).CGColor;//设置边框颜色
            }else{
                [_nightButton setTitle:[NSString stringWithFormat:@"剩%@",dic[@"order_num"]] forState:0];
        }
    }
}
//
//    if (typeDic!=nil) {
//        if ([typeDic[@"type"] isEqualToString:@"早班"]) {
//            button1.hidden = NO;
//            button2.hidden = NO;
//            
//            [button1 setTitle:[NSString stringWithFormat:@"剩 %ld",array.count] forState:0];
//            button2.backgroundColor = HUAColor(0xdddddd);
//            [button2 setTitle:@"约满" forState:0];
//        }
//    }

}
- (void)click:(UIButton *)sender{
    //班次
    NSString *range_type_id = [[NSString alloc] init];
    if (self.buttonBlock!=nil) {
        if (sender.tag==188) {
            range_type_id = @"1";
        }else if(sender.tag==189) {
            range_type_id = @"2";
        }else{
        range_type_id = @"3";
        }
        self.buttonBlock(sender,range_type_id);
    }
    NSLog(@"%@",range_type_id);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
