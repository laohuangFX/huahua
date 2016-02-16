//
//  HUASortView.h
//  Flower
//
//  Created by 程召华 on 16/1/28.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HUASortView;

@protocol HUASortMenuDelegate <NSObject>

- (void)sortMenuDidDismiss:(HUASortView *)menu;
- (void)sortMenuDidShow:(HUASortView *)menu;

@end

@interface HUASortView : UIView

@property (nonatomic, weak) id<HUASortMenuDelegate> delegate;

@end
