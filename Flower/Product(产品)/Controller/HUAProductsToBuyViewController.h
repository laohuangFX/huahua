//
//  HUAProductsToBuyViewController.h
//  Flower
//
//  Created by apple on 16/1/17.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HUAProductsToBuyViewController : UIViewController
//产品购买
@property (nonatomic, strong) NSString *product_id;

//判断会员类型
@property (nonatomic, assign)BOOL typeBool;
//会员信息
@property (nonatomic, strong)NSString *membersName;
@property (nonatomic, strong)NSString *membersType;
@property (nonatomic, strong)NSString *membersMoney;

@end
