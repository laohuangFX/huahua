//
//  HUATopInfoView.m
//  Flower
//
//  Created by 程召华 on 16/1/15.
//  Copyright © 2016年 readchen.com. All rights reserved.
//
#define Is_vip             @"user/is_vip"
#import "HUATopInfoView.h"

@interface HUATopInfoView ()
@property (nonatomic, strong) UIButton *purchaseButton;
@property (nonatomic, strong) UILabel *goodsInfoLabel;
@property (nonatomic, strong) UILabel *brand;
@property (nonatomic, strong) UILabel *origin;
@property (nonatomic, strong) UILabel *effect;
@property (nonatomic, strong) UILabel *guaranteeTime;
@property (nonatomic, strong) UILabel *skin;
@property (nonatomic, strong) UILabel *specialNote;
@property (nonatomic, strong) UILabel *specificationModel;
@property (nonatomic, strong) UILabel *instructionLabel;
@property (nonatomic, strong) id is_Vip;

@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, weak) UIView *topSeparateLine;
@end

@implementation HUATopInfoView

- (void)setDetailInfo:(HUAProductDetailInfo *)detailInfo {
    _detailInfo = detailInfo;
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:detailInfo.cover] placeholderImage:nil];
    self.goodsImageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loading_picture_middle"]];
    self.goodsNameLabel.text = detailInfo.name;
    self.specificationsLabel.text = [NSString stringWithFormat:@"规格:%@",detailInfo.size];
    //非会员价格
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@（ 会员价¥ %@ ）",detailInfo.price,detailInfo.vip_price];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.priceLabel.text];
    [str addAttribute:NSForegroundColorAttributeName value:HUAColor(0x4da800) range:NSMakeRange(0 ,[detailInfo.price length]+2)];
    [str addAttribute:NSForegroundColorAttributeName value:HUAColor(0x4da800) range:NSMakeRange([detailInfo.price length]+2,self.priceLabel.text.length - ([detailInfo.price length]+2))];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:hua_scale(19)] range:NSMakeRange(0, [detailInfo.price length]+2)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:hua_scale(11)] range:NSMakeRange([detailInfo.price length]+2,self.priceLabel.text.length - ([detailInfo.price length]+2))];
    
    self.priceLabel.attributedText = str;
}

- (void)setInfomation:(NSDictionary *)infomation {
    _infomation = infomation;
    NSArray *informationArray = [infomation allKeys];
    for (int i = 0; i < informationArray.count; i++) {
        NSString *keyString = informationArray[i];
        NSString *valueString = infomation[keyString];
        
        self.keyLabel = [UILabel labelText:[NSString stringWithFormat:@"%@ :",keyString] color:HUAColor(0x999999) font:hua_scale(11)];
        self.keyLabel.frame = CGRectMake(hua_scale(10), hua_scale(402)+hua_scale(21)*i, hua_scale(100), hua_scale(11));
        [self addSubview:self.keyLabel];
        self.valueLabel = [UILabel labelText:valueString color:HUAColor(0x4da800) font:hua_scale(11)];
        self.valueLabel.frame = CGRectMake(hua_scale(137), hua_scale(402)+hua_scale(21)*i, hua_scale(100), hua_scale(11));
        [self addSubview:self.valueLabel];
    }
}
//    CGRect brandFrame = CGRectMake(hua_scale(10), hua_scale(402), hua_scale(100), hua_scale(11));
//    self.brand = [UILabel labelWithFrame:brandFrame text:@"品牌 :" color:HUAColor(0x999999) font:hua_scale(11)];
//    [self addSubview:self.brand];
//
//    CGRect originFrame = CGRectMake(hua_scale(10), hua_scale(423), hua_scale(100), hua_scale(11));
//    self.origin = [UILabel labelWithFrame:originFrame text:@"产地 :" color:HUAColor(0x999999) font:hua_scale(11)];
//    [self addSubview:self.origin];
//
//    CGRect effectFrame = CGRectMake(hua_scale(10), hua_scale(444), hua_scale(100), hua_scale(11));
//    self.effect = [UILabel labelWithFrame:effectFrame text:@"功效 :" color:HUAColor(0x999999) font:hua_scale(11)];
//    [self addSubview:self.effect];

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    self.topSeparateLine.frame =  CGRectMake(hua_scale(10), CGRectGetMaxY(self.valueLabel.frame)+hua_scale(25), screenWidth-hua_scale(20), 0.5);
//    self.instructionLabel.frame = CGRectMake(hua_scale(10), CGRectGetMaxY(self.valueLabel.frame)+hua_scale(50), hua_scale(100), hua_scale(13));
//    _topHeightBlock(CGRectGetMaxY(self.instructionLabel.frame)+hua_scale(15));
//}



- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setHeaderView];
    }
    return self;
}

- (void)setHeaderView {
    self.goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(hua_scale(65), hua_scale(10), hua_scale(190), hua_scale(190))];
    [self addSubview:self.goodsImageView];
    
    CGRect goodsNameFrame = CGRectMake(hua_scale(10), hua_scale(210), hua_scale(300), hua_scale(13));
    self.goodsNameLabel = [UILabel labelWithFrame:goodsNameFrame text:@"曼秀雷敦水彩润唇膏3g 粉红主义唇彩保湿修护锁" color:HUAColor(0x000000) font:hua_scale(13)];
    [self addSubview:self.goodsNameLabel];
    
    CGRect specificationsFrame = CGRectMake(hua_scale(10), hua_scale(235), hua_scale(300), hua_scale(10));
    self.specificationsLabel = [UILabel labelWithFrame:specificationsFrame text:@"规格：700mm x 700mm" color:HUAColor(0x999999) font:hua_scale(10)];
    [self addSubview:self.specificationsLabel];
    
    CGRect priceFrame = CGRectMake(hua_scale(10), hua_scale(257), hua_scale(300), hua_scale(18));
    self.priceLabel = [UILabel labelWithFrame:priceFrame text:@"¥ 349" color:HUAColor(0x4da800) font:hua_scale(19)];
    [self addSubview:self.priceLabel];
    
    CGRect purchaseFrame = CGRectMake(hua_scale(20), hua_scale(293), hua_scale(280), hua_scale(53));
    self.purchaseButton = [UIButton buttonWithFrame:purchaseFrame title:@"购买" image:@"appointment" font:hua_scale(15) titleColor:HUAColor(0xffffff)];
    self.purchaseButton.backgroundColor = HUAColor(0x4da000);
    [self.purchaseButton addTarget:self action:@selector(purchase:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.purchaseButton];
    
    CGRect goodsInfoFrame = CGRectMake(hua_scale(10), hua_scale(377), hua_scale(100), hua_scale(13));
    self.goodsInfoLabel = [UILabel labelWithFrame:goodsInfoFrame text:@"商品信息" color:HUAColor(0x000000) font:hua_scale(13)];
    [self addSubview:self.goodsInfoLabel];
    
//    CGRect brandFrame = CGRectMake(hua_scale(10), hua_scale(402), hua_scale(100), hua_scale(11));
//    self.brand = [UILabel labelWithFrame:brandFrame text:@"品牌 :" color:HUAColor(0x999999) font:hua_scale(11)];
//    [self addSubview:self.brand];
//    
//    CGRect originFrame = CGRectMake(hua_scale(10), hua_scale(423), hua_scale(100), hua_scale(11));
//    self.origin = [UILabel labelWithFrame:originFrame text:@"产地 :" color:HUAColor(0x999999) font:hua_scale(11)];
//    [self addSubview:self.origin];
//    
//    CGRect effectFrame = CGRectMake(hua_scale(10), hua_scale(444), hua_scale(100), hua_scale(11));
//    self.effect = [UILabel labelWithFrame:effectFrame text:@"功效 :" color:HUAColor(0x999999) font:hua_scale(11)];
//    [self addSubview:self.effect];
//    
//    CGRect guaranteeTimeFrame = CGRectMake(hua_scale(10), hua_scale(465), hua_scale(100), hua_scale(11));
//    self.guaranteeTime = [UILabel labelWithFrame:guaranteeTimeFrame text:@"保质期 :" color:HUAColor(0x999999) font:hua_scale(11)];
//    [self addSubview:self.guaranteeTime];
//    
//    CGRect skinFrame = CGRectMake(hua_scale(10), hua_scale(486), hua_scale(100), hua_scale(11));
//    self.skin = [UILabel labelWithFrame:skinFrame text:@"适合肤质 :" color:HUAColor(0x999999) font:hua_scale(11)];
//    [self addSubview:self.skin];
//    
//    CGRect specialNoteFrame = CGRectMake(hua_scale(10), hua_scale(507), hua_scale(100), hua_scale(11));
//    self.specialNote = [UILabel labelWithFrame:specialNoteFrame text:@"特别说明 :" color:HUAColor(0x999999) font:hua_scale(11)];
//    [self addSubview:self.specialNote];
//    
//    CGRect specificationModelFrame = CGRectMake(hua_scale(10), hua_scale(528), hua_scale(100), hua_scale(11));
//    self.specificationModel = [UILabel labelWithFrame:specificationModelFrame text:@"规格型号 :" color:HUAColor(0x999999) font:hua_scale(11)];
//    [self addSubview:self.specificationModel];
//    
//    
//    CGRect brandLabelFrame = CGRectMake(hua_scale(137), hua_scale(402), hua_scale(100), hua_scale(11));
//    self.brandLabel = [UILabel labelWithFrame:brandLabelFrame text:@"蓝格子" color:HUAColor(0x4da800) font:hua_scale(11)];
//    [self addSubview:self.brandLabel];
//    
//    CGRect originLabelFrame = CGRectMake(hua_scale(137), hua_scale(423), hua_scale(100), hua_scale(11));
//    self.originLabel = [UILabel labelWithFrame:originLabelFrame text:@"广州" color:HUAColor(0x4da800) font:hua_scale(11)];
//    [self addSubview:self.originLabel];
//    
//    CGRect effectLabelFrame = CGRectMake(hua_scale(137), hua_scale(444), hua_scale(100), hua_scale(11));
//    self.effectLabel = [UILabel labelWithFrame:effectLabelFrame text:@"收纳" color:HUAColor(0x4da800) font:hua_scale(11)];
//    [self addSubview:self.effectLabel];
//    
//    CGRect guaranteeTimeLabelFrame = CGRectMake(hua_scale(137), hua_scale(465), hua_scale(100), hua_scale(11));
//    self.guaranteeTimeLabel = [UILabel labelWithFrame:guaranteeTimeLabelFrame text:@"2018.06.30" color:HUAColor(0x4da800) font:hua_scale(11)];
//    [self addSubview:self.guaranteeTimeLabel];
//    
//    CGRect skinLabelFrame = CGRectMake(hua_scale(137), hua_scale(486), hua_scale(100), hua_scale(11));
//    self.skinLabel = [UILabel labelWithFrame:skinLabelFrame text:@"非过敏性皮肤" color:HUAColor(0x4da800) font:hua_scale(11)];
//    [self addSubview:self.skinLabel];
//    
//    CGRect specialNoteLabelFrame = CGRectMake(hua_scale(137), hua_scale(507), hua_scale(100), hua_scale(11));
//    self.specialNoteLabel = [UILabel labelWithFrame:specialNoteLabelFrame text:@"无" color:HUAColor(0x4da800) font:hua_scale(11)];
//    [self addSubview:self.specialNoteLabel];
//    
//    CGRect specificationModelLabelFrame = CGRectMake(hua_scale(137), hua_scale(528), hua_scale(100), hua_scale(11));
//    self.specificationModelLabel = [UILabel labelWithFrame:specificationModelLabelFrame text:@"#746" color:HUAColor(0x4da800) font:hua_scale(11)];
//    [self addSubview:self.specificationModelLabel];
    
    UIView *topSeparateLine = [[UIView alloc] init];
    self.topSeparateLine = topSeparateLine;
    topSeparateLine.backgroundColor = HUAColor(0xeeeeee);
    [self addSubview:topSeparateLine];
    
   
    self.instructionLabel = [UILabel labelWithFrame:CGRectZero text:@"使用说明" color:HUAColor(0x000000) font:hua_scale(13)];
    [self addSubview:self.instructionLabel];
    
    
    
    
}

- (void)purchase:(UIButton *)sender {
    if (self.pusViewsBlock != nil) {
        
        self.pusViewsBlock();
    }
    
    HUALog(@"购买了");
}



@end
