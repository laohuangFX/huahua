//
//  HUAcommentsTableViewCell.h
//  Flower
//
//  Created by apple on 16/1/9.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUAmodel.h"
#import "HUAStatusModel.h"
@interface HUAcommentsTableViewCell : UITableViewCell
//头像
@property (nonatomic, strong)UIImageView *headImage;
//昵称
@property (nonatomic, strong)UILabel *nameLbale;
//时间
@property (nonatomic, strong)UIButton *timeButton;
//内容
@property (nonatomic, strong)UILabel *contentLbale;
//回复
@property (nonatomic, strong)UIView *replyView;
//显示更多信息按钮
@property (nonatomic, strong)UIButton *moreButton;

@property (nonatomic, strong)HUAmodel *modell;

@property (nonatomic, strong)UILabel *commentLabel;

//评论数组
@property (nonatomic, strong)NSMutableArray *pinLabelArrar;


@property (nonatomic, strong) NSIndexPath *indexPath;
//存用户名的key
@property (nonatomic, strong)NSDictionary *modelDic;


//点击更多信息回调block
@property (nonatomic, copy) void (^moreButtonClickedBlock)(NSIndexPath *indexPath);

//点击lable回复用户block
@property (nonatomic, copy) void (^commentLabelBlock)(NSString *nickNmae,NSString *parent_id,NSString *type,NSString *parent_user_id,UILabel *commentLable,NSIndexPath *indexPath);
//不能回复自己
@property (nonatomic, copy)void (^user_idSameBlock)(void);
@end
