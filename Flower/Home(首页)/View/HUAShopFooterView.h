//
//  HUAShopFooterView.h
//  Flower
//
//  Created by 程召华 on 16/1/14.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShopFooterViewDelegate <NSObject>

- (void)clickToJump:(NSString *)activeID;

@end



@interface HUAShopFooterView : UIView
@property (nonatomic, strong) NSArray *coverArray;
@property (nonatomic, strong) NSArray *idArray;

@property (nonatomic, assign) id<ShopFooterViewDelegate>delegate;
@end
