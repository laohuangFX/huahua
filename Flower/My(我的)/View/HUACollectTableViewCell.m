//
//  HUACollectTableViewCell.m
//  Flower
//
//  Created by apple on 16/1/11.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUACollectTableViewCell.h"

@interface HUACollectTableViewCell ()

//底部视图
@property (nonatomic,strong)UIView *bgView;
//背景
@property (nonatomic,strong)UIImageView *bgImageView;
//图标
@property (nonatomic, strong)UIImageView *iconImageView;
//点赞图片
@property (nonatomic, strong)UIImageView *praiseImageView;
//商店名字
@property (nonatomic, strong)UILabel *nameLbale;

@property (nonatomic, strong)UILabel *praiseLabel;

@property (nonatomic,strong)UIImageView *locationImageView;

@property (nonatomic, strong)UILabel *addressLabel;

//距离
@property (nonatomic, strong)UILabel *distanceLbale;
//会员图标
@property (nonatomic, strong)UIImageView *memberImageView;

@end
@implementation HUACollectTableViewCell

- (void)setMyCollection:(HUAMyCollection *)myCollection {
    _myCollection = myCollection;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:myCollection.cover] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:myCollection.icon] placeholderImage:nil];
    self.addressLabel.text = myCollection.address;
    self.praiseLabel.text = [NSString stringWithFormat:@"%@赞过" ,myCollection.praise_sum];
    self.nameLbale.text = myCollection.shopname;
    if (![myCollection.is_vip isKindOfClass:[NSDictionary class]]) {
        self.memberImageView.hidden = YES;
    }else {
        self.memberImageView.hidden = NO;
    }
    if ([[[[NSNumberFormatter alloc] init] stringFromNumber:myCollection.is_praise] isEqualToString:@"1"]) {
        self.praiseImageView.image = [UIImage imageNamed:@"praise_tech"];
    }else {
        self.praiseImageView.image = [UIImage imageNamed:@"praise_white"];
    }
    
    
}



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setCell];
    }
    
    return self;
}

- (void)setCell{
    
    //背景
    _bgView = [UIView new];
    _bgView.backgroundColor = [UIColor whiteColor];
    
    //背景图片
    _bgImageView = [UIImageView new];
    //_bgImageView.backgroundColor = [UIColor orangeColor];
    _bgImageView.image = [UIImage imageNamed:@"jjj"];
    
    //商店图标
    _iconImageView = [UIImageView new];
    _iconImageView.backgroundColor = [UIColor yellowColor];

    //会员图标
    _memberImageView = [UIImageView new];
    _memberImageView.image = [UIImage imageNamed:@"vip"];
    //_memberImageView.backgroundColor = [UIColor redColor];

    //商店名字
    _nameLbale = [UILabel new];
    //_nameLbale.backgroundColor = [UIColor blackColor];
    _nameLbale.text = @"群芳美容体验中心";
    _nameLbale.textColor = HUAColor(0xffffff);
 
    
    _praiseImageView = [UIImageView new];
    _praiseImageView.image = [UIImage imageNamed:@"praise_white"];
  
    _praiseLabel = [UILabel labelWithFrame:CGRectZero text:@"1526赞过" color:HUAColor(0xffffff) font:hua_scale(10)];

    _locationImageView = [UIImageView new];
    _locationImageView.image = [UIImage imageNamed:@"location"];
    
    _addressLabel = [UILabel labelWithFrame:CGRectZero text:@"广州市天河区中山大道西御富科贸园B1栋410室" color:HUAColor(0x888888) font:hua_scale(10)];
    
    //距离
    _distanceLbale = [UILabel new];
    //_distanceLbale.backgroundColor = [UIColor blackColor];
    _distanceLbale.text = @"500 m";
    _distanceLbale.textAlignment = NSTextAlignmentRight;
    _distanceLbale.font = [UIFont systemFontOfSize:9];
    _distanceLbale.textColor = HUAColor(0x888888);
 
    //加入父视图
    NSArray *views = @[_bgView,_bgImageView, _iconImageView,_nameLbale,_memberImageView,_praiseImageView,_praiseLabel,_locationImageView,_addressLabel,_distanceLbale];
    
    
    
    [views enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contentView addSubview:obj];
    }];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;

    _bgView.sd_layout
    .leftEqualToView(contentView)
    .topEqualToView(contentView)
    .rightEqualToView(contentView)
    .heightIs(hua_scale(155));
    
    _bgImageView.sd_layout
    .topEqualToView(_bgView)
    .leftEqualToView(_bgView)
    .rightEqualToView(_bgView)
    .heightIs(hua_scale(125));

    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView.mas_left).mas_equalTo(hua_scale(10));
        make.bottom.mas_equalTo(_bgImageView.mas_bottom).mas_equalTo(-hua_scale(12));
        make.size.mas_equalTo(CGSizeMake(hua_scale(60), hua_scale(47)));
    }];
    
    [_nameLbale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_iconImageView.mas_top).mas_equalTo(hua_scale(5));
        make.left.mas_equalTo(_iconImageView.mas_right).mas_equalTo(hua_scale(11));
    }];
    _nameLbale.sd_layout
//    .topEqualToView(_iconImageView)
//    .leftSpaceToView(_iconImageView,hua_scale(11))
    .autoHeightRatio(0);
    //.heightIs(hua_scale(30));.
    [_nameLbale setSingleLineAutoResizeWithMaxWidth:200];
    
    
//    _supportButton.sd_layout
//    .topSpaceToView(_nameLbale,0)
//    .leftEqualToView(_nameLbale)
//    .bottomEqualToView(_iconImageView)
//    .widthIs(hua_scale(70));
    
//     _memberImageView.sd_layout
//    .leftSpaceToView(_nameLbale,1)
//    .topSpaceToView(_nameLbale,5)
//    .heightIs(hua_scale(11))
//    .widthIs(hua_scale(22));
[_memberImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    
    make.left.mas_equalTo(_nameLbale.mas_right).mas_equalTo(2);
    make.top.mas_equalTo(_nameLbale.mas_top).mas_equalTo(5);
    make.height.mas_equalTo(hua_scale(11));
    make.width.mas_equalTo(hua_scale(22));
}];
    _praiseImageView.sd_layout
    .leftSpaceToView(_iconImageView,hua_scale(11))
    .topSpaceToView(_nameLbale,hua_scale(10))
    .widthIs(hua_scale(10))
    .heightIs(hua_scale(9));
    
    _praiseLabel.sd_layout
    .leftSpaceToView(_praiseImageView,hua_scale(4))
    .topSpaceToView(_nameLbale,hua_scale(9))
    .widthIs(hua_scale(150))
    .heightIs(hua_scale(10));
    
    _locationImageView.sd_layout
    .leftSpaceToView(contentView,hua_scale(10))
    .topSpaceToView(_bgImageView,hua_scale(10))
    .widthIs(hua_scale(8))
    .heightIs(hua_scale(10));
    
    _addressLabel.sd_layout
    .leftSpaceToView(_locationImageView,hua_scale(4))
    .topSpaceToView(_bgImageView,hua_scale(10))
    .widthIs(hua_scale(250))
    .heightIs(hua_scale(10));
    
    
    _distanceLbale.sd_layout
    .rightSpaceToView(contentView,hua_scale(5))
    .topSpaceToView(_bgImageView,hua_scale(5))
    .heightIs(hua_scale(20))
    .widthIs(hua_scale(50));
   
    [self setupAutoHeightWithBottomView:_distanceLbale bottomMargin:hua_scale(11)];

}

- (void)setArrar:(NSArray *)arrar{

    _bgImageView.image = [UIImage imageNamed:@"jjj"];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
