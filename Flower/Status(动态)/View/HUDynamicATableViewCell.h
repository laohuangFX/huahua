//
//  HUDynamicATableViewCell.h
//  Flower
//
//  Created by apple on 16/1/8.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUAWeiXinPhotoContainerView.h"
#import "HUAStatusModel.h"

@protocol StatusModelDelegate <NSObject>

- (void)pusView:(UIButton *)sender;

@end
@interface HUDynamicATableViewCell : UITableViewCell
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
//点击评论类型
@property (nonatomic, assign)BOOL boolType;

@property (nonatomic, assign)id<StatusModelDelegate>delagate;

//点赞回调
@property (nonatomic, copy) void (^loveBlock)(void);

//评论回调
@property (nonatomic, copy) void (^pinlunBlock)(void);

@end
