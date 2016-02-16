//
//  HUAMakeAnAppointmentTableViewCell.h
//  Flower
//
//  Created by apple on 16/1/18.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HUAMakeAnAppointmentTableViewCell : UITableViewCell
//用来做适配的线
@property (nonatomic, strong)UIView *thView1;
@property (nonatomic, strong)UIView *thView2;
@property (nonatomic, strong)UIView *thView3;
@property (nonatomic, strong)UIView *thView4;
@property (nonatomic, strong)UIView *thView5;

@property (nonatomic, strong)NSDictionary *dateDic;

@property (nonatomic, strong)UILabel *dateLabel;
@property (nonatomic, strong)UILabel *weekLabel;

@property (nonatomic, strong)NSDictionary *typeDic;
//数据解析的类型，因为两个界面用同样的cell
@property (nonatomic, strong)NSString *jsonType;

//上班时间预约的数组数据
@property (nonatomic, strong)NSArray *range_list;

@property (nonatomic, copy)void (^buttonBlock)(UIButton *sender,NSString *range_type_id);
@end
