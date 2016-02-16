//
//  HUANameViewController.h
//  Flower
//
//  Created by apple on 16/1/14.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>
//利用block回调textField的值给昵称
typedef void(^ShowTextBlock)(NSString *text);

@interface HUANameViewController : UIViewController

@property (nonatomic, copy)ShowTextBlock nameBlock;

@property (nonatomic, strong)NSString *name;

@end
