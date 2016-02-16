//
//  HUAFunctionButtonView.h
//  Flower
//
//  Created by 程召华 on 16/1/5.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FunctionViewDelegate <NSObject>

- (void)clickToJump:(UIButton *)sender;

@end


@interface HUAFunctionButtonView : UIView
@property (nonatomic, strong) NSArray *functionImages;
@property (nonatomic, strong) NSArray *functionNames;

@property (nonatomic, weak) id<FunctionViewDelegate> delegate;
@end
