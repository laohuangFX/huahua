//
//  HUAMyProductTableViewCell.m
//  Flower
//
//  Created by apple on 16/1/12.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAMyProductTableViewCell.h"

@interface HUAMyProductTableViewCell ()
@property (nonatomic,strong)UIImageView *iconImageView;
//卡的类型
@property (nonatomic, strong)UILabel *typeName;
//次数
@property (nonatomic, strong)UILabel *pageLable;
@property (nonatomic, strong)UILabel *page;
//价格
@property (nonatomic, strong)UILabel *priceLbale;
@property (nonatomic, strong)UILabel *price;
//服务范围
@property (nonatomic, strong)UILabel *serveLbale;
@property (nonatomic, strong)UILabel *serve;
//商店名
@property (nonatomic, strong)UILabel *shopName;
//电话
@property (nonatomic, strong) UIImageView *phoneImageView;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong)UIButton *phoneButton;
//地址
@property (nonatomic, strong) UIImageView *locationImageView;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong)UIButton *addressButton;
//线
@property (nonatomic, strong)UIView *threadView;

@end

@implementation HUAMyProductTableViewCell

- (void)setProductCard:(HUAProductCard *)productCard {
    _productCard = productCard;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:productCard.cover] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.typeName.text = productCard.card_name;
    self.price.text = [NSString stringWithFormat:@"¥%@",productCard.active_price];
    self.shopName.text = productCard.shopname;
    self.phoneLabel.text = productCard.phone;
    self.addressLabel.text = productCard.address;
    self.page.text = productCard.remain_times;
   
    NSString *string = [[NSString alloc] init];
    for (int i = 0; i < productCard.service_scope.count; i++) {
        string = [string stringByAppendingString:[NSString stringWithFormat:@"或%@",productCard.service_scope[i]]];

    }
    string = [string substringWithRange:NSMakeRange(1, string.length-1)];
    self.serve.text = string;
   
    
}




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
    
    _typeName = [UILabel new];
    //_typeName.backgroundColor = [UIColor redColor];
    _typeName.font = [UIFont systemFontOfSize:hua_scale(13)];
    _typeName.text =@"洗头卡";
    
    
    _pageLable = [UILabel new];
    //_pageLable.backgroundColor = [UIColor redColor];
    _pageLable.text =@"次";
    _pageLable.textColor = HUAColor(0x333333);
    _pageLable.font = [UIFont systemFontOfSize:hua_scale(10)];
    
    _page = [UILabel new];
    //_page.backgroundColor = [UIColor yellowColor];
    _page.text =@"5";
    _page.textColor = HUAColor(0x4da800);
    _page.font = [UIFont systemFontOfSize:hua_scale(20)];
    _page.textAlignment = NSTextAlignmentRight;
    
    
    _priceLbale = [UILabel new];
    //_priceLbale.backgroundColor = [UIColor redColor];
    //_priceLbale.backgroundColor = [UIColor redColor];
    _priceLbale.text =@"价格 :";
    _priceLbale.textColor = HUAColor(0x666666);
    _priceLbale.font = [UIFont systemFontOfSize:hua_scale(10)];
    
    _price = [UILabel new];
    //_price.backgroundColor = [UIColor redColor];
    _price.text =@"¥233";
    _price.textColor = HUAColor(0x4da800);
    _price.font = [UIFont systemFontOfSize:hua_scale(11)];

    
    _serveLbale = [UILabel new];
    //_serveLbale.backgroundColor = [UIColor redColor];
    _serveLbale.text =@"服务范围 :";
    _serveLbale.textColor = HUAColor(0x666666);
    _serveLbale.font = [UIFont systemFontOfSize:hua_scale(10)];
    
    _serve = [UILabel new];
    //_serve.text =@"洗头或剪发";
    _serve.textColor = HUAColor(0x4da800);
    _serve.font = [UIFont systemFontOfSize:hua_scale(11)];

    
    
    _threadView = [UIView new];
    _threadView.backgroundColor = HUAColor(0xcdcdcd);
   
    _shopName = [UILabel new];
    //_shopName.backgroundColor = [UIColor redColor];
    _shopName.font = [UIFont systemFontOfSize:hua_scale(11)];
    _shopName.text = @"商店:华乐国际美丽造型";

    _phoneImageView = [UIImageView new];
    _phoneImageView.image = [UIImage imageNamed:@"cell-phone number"];
    
    _phoneLabel = [UILabel labelWithFrame:CGRectZero text:@"020-88886958" color:HUAColor(0x888888) font:hua_scale(11)];
    
//    _phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    //_phoneButton.backgroundColor = [UIColor grayColor];
//    [_phoneButton setTitle:@"020-88886958" forState:0];
//    [_phoneButton setImage:[UIImage imageNamed:@"cell-phone number"] forState:0];
//    _phoneButton.titleLabel.font = [UIFont systemFontOfSize:11];
//    [_phoneButton setTitleColor:HUAColor(0x888888) forState:0];
//    [_phoneButton setImageEdgeInsets:UIEdgeInsetsMake(0, hua_scale(-58), 0, 0)];
//    [_phoneButton setTitleEdgeInsets:UIEdgeInsetsMake(0, hua_scale(-54), 0, 0)];

    _locationImageView = [UIImageView new];
    _locationImageView.image = [UIImage imageNamed:@"location"];
    _locationImageView.contentMode = UIViewContentModeCenter;
    
    _addressLabel = [UILabel labelWithFrame:CGRectZero text:@"广州市天河区中山大道西御富科贸园B1栋410室" color:HUAColor(0x888888) font:hua_scale(11)];
    
//    _addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    //_addressButton.backgroundColor = [UIColor grayColor];
//    [_addressButton setTitle:@"广州市天河区中山大道西御富科贸园B1栋410室" forState:0];
//    [_addressButton setImage:[UIImage imageNamed:@"location"] forState:0];
//    _addressButton.titleLabel.font = [UIFont systemFontOfSize:10];
//    [_addressButton setTitleColor:HUAColor(0x888888) forState:0];
//    [_addressButton setImageEdgeInsets:UIEdgeInsetsMake(0, hua_scale(-13), 0, 0)];
//    [_addressButton setTitleEdgeInsets:UIEdgeInsetsMake(0, hua_scale(-8), 0, 0)];
    UIView *separateLine = [UIView new];
    separateLine.backgroundColor = HUAColor(0xcdcdcd);
    
    //加入父视图
    NSArray *views = @[_iconImageView,_typeName, _pageLable,_page,_priceLbale,_price,_serveLbale,_serve,_threadView,_shopName,_phoneImageView,_phoneLabel,_locationImageView,_addressLabel,separateLine];
    
    
    
    [views enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contentView addSubview:obj];
    }];

    UIView *contentView = self.contentView;
    
    //添加约束
    _iconImageView.sd_layout
    .topSpaceToView(contentView,hua_scale(15))
    .leftSpaceToView(contentView,hua_scale(10))
    .widthIs(hua_scale(60))
    .heightIs(hua_scale(60));
    
    _typeName.sd_layout
    .topSpaceToView(contentView,hua_scale(17))
    .leftSpaceToView(_iconImageView,hua_scale(10))
    .widthIs(hua_scale(100))
    .heightIs(hua_scale(13));

    
    _pageLable.sd_layout
    .topSpaceToView(contentView,hua_scale(24))
    .rightSpaceToView(contentView,hua_scale(10))
    .heightIs(hua_scale(10))
    .widthIs(hua_scale(10));

   
    _page.sd_layout
    .bottomEqualToView(_pageLable)
    .rightSpaceToView(_pageLable,hua_scale(2))
    .heightIs(hua_scale(17))
    .widthIs(hua_scale(100));
    
    _priceLbale.sd_layout
    .topSpaceToView(_typeName,hua_scale(11))
    .leftSpaceToView(_iconImageView,hua_scale(10))
    .heightIs(hua_scale(10))
    .widthIs(hua_scale(30));
    
    
    _price.sd_layout
    .bottomEqualToView(_priceLbale)
    .leftSpaceToView(_priceLbale,hua_scale(0))
    .heightIs(hua_scale(11))
    .widthIs(hua_scale(45));
    
    _serveLbale.sd_layout
    .topSpaceToView(_typeName,hua_scale(11))
    .leftSpaceToView(_iconImageView,hua_scale(95))
    .heightIs(hua_scale(10))
    .widthIs(hua_scale(50));
    
    
    _serve.sd_layout
    .bottomEqualToView(_serveLbale)
    .leftSpaceToView(_serveLbale,hua_scale(0))
    .heightIs(hua_scale(11))
    .widthIs(hua_scale(100));
    
    _threadView.sd_layout
    .topSpaceToView(_priceLbale,hua_scale(10))
    .leftEqualToView(_priceLbale)
    .rightSpaceToView(contentView,hua_scale(10))
    .heightIs(0.5);
    
    _shopName.sd_layout
    .topSpaceToView(_threadView,hua_scale(10))
    .leftEqualToView(_threadView)
    .autoHeightRatio(0);
    [_shopName setSingleLineAutoResizeWithMaxWidth:200];
    
    _phoneImageView.sd_layout
    .topSpaceToView(_shopName,hua_scale(11))
    .leftEqualToView(_threadView)
    .widthIs(hua_scale(10))
    .heightIs(hua_scale(10));
    
    _phoneLabel.sd_layout
    .topSpaceToView(_shopName,hua_scale(11))
    .leftSpaceToView(_phoneImageView,hua_scale(5))
    .widthIs(hua_scale(150))
    .heightIs(hua_scale(10));
    
    _locationImageView.sd_layout
    .topSpaceToView(_phoneImageView,hua_scale(11))
    .leftEqualToView(_threadView)
    .widthIs(hua_scale(10))
    .heightIs(hua_scale(10));
    
    _addressLabel.sd_layout
    .topSpaceToView(_phoneImageView,hua_scale(11))
    .leftSpaceToView(_locationImageView,hua_scale(5))
    .rightSpaceToView(contentView,hua_scale(10))
    .heightIs(hua_scale(10));
    
    separateLine.sd_layout
    .topSpaceToView(_iconImageView,hua_scale(65))
    .leftSpaceToView(contentView,hua_scale(10))
    .rightSpaceToView(contentView,hua_scale(10))
    .heightIs(0.5);
    
//    _phoneButton.sd_layout
//    .topSpaceToView(_shopName,hua_scale(11))
//    .leftEqualToView(_shopName)
//    .widthIs(150)
//    .heightIs(10);
    
//    _addressButton.sd_layout
//    .topSpaceToView(_phoneButton,hua_scale(11))
//    .leftEqualToView(_phoneButton)
//    .rightSpaceToView(contentView,hua_scale(10))
//    .heightIs(10);
    
    [self setupAutoHeightWithBottomView:separateLine bottomMargin:hua_scale(0)];
}

- (void)setArray:(NSArray *)array{
    _array = array;
    
    _iconImageView.image = [UIImage imageNamed:@"jjj"];
    

}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
