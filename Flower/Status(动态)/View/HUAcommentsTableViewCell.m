//
//  HUAcommentsTableViewCell.m
//  Flower
//
//  Created by apple on 16/1/9.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAcommentsTableViewCell.h"
#import "UIView+SDAutoLayout.h"
const CGFloat contentLabelFontSize = 15;
const CGFloat maxContentLabelHeight = 54;

@interface HUAcommentsTableViewCell ()
@property (nonatomic,strong)NSMutableArray *removeLabel;
@property (nonatomic, strong)UIView *thView;

@property (nonatomic, assign)BOOL shouldOpenContentLabel;


@end
@implementation HUAcommentsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    
    _shouldOpenContentLabel = NO;
    
    
    self.removeLabel = [NSMutableArray array];
    self.pinLabelArrar = [NSMutableArray array];
    
    //头像
    self.headImage = [UIImageView new];
    //self.headImage.backgroundColor = [UIColor redColor];
    
    //昵称
    self.nameLbale = [UILabel new];
    self.nameLbale.text = @"小绵羊";
    self.nameLbale.font = [UIFont systemFontOfSize:hua_scale(12)];
    self.nameLbale.textColor = HUAColor(0x576b96);
    
    
    //时间
    self.timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.timeButton setTitle:@"刚刚" forState:0];
    [self.timeButton setTitleColor:HUAColor(0xcecece) forState:0];
    self.timeButton.titleLabel.font = [UIFont systemFontOfSize:hua_scale(10)];
    [self.timeButton setImage:[UIImage imageNamed:@"time"] forState:0];
    self.timeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.timeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, hua_scale(4), 0, 0)];
    
    
    //内容
    self.contentLbale = [UILabel new];
    self.contentLbale.font = [UIFont systemFontOfSize:hua_scale(12)];
    self.contentLbale.numberOfLines = 0;
    self.contentLbale.text = @"我是假数据我";
    [self.contentLbale sizeToFit];
    //self.contentLbale.backgroundColor = [UIColor blueColor];
    self.contentLbale.textColor = HUAColor(0x494949);
    
    //回复
    self.replyView = [[UIView alloc] init];
    self.replyView.backgroundColor = HUAColor(0xf2f2f2);
    self.replyView.clipsToBounds = YES;
    
    _moreButton = [UIButton buttonWithType:UIButtonTypeSystem];
    //_moreButton.hidden = YES;
    //_moreButton.backgroundColor = [UIColor redColor];
    _moreButton.backgroundColor = HUAColor(0xf2f2f2);
    [_moreButton setTitle:@"查看更多回复" forState:UIControlStateNormal];
    [_moreButton setTitleColor:HUAColor(0x576b95) forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(moreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _moreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _moreButton.titleEdgeInsets = UIEdgeInsetsMake(0, hua_scale(5), 0, 0);
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:hua_scale(12)];
    
    
    
    //加入父视图
    NSArray *views = @[self.headImage, self.nameLbale,self.contentLbale,self.timeButton,self.replyView,self.moreButton];
    
    [views enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contentView addSubview:obj];
    }];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
    //头像
    self.headImage.sd_layout
    .leftSpaceToView(contentView,hua_scale(margin))
    .topSpaceToView(contentView,hua_scale(margin))
    .heightIs(hua_scale(22))
    .widthIs(hua_scale(22));
    
    self.nameLbale.sd_layout
    .leftSpaceToView(self.headImage,hua_scale(margin))
    .topEqualToView(self.headImage)
    .heightRatioToView(self.headImage,0.5);
    [self.nameLbale setSingleLineAutoResizeWithMaxWidth:200];
    
    self.timeButton.sd_layout
    .topSpaceToView(self.nameLbale,hua_scale(5))
    .leftEqualToView(self.nameLbale)
    .heightIs(hua_scale(15))
    .widthIs(hua_scale(200));
    
    
    self.contentLbale.sd_layout
    .leftEqualToView(self.timeButton)
    .topSpaceToView(self.timeButton,hua_scale(9))
    .rightSpaceToView(contentView,hua_scale(15))
    .autoHeightRatio(0);
    
    self.replyView.sd_layout
    .leftEqualToView(self.contentLbale)
    .topSpaceToView(self.contentLbale,hua_scale(9))
    .rightEqualToView(self.contentLbale)
    .heightIs(hua_scale(0));
    
    // morebutton的高度在setmodel里面设置
    _moreButton.sd_layout
    .leftEqualToView(_replyView)
    .topSpaceToView(_replyView, 0)
    .rightEqualToView(_replyView);
    
    [self setupAutoHeightWithBottomViewsArray:@[self.moreButton] bottomMargin:20];
    
}

- (void)setModell:(HUAmodel *)modell{
  
    
      _shouldOpenContentLabel = NO;
    //清理缓存
    [self removeOldPicturesAndReplys];
    if (modell != nil) {
        _modell = modell;
        
        self.nameLbale.text = modell.name;
        
        self.contentLbale.text = modell.content;
        
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:modell.icon] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        if (modell.commentArray.count>=4) {
            _moreButton.hidden = NO;
            _moreButton.sd_layout.heightIs(18);
            
        }else{
            _moreButton.sd_layout.heightIs(0);
            _moreButton.hidden = YES;
        }
        
        
        if (modell.commentArray.count>0) {
            float _upINt = 0;
            float _labelFh = 0;
            float _miniH = 0;
            UIView *lastView = nil;
            float _lastHeigth = 0;
            [self.moreButton updateLayout];

            for (int i = 0; i<modell.commentArray.count; i++) {
                self.commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(hua_scale(5), hua_scale(10)+_labelFh,hua_scale(250), 0)];
                if ([modell.commentArray[i][@"type"] isEqualToString:@"2"]) {
                    self.commentLabel.text = [NSString stringWithFormat:@"%@:%@",modell.commentArray[i][@"nickname"],modell.commentArray[i][@"content"]];
                }else{
                    
                    self.commentLabel.text = [NSString stringWithFormat:@"%@回复%@:%@",modell.commentArray[i][@"nickname"],modell.nameDic[modell.commentArray[i][@"parent_user_id"]] ,modell.commentArray[i][@"content"]];
                }
                self.commentLabel.numberOfLines = 0;
                //self.commentLabel.backgroundColor = [UIColor yellowColor];
                self.commentLabel.textColor =HUAColor(0x494949);
                self.commentLabel.tag = 9000+i;
                
                
                NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:self.commentLabel.text];
                //设置行间距
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setLineSpacing:hua_scale(5)];
                [att addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.commentLabel.text length])];
                
                
                if ([modell.commentArray[i][@"type"] isEqualToString:@"3"]) {
                    
                    NSRange range1 = [self.commentLabel.text rangeOfString:modell.commentArray[i][@"nickname"]];
                    NSRange range2 = [self.commentLabel.text rangeOfString:@":"];
                    
                    [att addAttributes:@{NSForegroundColorAttributeName:HUAColor(0x576b95)}  range:NSMakeRange(range1.location, range1.length)];
                    [att addAttributes:@{NSForegroundColorAttributeName:HUAColor(0x576b95)} range:NSMakeRange(range1.length+2, range2.location-range1.length-1)];
                    
                }else {
                    
                    NSRange rang = [self.commentLabel.text rangeOfString:modell.commentArray[i][@"nickname"]];
                    
                    [att addAttributes:@{NSForegroundColorAttributeName: HUAColor(0x576b95)}  range:NSMakeRange(0, rang.length+1)];
                }
                
                self.commentLabel.font = [UIFont systemFontOfSize:hua_scale(12)];
                self.commentLabel.userInteractionEnabled = YES;
                self.commentLabel.attributedText = att;
                [self.commentLabel sizeToFit];
                [self.replyView addSubview:self.commentLabel];
                [self.removeLabel addObject:self.commentLabel];
                
                
                [self.commentLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)]];
                
                //                if (i==0) {
                //                    [self.commentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                //                        make.left.mas_equalTo(self.replyView.mas_left).mas_equalTo(hua_scale(5));
                //                        make.top.mas_equalTo(self.replyView.mas_top).mas_equalTo(hua_scale(10));
                //                        make.right.mas_equalTo(hua_scale(-10));
                //
                //                    }];
                //                }else{
                //                    [self.commentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                //                        make.left.mas_equalTo(self.replyView.mas_left).mas_equalTo(hua_scale(5));
                //                        make.top.mas_equalTo(lastView.mas_bottom).mas_equalTo(hua_scale(10));
                //
                //
                //                    }];
                //                }
                
                
                
                
                [self.commentLabel updateLayout];
                _labelFh +=self.commentLabel.height+hua_scale(10);
                
                //记录最小限制的高度
                if (i==5) {
                    _miniH = _labelFh;
                }
                
                if (modell.commentArray.lastObject) {
                    [self.commentLabel updateLayout];
                    _lastHeigth = self.commentLabel.height;
                }
                
                if (modell.shouldShowMoreButton){
                    _moreButton.hidden = NO;
                    
                    if (modell.isOpening) {
                        //最大限制
                        
                        _upINt = _labelFh+_lastHeigth+10;
                        
                    }else{
                        //最小限制
                        
                        _upINt = _miniH+10;
                        
                    }
                }else {
                    
                    _upINt = _labelFh+hua_scale(10);
                    
                    _moreButton.hidden = YES;
                    //_replyView.hidden = NO;
                }
                
                
                [self.replyView sd_resetLayout];
                self.replyView.sd_layout
                .leftEqualToView(self.contentLbale)
                .topSpaceToView(self.contentLbale,hua_scale(9))
                .rightEqualToView(self.contentLbale)
                .heightIs(_labelFh+hua_scale(10))
                .maxHeightIs(_upINt);
                
                
                
                [self.replyView updateLayout];
                //NSLog(@"gao:%f",self.replyView.height);
                [self.moreButton sd_resetLayout];
                self.moreButton.sd_layout
                .topSpaceToView(self.replyView,0)
                .leftEqualToView(self.replyView)
                .rightEqualToView(self.replyView);
                
                
                [self setupAutoHeightWithBottomView:self.moreButton bottomMargin:hua_scale(20)];
                
                
                //记录上一个label
                lastView = self.commentLabel;
            }
            
        }else{
            self.replyView.height = 0;
            self.moreButton.height = 0;
            
            [self setupAutoHeightWithBottomView:self.contentLbale bottomMargin:hua_scale(20)];
        }
        
    }
}

//点击label触发方法
- (void)tapClick:(UITapGestureRecognizer *)tap{
    UILabel *label = (UILabel *)tap.view;
    
    //获取当前用户名
    HUAUserDetailInfo *detailInfo = [HUAUserDefaults getUserDetailInfo];
    
    if ([detailInfo.user_id isEqualToString:self.modell.commentArray[label.tag-9000][@"user_id"]]) {
        if (self.user_idSameBlock) {
            self.user_idSameBlock();
        }
        return;
    }
    
    
    if (self.commentLabelBlock) {
        self.commentLabelBlock(self.modell.commentArray[label.tag-9000][@"nickname"],self.modell.commentArray[label.tag-9000][@"parent_id"],self.modell.commentArray[label.tag-9000][@"type"],self.modell.commentArray[label.tag-9000][@"user_id"],(UILabel *)tap.view,self.indexPath);
    }
    
}
//防止cell重叠
-(void)removeOldPicturesAndReplys{
    
    
    
    
    for (int i = 0; i<self.removeLabel.count; i++) {
        
        UILabel *label = self.removeLabel[i];
        if (label) {
            [label removeFromSuperview];
        }
    }
    
    [self.removeLabel removeAllObjects];
}
- (void)click:(UIButton *)btn{
    btn.selected = !btn.selected;
    
}
- (void)moreButtonClicked:(UIButton *)sender
{
    if (self.moreButtonClickedBlock) {
        self.moreButtonClickedBlock(self.indexPath);
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
