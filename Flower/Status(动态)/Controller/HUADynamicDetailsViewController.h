//
//  HUADynamicDetailsViewController.h
//  Flower
//
//  Created by apple on 16/1/9.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUAmodel.h"
#import "HUAStatusModel.h"
@interface HUADynamicDetailsViewController : UIViewController
@property (nonatomic, strong)HUAStatusModel *statusModel;
@property (nonatomic, strong)HUAmodel *modell;
@property (nonatomic, strong) NSString *shop_id;

//动态id
@property (nonatomic, strong)NSString *essay_id;
@end
