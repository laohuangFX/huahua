//
//  HUAStatusModel.h
//  Flower
//
//  Created by apple on 16/1/10.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUAStatusModel : NSObject
@property (nonatomic, strong)NSString *user_id;
@property (nonatomic, strong)NSString *time;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *icon;
@property (nonatomic, strong)NSString *praise;
@property (nonatomic, strong)NSString *comment;
@property (nonatomic, strong)NSString *content;
//是否点赞
@property (nonatomic, strong)NSString *is_praise;
//动态Id
@property (nonatomic, strong)NSString *essay_id;
@property (nonatomic,strong)NSArray *imageArray;



@end
