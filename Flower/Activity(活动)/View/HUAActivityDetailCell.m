//
//  HUAActivityDetailCell.m
//  Flower
//
//  Created by 程召华 on 16/1/8.
//  Copyright © 2016年 readchen.com. All rights reserved.
//
#define margin 10
#import "HUAActivityDetailCell.h"

@implementation HUAActivityDetailCell

- (void)setTextAndImg:(HUADetailInfo *)textAndImg {
    _textAndImg = textAndImg;
    
    self.detailLabel.frame = CGRectMake(hua_scale(margin), 0, screenWidth - 2 * hua_scale(margin), self.detailLabel.height);
 
    self.detailLabel.text = textAndImg.text;
    self.detailLabel.numberOfLines = 0;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.detailLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:margin];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.detailLabel.text length])];
    self.detailLabel.attributedText = attributedString;
    [self.detailImageView sd_setImageWithURL:[NSURL URLWithString:textAndImg.pic] placeholderImage:nil];
    [self.detailLabel sizeToFit];
    if (self.detailLabel.text.length < 23) {
        self.detailImageView.frame = CGRectMake(hua_scale(margin), self.detailLabel.height, screenWidth - 2 * hua_scale(margin), hua_scale(115));
        
    }else {
        self.detailImageView.frame = CGRectMake(hua_scale(margin), self.detailLabel.height+margin, screenWidth - 2 * hua_scale(margin), hua_scale(115));

    }
        self.cellHeight = self.detailImageView.height + self.detailLabel.height+margin;

}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setCell];
    }
    return self;
}

- (void)setCell {
    
    self.detailLabel = [UILabel labelWithFrame:CGRectZero text:@"这只是个测试范德萨发生的范德萨发斯蒂芬斯蒂芬斯蒂芬斯蒂芬是对方是否收到松岛枫松岛枫松岛枫松岛枫松岛枫松岛枫松岛枫松岛枫松岛枫松岛枫松岛枫是" color:HUAColor(0x666666) font:hua_scale(11)];
    self.detailLabel.numberOfLines = 0;
    [self addSubview:self.detailLabel];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.detailLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.detailLabel.text length])];
    self.detailLabel.attributedText = attributedString;
    
    self.detailImageView = [[UIImageView alloc]init];
    self.detailImageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loading_picture"]];
    [self addSubview:self.detailImageView];
//    NSArray *views = @[self.detailLabel, self.detailImageView];
//    [views enumerateObjectsUsingBlock:^(UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [self.contentView addSubview:obj];
//    }];
//    UIView *contentView = self.contentView;
//    CGFloat margin = 10;
//    
//    self.detailLabel.sd_layout
//    .leftSpaceToView(contentView, hua_scale(margin))
//    .topSpaceToView(contentView, hua_scale(0))
//    .rightSpaceToView(contentView, hua_scale(margin))
//    .autoHeightRatio(0);
//    
////    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
////        
////        make.left.mas_equalTo(contentView.mas_left).mas_equalTo(10);
////        make.top.mas_equalTo(0);
////        make.right.mas_equalTo(hua_scale(-10));
////    }];
////    [self.detailTextLabel updateLayout];
//    
//    self.detailImageView.sd_layout
//    .leftSpaceToView(contentView, hua_scale(margin))
//    .topSpaceToView(self.detailLabel, hua_scale(10))
//    .rightSpaceToView(contentView, hua_scale(margin))
//    .heightIs(hua_scale(115));
//    
//    [self setupAutoHeightWithBottomView:_detailImageView bottomMargin:hua_scale(10)];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
