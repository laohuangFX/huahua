//
//  HUAEditAddressViewController.h
//  Flower
//
//  Created by apple on 16/1/14.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUAAddressModel.h"
#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2

typedef void(^myBlock)(NSDictionary *InFotextDic);
//回调删除数据
typedef void(^RemoerBlock)(NSString *inFoaddr_id);

@interface HUAEditAddressViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>{
    UIPickerView *picker;
    
    
    NSDictionary *areaDic;
    NSArray *province;
    NSArray *city;
    NSArray *district;
    
    NSString *selectedProvince;
}
//传进来要修改的值的model
@property (nonatomic, strong)HUAAddressModel *model;

@property (nonatomic, copy)myBlock infoBlock;
@property (nonatomic, strong)RemoerBlock remoerBlock;
@property (nonatomic, strong)NSDictionary *addressDic;
@end
