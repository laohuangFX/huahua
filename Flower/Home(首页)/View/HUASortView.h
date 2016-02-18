//
//  HUASortView.h
//  Flower
//
//  Created by 程召华 on 16/1/28.
//  Copyright © 2016年 readchen.com. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef enum {
    HUASortViewButtonTypePopularity,
    HUASortViewButtonTypeDistance,
    HUASortViewButtonTypeShopName
} HUASortViewButtonType;


@protocol HUASortMenuDelegate <NSObject>

- (void)sortMenuDidDismiss:(HUASortViewButtonType)buttonType;


@end

@interface HUASortView : UIView
@property (nonatomic, weak) id<HUASortMenuDelegate> delegate;

@end
