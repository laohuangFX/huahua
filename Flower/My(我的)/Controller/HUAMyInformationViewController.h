//
//  HUAMyInformationViewController.h
//  Flower
//
//  Created by apple on 16/1/12.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SexBlock)(NSString *showSex);


@interface HUAMyInformationViewController : UIViewController
@property (nonatomic, copy) SexBlock block;

@property (nonatomic, strong)NSString *birthString;

//个人信息
@property (nonatomic, strong)NSDictionary *userDic;

@end
