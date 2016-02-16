//
//  HUATechnicianTableViewCell.h
//  Flower
//
//  Created by apple on 16/1/16.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUATechnicianModel.h"
@interface HUATechnicianTableViewCell : UITableViewCell
@property (nonatomic, strong)HUATechnicianModel *model;

//名字
@property (nonatomic, strong)UILabel *nameLbale;

@property (nonatomic, strong)UIButton *seletebutton;

@property (nonatomic, copy)void (^buttonBlock)(UIButton *button);
@end
