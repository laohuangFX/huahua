//
//  HUAWeiXinPhotoContainerView.h
//  Flower
//
//  Created by apple on 16/1/8.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HUAWeiXinPhotoContainerView : UIView
@property (nonatomic, strong) NSArray *picPathStringsArray;
@property (nonatomic, copy)void (^endEdit)(void);
//自定义动态详情页评论标题的头部视图
+ (UIView *)initCommentsView;
@end
