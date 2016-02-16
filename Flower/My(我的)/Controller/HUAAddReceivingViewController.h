//
//  HUAAddReceivingViewController.h
//  Flower
//
//  Created by apple on 16/1/14.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2

typedef void(^InFoTextBlock)(NSArray *InFotext);
@interface HUAAddReceivingViewController : UIViewController{
    UIPickerView *picker;
    
    
    NSDictionary *areaDic;
    NSArray *province;
    NSArray *city;
    NSArray *district;
    
    NSString *selectedProvince;
}

@property (nonatomic, copy)InFoTextBlock inFoBlock;
@end
