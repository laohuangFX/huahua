//
//  HUABuyViewController.h
//  Flower
//
//  Created by apple on 16/1/15.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HUABuyViewController : UIViewController
//是否是会员
@property (nonatomic, assign)BOOL showType;

//会员信息
@property (nonatomic, strong)NSString *membersName;
@property (nonatomic, strong)NSString *membersType;
@property (nonatomic, strong)NSString *membersMoney;
@end
