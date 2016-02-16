//
//  HUASectionHeaderView.h
//  Flower
//
//  Created by 程召华 on 16/1/5.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ClickDelegate <NSObject>

- (void)clickSortButton:(UIButton *)sender;

@end
@interface HUASectionHeaderView : UIView

@property (nonatomic, weak) id<ClickDelegate> delegate;

@property (nonatomic, strong) UIButton *sortButton;

@end
