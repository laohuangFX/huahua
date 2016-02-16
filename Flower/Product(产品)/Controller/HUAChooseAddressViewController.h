//
//  HUAChooseAddressViewController.h
//  Flower
//
//  Created by apple on 16/2/8.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUAAddressModel.h"
@interface HUAChooseAddressViewController : UIViewController

@property (nonatomic, copy)void (^modelBlock)(HUAAddressModel *model);
@end
