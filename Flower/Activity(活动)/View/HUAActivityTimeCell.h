//
//  HUAActivityTimeCell.h
//  Flower
//
//  Created by 程召华 on 16/1/8.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUADetailInfo.h"
@interface HUAActivityTimeCell : UITableViewCell

@property (nonatomic, strong) UILabel *activityTimeLabel;

//@property (nonatomic, strong) UILabel *articleLabel;

@property (nonatomic, strong) HUADetailInfo *timeInfo;
@end
