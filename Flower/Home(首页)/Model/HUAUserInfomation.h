//
//  HUAUserInfomation.h
//  Flower
//
//  Created by 程召华 on 16/2/17.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUAUserInfomation : NSObject
/** 会员余额*/
@property (nonatomic, strong) NSString *money;
/** 判断点赞*/
@property (nonatomic, strong) NSString *hava_praised;
/** 判断收藏*/
@property (nonatomic, strong) NSString *have_collected;
@end
