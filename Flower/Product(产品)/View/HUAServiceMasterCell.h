//
//  HUAServiceMasterCell.h
//  Flower
//
//  Created by 程召华 on 16/1/15.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUAServiceMasterInfo.h"
@interface HUAServiceMasterCell : UITableViewCell
@property (nonatomic, strong) HUAServiceMasterInfo *masterInfo;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIImageView *praiseImageView;
@property (nonatomic, strong) UIImageView *rightArrow;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *praiseLabel;
@end
