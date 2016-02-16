//
//  HUAmodel.h
//  Flower
//
//  Created by apple on 16/1/9.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUAmodel : NSObject
//
@property (nonatomic, strong)NSString *content;

@property (nonatomic, strong)NSString *time;
//评论第几个评论的标示
@property (nonatomic, strong)NSString *comment_id;
//userId
@property (nonatomic, strong)NSString *user_id;

@property (nonatomic, strong)NSString *name;

@property (nonatomic, strong)NSString *icon;
//赞美
@property (nonatomic, strong)NSString *praise;
//评论
@property (nonatomic, strong)NSString *comment;

@property (nonatomic, strong)NSMutableArray *commentArray;

@property (nonatomic, strong)NSString *contentt;

//存放nickname
@property (nonatomic, strong)NSDictionary *nameDic;

@property (nonatomic, assign) BOOL isOpening;

@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;
@end
