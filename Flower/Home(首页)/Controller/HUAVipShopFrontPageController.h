//
//  HUAVipShopFrontPageController.h
//  Flower
//
//  Created by 程召华 on 16/1/13.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HUAVipShopFrontPageController : UIViewController
@property (nonatomic, strong) NSString *shop_id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, copy)void (^block)();
@end
