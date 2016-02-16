//
//  HUASearchSuperViewController.h
//  Flower
//
//  Created by applewoainiqwe on 16/2/3.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HUASearchSuperViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic,strong) NSString *searchplaceholder;


- (void)showSearchNav;
- (void)dismissBlackView;
@end
