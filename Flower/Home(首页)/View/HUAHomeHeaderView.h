//
//  HUAHomeHeaderView.h
//  Flower
//
//  Created by 程召华 on 16/1/5.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeHeaderViewDelegate <NSObject>

- (void)clickToChooseCategory:(UIButton *)sender;

@end


@interface HUAHomeHeaderView : UIView

@property (nonatomic, strong)  NSArray *imagesURLStrings;
@property (nonatomic, strong) id<HomeHeaderViewDelegate> delegate;
@end
