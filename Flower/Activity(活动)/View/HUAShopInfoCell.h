//
//  HUAShopInfoCell.h
//  Flower
//
//  Created by 程召华 on 16/1/8.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUADetailInfo.h"

@protocol PhoneDelegate <NSObject>

- (void)makePhoneCall;

@end


@interface HUAShopInfoCell : UITableViewCell

@property (nonatomic, strong) UILabel *shopNameLabel;

@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) NSString *phoneNumber;

@property (nonatomic, strong) HUADetailInfo *shopInfo;

@property (nonatomic, assign) id<PhoneDelegate> delegate;
@end
