//
//  HUAVIPShopTopView.h
//  Flower
//
//  Created by 程召华 on 16/1/14.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUAShopIntroduce.h"

@protocol VipPhoneCallDelegate <NSObject>

- (void)vipMakePhoneCall;

@end


@interface HUAVIPShopTopView : UIView
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) HUAShopIntroduce *shopIntroduce;
@property (nonatomic, assign) id<VipPhoneCallDelegate>delegate;
@end
