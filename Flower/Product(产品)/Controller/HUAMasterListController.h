//
//  HUAMasterListController.h
//  Flower
//
//  Created by 程召华 on 16/1/18.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HUASearchSuperViewController.h"

@interface HUAMasterListController : HUASearchSuperViewController
@property (nonatomic, strong) NSString *shop_id;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *shopName;
@end
