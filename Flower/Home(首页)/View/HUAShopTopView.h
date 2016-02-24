//
//  HUAShopTopView.h
//  Flower
//
//  Created by 程召华 on 16/1/11.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUAShopIntroduce.h"

@protocol PhoneCallDelegate <NSObject>

- (void)makePhoneCall;

@end

@interface HUAShopTopView : UIView
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) HUAShopIntroduce *shopIntroduce;
@property (nonatomic, assign) id<PhoneCallDelegate>delegate;
@end
