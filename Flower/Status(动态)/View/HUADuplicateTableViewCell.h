//
//  HUADuplicateTableViewCell.h
//  Flower
//
//  Created by apple on 16/2/25.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HUADuplicateTableViewCell : UITableViewCell
@property (nonatomic, strong)UIImageView *headView;
@property (nonatomic, strong)UILabel *nameLbale;
@property (nonatomic, strong)UILabel *contentLbale;
@property (nonatomic, strong)HUAStatusModel *model;

@property (nonatomic, strong)HUAWeiXinPhotoContainerView *picContainerView;
//时间
@property (nonatomic, strong)UIButton *timeButton;
//喜爱
@property (nonatomic, strong)UIButton *loveButton;
//留言
@property (nonatomic, strong)UIButton *messageButton;
@property (nonatomic, strong)UILabel *loveLabel;

//点击评论类型
@property (nonatomic, assign)BOOL boolType;

//点赞回调
@property (nonatomic, copy) void (^loveBlock)(void);

//评论回调
@property (nonatomic, copy) void (^pinlunBlock)(void);


@end
