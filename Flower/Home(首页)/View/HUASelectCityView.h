//
//  HUASelectCityView.h
//  Flower
//
//  Created by applewoainiqwe on 16/2/3.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUACityInfo.h"

typedef void(^CityBlock)(HUACityInfo * city);
@interface HUASelectCityView : UIView

@property (nonatomic,strong)NSMutableArray *cityArray;
@property (nonatomic,copy)CityBlock cityBlock;
@property (nonatomic,assign)BOOL isShow;


- (void)showView;
- (void)dismissView;

@end
