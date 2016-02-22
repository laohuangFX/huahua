//
//  HUATopInfoView.h
//  Flower
//
//  Created by 程召华 on 16/1/15.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUAProductDetailInfo.h"
@interface HUATopInfoView : UIView
@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UILabel *goodsNameLabel;
@property (nonatomic, strong) UILabel *specificationsLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *brandLabel;
@property (nonatomic, strong) UILabel *originLabel;
@property (nonatomic, strong) UILabel *Label;
@property (nonatomic, strong) UILabel *effectLabel;
@property (nonatomic, strong) UILabel *guaranteeTimeLabel;
@property (nonatomic, strong) UILabel *skinLabel;
@property (nonatomic, strong) UILabel *specialNoteLabel;
@property (nonatomic, strong) UILabel *specificationModelLabel;
//信息字典
@property (nonatomic, strong) NSDictionary *infomation;

@property (nonatomic, strong) HUAProductDetailInfo *detailInfo;

@property (nonatomic, assign) CGFloat topHeight;
//回调跳转视图
@property (nonatomic, copy) void (^pusViewsBlock)(void);


@property (nonatomic, copy) void (^topHeightBlock)(CGFloat topHeight);
@end
