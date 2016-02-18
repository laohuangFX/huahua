//
//  HUDynamicATableViewCell.m
//  Flower
//
//  Created by apple on 16/1/8.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUDynamicATableViewCell.h"
#import "HUADynamicDetailsViewController.h"
@implementation HUDynamicATableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    
    
    self.headView = [UIImageView new];
    //self.headView .backgroundColor = [UIColor redColor];
    
    self.nameLbale = [UILabel new];
    self.nameLbale.text = @"快乐鸟";
    //self.nameLbale.backgroundColor = [UIColor blueColor];
    self.nameLbale.font = [UIFont systemFontOfSize:hua_scale(14)];
    self.nameLbale.textColor = HUAColor(0x576b95);
    
    self.contentLbale = [UILabel new];
    self.contentLbale.numberOfLines = 0;
    self.contentLbale.font = [UIFont systemFontOfSize:hua_scale(14)];
    self.contentLbale.textColor = HUAColor(0x333333);
    
    
    
    //图片
    self.picContainerView = [HUAWeiXinPhotoContainerView new];
    
    
    //时间
    self.timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.timeButton setTitleColor:HUAColor(0xcecece) forState:0];
    self.timeButton.titleLabel.font = [UIFont systemFontOfSize:hua_scale(9)];
    [self.timeButton setTitle:@"刚刚" forState:0];
    [self.timeButton setImage:[UIImage imageNamed:@"time"] forState:0];
    [self.timeButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    self.timeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.timeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, hua_scale(4), 0, 0)];
    
    
    //爱好
    self.loveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loveButton.titleLabel.font = [UIFont systemFontOfSize:hua_scale(11)];
    self.loveButton.tag = 501;
    [self.loveButton setTitleColor:[UIColor grayColor] forState:0];
    [self.loveButton setImage:[UIImage imageNamed:@"praise_empty"] forState:UIControlStateNormal];
    [self.loveButton setImage:[UIImage imageNamed:@"praise_green"] forState:UIControlStateSelected];
    self.loveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.loveButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.loveButton setImageEdgeInsets:UIEdgeInsetsMake(0, hua_scale(0), hua_scale(0), hua_scale(5))];
    //[self.loveButton setTitleEdgeInsets:UIEdgeInsetsMake(0, hua_scale(-26), 0, 0)];
    
    //评论
    self.messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.messageButton.tag = 500;
    self.messageButton.titleLabel.font = [UIFont systemFontOfSize:hua_scale(11)];
    [self.messageButton setTitleColor:[UIColor grayColor] forState:0];
    
    [self.messageButton setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    self.messageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    [self.messageButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.messageButton setImageEdgeInsets:UIEdgeInsetsMake(0, hua_scale(0), 0, hua_scale(5))];
    
    
    
    //加入父视图
    NSArray *views = @[self.headView, self.nameLbale,self.contentLbale,self.picContainerView,self.timeButton,self.messageButton,self.loveButton];
    
    
    
    [views enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contentView addSubview:obj];
    }];
    
    UIView *contentView = self.contentView;
    CGFloat margin = hua_scale(10);
    
    self.headView.sd_layout
    .leftSpaceToView(contentView, hua_scale(margin))
    .topSpaceToView(contentView,hua_scale(25))
    .widthIs(hua_scale(32))
    .heightIs(hua_scale(30));
    
    self.nameLbale.sd_layout
    .leftSpaceToView(self.headView, hua_scale(margin))
    .topEqualToView(self.headView)
    .heightIs(hua_scale(9));
    [self.nameLbale setSingleLineAutoResizeWithMaxWidth:200];
    
    //    self.contentLbale.sd_layout
    //    .leftEqualToView(self.nameLbale)
    //    .topSpaceToView(self.nameLbale, margin)
    //    //.rightSpaceToView(contentView, hua_scale(10))
    //    .autoHeightRatio(0);
    //    [self.contentLbale setSingleLineAutoResizeWithMaxWidth:200];
    [self.contentLbale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLbale.mas_bottom).mas_equalTo(hua_scale(9));
        make.left.mas_equalTo(self.nameLbale);
        make.right.mas_equalTo(hua_scale(-10));
    }];
    
    [self.contentLbale updateLayout];
    self.picContainerView.sd_layout
    .leftEqualToView(self.contentLbale)
    .topSpaceToView(self.contentLbale,hua_scale(9));
    
    self.timeButton.sd_layout.
    leftEqualToView(self.picContainerView)
    .topSpaceToView(self.picContainerView,hua_scale(0))
    .widthIs(hua_scale(200))
    .heightIs(hua_scale(30));
    
    self.messageButton.sd_layout.
    rightSpaceToView(contentView,hua_scale(margin))
    .topSpaceToView(self.timeButton,0)
    .widthIs(hua_scale(70))
    .heightIs(hua_scale(30));
    
    self.loveButton.sd_layout.
    rightSpaceToView(self.messageButton,hua_scale(16))
    .topSpaceToView(self.timeButton,0)
    .widthIs(hua_scale(70))
    .heightIs(hua_scale(30));
    
    [self setupAutoHeightWithBottomView:self.loveButton bottomMargin:hua_scale(margin)];
}

//- (void)setArray:(NSArray *)array{
//    _array = array;
//
//    self.picContainerView.picPathStringsArray = array;
//}

- (void)setModel:(HUAStatusModel *)model
{
    _model = model;
    
    [self.timeButton setTitle:[HUATranslateTime translateTimeIntoCurrurents:model.time.integerValue] forState:0];
    [self.headView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.nameLbale.text = model.name;
    self.contentLbale.text = model.content;
    
    if ([[model.is_praise stringValue] isEqualToString:@"1"]) {
        self.loveButton.selected = YES;
    }else{
        self.loveButton.selected = NO;
    }
    [self.loveButton setTitle:model.praise forState:0];
    [self.messageButton setTitle:model.comment forState:0];
    
    
    
    
    self.picContainerView.picPathStringsArray = model.imageArray;
    
    NSMutableAttributedString *attributedStrings = [[NSMutableAttributedString alloc] initWithString:self.contentLbale.text];
    NSMutableParagraphStyle *paragraphStyles = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyles setLineSpacing:hua_scale(6)];
    [attributedStrings addAttribute:NSParagraphStyleAttributeName value:paragraphStyles range:NSMakeRange(0, [self.contentLbale.text length])];
    self.contentLbale.attributedText = attributedStrings;
    [self.contentLbale sizeToFit];
    
}

//点击事件

- (void)click:(UIButton *)btn{
    
    if (btn.tag == 500) {
        
        if (self.boolType==NO) {
            
            //跳转详情页面
            [self.delagate pusView:btn];
            
        }else{
            //回调评论
            self.pinlunBlock();
        }
        
        
    }else if (btn.tag == 501){
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        //点赞
        if (token!=nil) {
            btn.selected = !btn.selected;
            self.loveBlock();
        }else {
            self.loveBlock();
        }
    }
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
