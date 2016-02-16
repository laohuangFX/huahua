//
//  HUAActivityDetailCell.h
//  Flower
//
//  Created by 程召华 on 16/1/8.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUADetailInfo.h"
#import "HUAWeiXinPhotoContainerView.h"

@interface HUAActivityDetailCell : UITableViewCell
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UIImageView *detailImageView;

@property (nonatomic, strong) HUADetailInfo *textAndImg;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong)HUAWeiXinPhotoContainerView *picContainerView;
@end
